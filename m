Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYJHVTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYJHVTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYJHVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:19:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42467 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYJHVTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:19:32 -0400
Message-ID: <48ED23AC.7090509@oracle.com>
Date: Wed, 08 Oct 2008 14:18:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
CC: arobinso@nyx.net
Subject: [PATCH] esp: fix section mismatch warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Not critical.

WARNING: drivers/char/esp.o(.text+0x278): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_version
The function show_serial_version() references
the variable __initdata serial_version.
This is often because show_serial_version lacks a __initdata 
annotation or the annotation of serial_version is wrong.

WARNING: drivers/char/esp.o(.text+0x27d): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_name
The function show_serial_version() references
the variable __initdata serial_name.
This is often because show_serial_version lacks a __initdata 
annotation or the annotation of serial_name is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew J. Robinson <arobinso@nyx.net>
---
 drivers/char/esp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lin2627-r9g1-sections.orig/drivers/char/esp.c
+++ lin2627-r9g1-sections/drivers/char/esp.c
@@ -2249,7 +2249,7 @@ static int esp_open(struct tty_struct *t
  * driver.
  */
 
-static void show_serial_version(void)
+static void __init show_serial_version(void)
 {
 	printk(KERN_INFO "%s version %s (DMA %u)\n",
 		serial_name, serial_version, dma);
