Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYBGQsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYBGQsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYBGQsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:48:36 -0500
Received: from serv.smile.org.ua ([193.178.237.153]:2746 "EHLO
	serv.smile.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYBGQsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:48:35 -0500
Date: Thu, 7 Feb 2008 18:48:32 +0200
From: Andy Shevchenko <andy@smile.org.ua>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Possible bug fix in the ehci-hcd
Message-ID: <20080207164832.GL20508@serv.smile.org.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
X-Operating-System: Linux 2.4.21-50.EL.aspsmp i586
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The Sequans company who produce WiMAX chips provides the USB driver and kthp
addon driver. However the USB device doesn't work correctly.

Here is more true hack for Sequans SQN11x0 based modem.

P.S. For more details, please, ask Sequans staff (see Signed-off-by lines).

Signed-off-by: Andy Shevchenko <andy@smile.org.ua>
Signed-off-by: Gosne Stephane <sgosne@sequans.com>

--- a/drivers/usb/host/ehci-q.c.orig	2008-02-07 16:53:18.000000000 +0200
+++ b/drivers/usb/host/ehci-q.c	2008-02-07 16:53:18.000000000 +0200
@@ -750,8 +750,14 @@
 			info1 |= 1 << 14;	/* toggle from qtd */
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else if (type == PIPE_BULK) {
+			struct usb_device_descriptor *desc = &urb->dev->descriptor;
 			info1 |= (EHCI_TUNE_RL_HS << 28);
-			info1 |= 512 << 16;	/* usb2 fixed maxpacket */
+			/* Special hook for SQN11x0 */
+			if (desc->idVendor == 0x148e && desc->idProduct == 0x0900) {
+				info1 |= max_packet (maxp) << 16;
+			} else {
+				info1 |= 512 << 16;	/* usb2 fixed maxpacket */
+			}
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
 			info1 |= max_packet (maxp) << 16;

-- 
With best regards,
Andy Shevchenko.      mailto: andy@smile.org.ua


