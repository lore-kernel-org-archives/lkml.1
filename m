Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbXDAVQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbXDAVQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 17:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbXDAVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 17:16:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37822 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbXDAVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 17:16:21 -0400
Date: Sun, 1 Apr 2007 23:17:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: mconf not removed by make mrproper
Message-ID: <20070401211705.GA11077@uranus.ravnborg.org>
References: <1170299149.32500.13.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170299149.32500.13.camel@nigel.suspend2.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 02:05:49PM +1100, Nigel Cunningham wrote:
> Hi.
> 
> The scripts/kconfig/mconf target isn't removed by the make mrproper
> target. I can see a couple of possibilities, but wasn't sure which you'd
> prefer, so thought I'd just raise the issue.
> 
> It's only an issue for me because my patch generation script relies on
> make mrproper making a properly clean tree.

Fixed - thanks.

	Sam

>From c428e4cd1fdddb5c1a33d6cd229148497ae03893 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@neptun.ravnborg.org>
Date: Sun, 1 Apr 2007 23:14:11 +0200
Subject: [PATCH] kbuild: remove kconfig binaries during make mrproper

Nigel Cunningham <nigel@nigel.suspend2.net> noticed
that 'make mrproper' did not remove mconf.
Fixed so we now remove all relevant binaries.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc:  Nigel Cunningham <nigel@nigel.suspend2.net>
---
 scripts/kconfig/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7e7e147..2e421bd 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -140,6 +140,7 @@ endif
 
 clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
 		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c
+clean-files     += mconf qconf gconf
 
 # Needed for systems without gettext
 KBUILD_HAVE_NLS := $(shell \
-- 
1.5.1.rc3.20.gaa453

