Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYGQR4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYGQR4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYGQRzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:55:55 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:39775
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYGQRzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:55:54 -0400
Subject: [PATCH] synclink_gt add serial bit order control
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 11:54:55 -0500
Message-Id: <1216313695.3842.26.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add control of hardware serial bit order between
LSB first (default/standard) and MSB first.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/include/linux/synclink.h	2008-07-17 11:45:48.000000000 -0500
+++ b/include/linux/synclink.h	2008-07-17 11:46:52.000000000 -0500
@@ -136,6 +136,7 @@
 #define MGSL_INTERFACE_RTS_EN   0x10
 #define MGSL_INTERFACE_LL       0x20
 #define MGSL_INTERFACE_RL       0x40
+#define MGSL_INTERFACE_MSB_FIRST 0x80
 
 typedef struct _MGSL_PARAMS
 {
--- a/drivers/char/synclink_gt.c	2008-07-17 08:39:06.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2008-07-17 11:45:10.000000000 -0500
@@ -4430,6 +4430,8 @@ static void msc_set_vcr(struct slgt_info
 		break;
 	}
 
+	if (info->if_mode & MGSL_INTERFACE_MSB_FIRST)
+		val |= BIT4;
 	if (info->signals & SerialSignal_DTR)
 		val |= BIT3;
 	if (info->signals & SerialSignal_RTS)


