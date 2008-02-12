Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbYBLJHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbYBLJHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYBLJGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:06:49 -0500
Received: from barikada.upol.cz ([158.194.242.200]:40479 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbYBLJGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:06:47 -0500
Date: Tue, 12 Feb 2008 10:25:04 +0100
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kbuild: fix make V=1
Message-ID: <20080212092504.GI24008@flower.upol.cz>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080211133137.GB20959@uranus.ravnborg.org> <20080211164709.GA22359@uranus.ravnborg.org> <E1JOiEG-0000do-0W@flower> <20080212085605.GB26865@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212085605.GB26865@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:56:05AM +0100, Sam Ravnborg wrote:
> On Tue, Feb 12, 2008 at 12:38:24AM +0100, Oleg Verych wrote:
> > * Date: Mon, 11 Feb 2008 17:47:09 +0100
> > []
> > > Mike spotted another missing thing from his initial
> > > patch so I folded it into the fix and pushed out
> > > a new kbuild.git tree.
> > >
> > > See updated patch below.
> > >
> > > 	Sam
> > 
> > Sam, do you agree my fix was more reliable (yea, not only efficient:)?
> You more or less just reverted the original patch - so it was obviously
> more reliable than introducing new stuff as the fix did.
> But we are at -r1 so I prefer to get the inteded behaviour
> and not the minmal fix.

Processing below changes arguments, not semantics of generated shell
code. And IMHO this is more reliable way of doing things. If one really
wants silence without commonly accepted ">/dev/null 2>&1" practice, then
choose portable "-n" argument for `echo`.

- quiet_chk_filechk = echo '  CHK     $@'
-silent_chk_filechk = :
- quiet_upd_filechk = echo '  UPD     $@'
-silent_upd_filechk = :
+quiet_chk_filechk = '  CHK     $@'
+quiet_upd_filechk = '  UPD     $@'
+
 define filechk
 	$(Q)set -e;				\
-	$($(quiet)chk_filechk);			\
+	echo $($(quiet)chk_filechk);		\
 	mkdir -p $(dir $@);			\
 	$(filechk_$(1)) < $< > $@.tmp;		\
 	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
 		rm -f $@.tmp;			\
 	else					\
-		$($(quiet)upd_filechk);		\
+		echo $($(quiet)upd_filechk);	\
 		mv -f $@.tmp $@;		\
 	fi
 endef
______
