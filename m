Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYJ2WsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYJ2WsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYJ2Wo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:44:26 -0400
Received: from kroah.org ([198.145.64.141]:43764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755971AbYJ2WoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:17 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 13/49] Staging: w35und: remove usb_submit_urb wrapper function
Date: Wed, 29 Oct 2008 15:39:40 -0700
Message-Id: <1225320016-21803-13-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

No need for a simple wrapper here.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wb35reg.c |    2 +-
 drivers/staging/winbond/linux/wb35rx.c  |    2 +-
 drivers/staging/winbond/linux/wb35tx.c  |    4 ++--
 drivers/staging/winbond/linux/wbusb_f.h |    1 -
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/linux/wb35reg.c b/drivers/staging/winbond/linux/wb35reg.c
index 041be81..c2864b1 100644
--- a/drivers/staging/winbond/linux/wb35reg.c
+++ b/drivers/staging/winbond/linux/wb35reg.c
@@ -434,7 +434,7 @@ Wb35Reg_EP0VM(phw_data_t pHwData )
 
 	reg->EP0vm_state = VM_RUNNING;
 
-	ret = wb_usb_submit_urb( urb );
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (ret < 0) {
 #ifdef _PE_REG_DUMP_
diff --git a/drivers/staging/winbond/linux/wb35rx.c b/drivers/staging/winbond/linux/wb35rx.c
index ae91b62..e565746 100644
--- a/drivers/staging/winbond/linux/wb35rx.c
+++ b/drivers/staging/winbond/linux/wb35rx.c
@@ -70,7 +70,7 @@ void Wb35Rx(  phw_data_t pHwData )
 
 	pWb35Rx->EP3vm_state = VM_RUNNING;
 
-	retv = wb_usb_submit_urb(urb);
+	retv = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (retv != 0) {
 		printk("Rx URB sending error\n");
diff --git a/drivers/staging/winbond/linux/wb35tx.c b/drivers/staging/winbond/linux/wb35tx.c
index 3c40e31..c54ef30 100644
--- a/drivers/staging/winbond/linux/wb35tx.c
+++ b/drivers/staging/winbond/linux/wb35tx.c
@@ -65,7 +65,7 @@ void Wb35Tx(phw_data_t pHwData)
 			  Wb35Tx_complete, pHwData);
 
 	pWb35Tx->EP4vm_state = VM_RUNNING;
-	retv = wb_usb_submit_urb( pUrb );
+	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 	if (retv<0) {
 		printk("EP4 Tx Irp sending error\n");
 		goto cleanup;
@@ -240,7 +240,7 @@ void Wb35Tx_EP2VM(phw_data_t pHwData)
 			  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, pHwData, 32);
 
 	pWb35Tx->EP2vm_state = VM_RUNNING;
-	retv = wb_usb_submit_urb( pUrb );
+	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 
 	if (retv < 0) {
 		#ifdef _PE_TX_DUMP_
diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
index 5a811f6..db47e1d 100644
--- a/drivers/staging/winbond/linux/wbusb_f.h
+++ b/drivers/staging/winbond/linux/wbusb_f.h
@@ -16,7 +16,6 @@ void WbUsb_destroy(phw_data_t pHwData);
 unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
 #define	WbUsb_Stop( _A )
 
-#define wb_usb_submit_urb(_A) usb_submit_urb(_A, GFP_ATOMIC)
 #define wb_usb_alloc_urb(_A) usb_alloc_urb(_A, GFP_ATOMIC)
 
 #define WbUsb_CheckForHang( _P )
-- 
1.6.0.2

