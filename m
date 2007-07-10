Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbXGJMoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbXGJMoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbXGJMoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:01 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56634 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750872AbXGJMoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:00 -0400
Date: Tue, 10 Jul 2007 14:44:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] rivafb_setup() must be __devinit
Message-ID: <20070710124433.GQ3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux
WARNING: drivers/built-in.o(.text+0x57106): Section mismatch: reference to .init.text:rivafb_setup (between 'rivafb_init' and 'nv3Busy')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/video/riva/fbdev.c.old	2007-07-10 03:54:58.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/video/riva/fbdev.c	2007-07-10 03:55:17.000000000 +0200
@@ -2146,7 +2146,7 @@
  * ------------------------------------------------------------------------- */
 
 #ifndef MODULE
-static int __init rivafb_setup(char *options)
+static int __devinit rivafb_setup(char *options)
 {
 	char *this_opt;
 

