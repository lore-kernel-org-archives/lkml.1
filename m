Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbXJVJsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbXJVJsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXJVJsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:48:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36796 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbXJVJsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:48:15 -0400
Date: Mon, 22 Oct 2007 11:49:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Christian =?iso-8859-1?Q?Bj=F8levik?= <nafallo@magicalforest.se>,
       Deepak Saxena <dsaxena@mvista.com>, Armin Kuster <akuster@mvista.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: kbuild: disable depmod in cross-compile kernel build
Message-ID: <20071022094917.GA12064@uranus.ravnborg.org>
References: <200710192259.l9JMxENl018922@hera.kernel.org> <Pine.LNX.4.64.0710211948450.6155@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710211948450.6155@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Euh, is these really necessary?
> 
> At work I have no problems running depmod on an i386 system for ppc64 modules
> after I installed module-init-tools 3.3-pre2 (from Debian).
> I did have problems (depmod SEGV) using the depmod that came with CentOS
> 4 (from module-init-tools 3.1-pre5).

The patch was solely done due to people complaining and I even had a bugzilla
entry about it.
I expext Armin or Christian to speak up if this is a real problem for them.

PS. I did not do a revert since the original patch contained a nice cleanup.

	Sam

I have just committed the following:

>From d2c83557493c8595e2d3f31d0469bcf43d19b560 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@neptun.(none)>
Date: Mon, 22 Oct 2007 11:30:45 +0200
Subject: [PATCH] kbuild: allow depmod in cross builds again

depmod from module-init-tools 3.3-pre2 are reported
to work fine in cross build.
depmod from module-init-tools 3.1-pre5 are know to SEGV

Do not workaround older module-init-tools bug here.
The right fix is for users to upgrade module-init-tools.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index f4238b2..264f37b 100644
--- a/Makefile
+++ b/Makefile
@@ -1505,7 +1505,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 # and we build for the host arch
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = \
-	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" = "$(ARCH)" ]; then \
+	if [ -r System.map -a -x $(DEPMOD) ]; then                              \
 		$(DEPMOD) -ae -F System.map                                     \
 		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) -r)   \
 		$(KERNELRELEASE);                                               \
-- 
1.5.3.4.1157.g0e74-dirty

