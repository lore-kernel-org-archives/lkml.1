Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYFGKva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYFGKva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 06:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYFGKvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 06:51:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40243 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759253AbYFGKvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 06:51:05 -0400
Date: Sat, 7 Jun 2008 12:51:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Keith Owens <kaos@ocs.com.au>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Paulo Marques <pmarques@grupopie.com>
Subject: Re: [RFC PATCH] drop support for KALLSYMS_EXTRA_PASS
Message-ID: <20080607105146.GA25410@uranus.ravnborg.org>
References: <20080603210732.GA6247@uranus.ravnborg.org> <17789.1212657564@ocs10w>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17789.1212657564@ocs10w>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 07:19:24PM +1000, Keith Owens wrote:
> Sam Ravnborg (on Tue, 3 Jun 2008 23:07:32 +0200) wrote:
> >We have not seen any reports on inconsistent kallsysms data recently
> >as in the last one or two years. At least I do not recall these
> >and google had no hits in my searching.
> >
> >So I suggest removing this as to simplify the final linking.
> >When doing "make allyesconfig" build this extra linking
> >takes considerably time (and I usually forgoet to turn it off).
> >
> >In addition this patch removes the debug target: debug_kallsyms
> >
> >diff --git a/Makefile b/Makefile
> >-define verify_kallsyms
> >-	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
> >-	  echo '  $($(quiet)cmd_sysmap)  .tmp_System.map' &&)                \
> >-	  $(cmd_sysmap) .tmp_vmlinux$(last_kallsyms) .tmp_System.map
> >-	$(Q)cmp -s System.map .tmp_System.map ||                             \
> >-		(echo Inconsistent kallsyms data;                            \
> >-		 echo Try setting CONFIG_KALLSYMS_EXTRA_PASS;                \
> >-		 rm .tmp_kallsyms* ; /bin/false )
> >-endef
> 
> I am not happy about removing the check for inconsistent kallsyms data.
> Changes to the tool chain could cause this problem to recur and we
> would not pick up on it.  If we do keep the check for inconsistent data
> then we still need some way for the user to continue while the problem
> is investigated.
> 
> Since your real complaint seems to be the extra time taken in make
> allyesconfig then the solution is easy.  Change CONFIG_KALLSYMS_EXTRA_PASS
> to a Makefile option, KALLSYMS_EXTRA_PASS=y.  No extra time required in
> make allyesconfig.
The primary complaint are the additional complexity in the Makefile.
See http://lkml.org/lkml/2008/6/4/436 for a much simpler
and thus more hackable method for linking vmlinux.

	Sam
