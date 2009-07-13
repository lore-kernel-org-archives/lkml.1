Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZGMKjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZGMKjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 06:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZGMKjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 06:39:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14094 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZGMKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 06:39:20 -0400
Date: Mon, 13 Jul 2009 12:39:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Fix staging drivers after smp_lock.h redux
Message-ID: <20090713123905.0cb257e5@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 405f55712dfe464b3240d7816cc4fe4174831be2 ("headers: smp_lock.h
redux") broke the build of two staging drivers. Fix them.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/staging/go7007/s2250-loader.c |    1 +
 drivers/staging/usbip/usbip_common.c  |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.31-rc2.orig/drivers/staging/go7007/s2250-loader.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.31-rc2/drivers/staging/go7007/s2250-loader.c	2009-07-13 11:38:39.000000000 +0200
@@ -17,6 +17,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <dvb-usb.h>
 
--- linux-2.6.31-rc2.orig/drivers/staging/usbip/usbip_common.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.31-rc2/drivers/staging/usbip/usbip_common.c	2009-07-13 12:31:18.000000000 +0200
@@ -18,6 +18,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 #include <linux/file.h>
 #include <linux/tcp.h>
 #include <linux/in.h>


-- 
Jean Delvare
