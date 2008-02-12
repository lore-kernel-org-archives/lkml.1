Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYBLUBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYBLUBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYBLUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:01:35 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46332 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYBLUBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:01:34 -0500
Date: Tue, 12 Feb 2008 21:01:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kbuild: fix make V=1
Message-ID: <20080212200141.GB2348@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080211133137.GB20959@uranus.ravnborg.org> <20080211164709.GA22359@uranus.ravnborg.org> <E1JOiEG-0000do-0W@flower> <20080212085605.GB26865@uranus.ravnborg.org> <20080212092504.GI24008@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212092504.GI24008@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:25:04AM +0100, Oleg Verych wrote:
> On Tue, Feb 12, 2008 at 09:56:05AM +0100, Sam Ravnborg wrote:
> > On Tue, Feb 12, 2008 at 12:38:24AM +0100, Oleg Verych wrote:
> > > * Date: Mon, 11 Feb 2008 17:47:09 +0100
> > > []
> > > > Mike spotted another missing thing from his initial
> > > > patch so I folded it into the fix and pushed out
> > > > a new kbuild.git tree.
> > > >
> > > > See updated patch below.
> > > >
> > > > 	Sam
> > > 
> > > Sam, do you agree my fix was more reliable (yea, not only efficient:)?
> > You more or less just reverted the original patch - so it was obviously
> > more reliable than introducing new stuff as the fix did.
> > But we are at -r1 so I prefer to get the inteded behaviour
> > and not the minmal fix.
> 
> Processing below changes arguments, not semantics of generated shell
> code. And IMHO this is more reliable way of doing things. If one really
> wants silence without commonly accepted ">/dev/null 2>&1" practice, then
> choose portable "-n" argument for `echo`.
> 
> - quiet_chk_filechk = echo '  CHK     $@'
> -silent_chk_filechk = :
> - quiet_upd_filechk = echo '  UPD     $@'
> -silent_upd_filechk = :
> +quiet_chk_filechk = '  CHK     $@'
> +quiet_upd_filechk = '  UPD     $@'
> +
>  define filechk
>  	$(Q)set -e;				\
> -	$($(quiet)chk_filechk);			\
> +	echo $($(quiet)chk_filechk);		\
The way we do this in other places in kbuild is a simple:
$(if $($(quiet)chk_filechk),echo '  $($(quiet)chk_filechk)'

And I think we should have done so originally here.

	Sam
