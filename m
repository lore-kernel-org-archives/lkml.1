Return-Path: <linux-kernel-owner+w=401wt.eu-S1765664AbYESNk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765664AbYESNk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762509AbYESNcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:32:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50468 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932188AbYESNcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:32:48 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ip2: Fix crashes on load/unload
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Date: Mon, 19 May 2008 14:20:53 +0100
Message-ID: <20080519132053.578.45185.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

This doesn't need to be two modules, and making it one cleans up the
problem
---

 drivers/char/ip2/Makefile  |    4 ++--
 drivers/char/ip2/ip2main.c |   23 -----------------------
 2 files changed, 2 insertions(+), 25 deletions(-)


diff --git a/drivers/char/ip2/Makefile b/drivers/char/ip2/Makefile
index 6bfe254..939618f 100644
--- a/drivers/char/ip2/Makefile
+++ b/drivers/char/ip2/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Computone IntelliPort Plus Driver
 #
 
-obj-$(CONFIG_COMPUTONE)         += ip2.o ip2main.o
+obj-$(CONFIG_COMPUTONE)         += ip2.o
 
-ip2-objs			:= ip2base.o
+ip2-objs			:= ip2base.o ip2main.o
 
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 70957ac..c12cf8f 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -346,27 +346,6 @@ have_requested_irq( char irq )
 }
 
 /******************************************************************************/
-/* Function:   init_module()                                                  */
-/* Parameters: None                                                           */
-/* Returns:    Success (0)                                                    */
-/*                                                                            */
-/* Description:                                                               */
-/* This is a required entry point for an installable module. It simply calls  */
-/* the driver initialisation function and returns what it returns.            */
-/******************************************************************************/
-#ifdef MODULE
-static int __init
-ip2_init_module(void)
-{
-#ifdef IP2DEBUG_INIT
-	printk (KERN_DEBUG "Loading module ...\n" );
-#endif
-    return 0;
-}
-module_init(ip2_init_module);
-#endif /* MODULE */
-
-/******************************************************************************/
 /* Function:   cleanup_module()                                               */
 /* Parameters: None                                                           */
 /* Returns:    Nothing                                                        */
@@ -779,8 +758,6 @@ out:
 	return err;
 }
 
-EXPORT_SYMBOL(ip2_loadmain);
-
 /******************************************************************************/
 /* Function:   ip2_init_board()                                               */
 /* Parameters: Index of board in configuration structure                      */

