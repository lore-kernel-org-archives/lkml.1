Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYJ2Wsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYJ2Wsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbYJ2Wo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:44:27 -0400
Received: from kroah.org ([198.145.64.141]:43767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756031AbYJ2WoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:18 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 14/49] Staging: w35und: remove usb_alloc_urb wrapper function
Date: Wed, 29 Oct 2008 15:39:41 -0700
Message-Id: <1225320016-21803-14-git-send-email-greg@kroah.com>
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
 drivers/staging/winbond/linux/wb35reg.c |    8 ++++----
 drivers/staging/winbond/linux/wb35rx.c  |    2 +-
 drivers/staging/winbond/linux/wb35tx.c  |    4 ++--
 drivers/staging/winbond/linux/wbusb_f.h |    7 -------
 4 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/winbond/linux/wb35reg.c b/drivers/staging/winbond/linux/wb35reg.c
index c2864b1..191322d 100644
--- a/drivers/staging/winbond/linux/wb35reg.c
+++ b/drivers/staging/winbond/linux/wb35reg.c
@@ -26,7 +26,7 @@ Wb35Reg_BurstWrite(phw_data_t pHwData, u16 RegisterNo, u32 * pRegisterData, u8 N
 	// Trying to use burst write function if use new hardware
 	UrbSize = sizeof(struct wb35_reg_queue) + DataSize + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if( urb && reg_queue ) {
 		reg_queue->DIRECT = 2;// burst write register
 		reg_queue->INDEX = RegisterNo;
@@ -175,7 +175,7 @@ Wb35Reg_Write(  phw_data_t pHwData,  u16 RegisterNo,  u32 RegisterValue )
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
 		reg_queue->DIRECT = 1;// burst write register
 		reg_queue->INDEX = RegisterNo;
@@ -235,7 +235,7 @@ Wb35Reg_WriteWithCallbackValue( phw_data_t pHwData, u16 RegisterNo, u32 Register
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC((void* *) &reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
 		reg_queue->DIRECT = 1;// burst write register
 		reg_queue->INDEX = RegisterNo;
@@ -342,7 +342,7 @@ Wb35Reg_Read(phw_data_t pHwData, u16 RegisterNo,  u32 * pRegisterValue )
 	// update the variable by send Urb to read register ------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if( urb && reg_queue )
 	{
 		reg_queue->DIRECT = 0;// read register
diff --git a/drivers/staging/winbond/linux/wb35rx.c b/drivers/staging/winbond/linux/wb35rx.c
index e565746..1326996 100644
--- a/drivers/staging/winbond/linux/wb35rx.c
+++ b/drivers/staging/winbond/linux/wb35rx.c
@@ -168,7 +168,7 @@ unsigned char Wb35Rx_initial(phw_data_t pHwData)
 	// Initial the Buffer Queue
 	Wb35Rx_reset_descriptor( pHwData );
 
-	pWb35Rx->RxUrb = wb_usb_alloc_urb(0);
+	pWb35Rx->RxUrb = usb_alloc_urb(0, GFP_ATOMIC);
 	return (!!pWb35Rx->RxUrb);
 }
 
diff --git a/drivers/staging/winbond/linux/wb35tx.c b/drivers/staging/winbond/linux/wb35tx.c
index c54ef30..9c928ee 100644
--- a/drivers/staging/winbond/linux/wb35tx.c
+++ b/drivers/staging/winbond/linux/wb35tx.c
@@ -134,11 +134,11 @@ unsigned char Wb35Tx_initial(phw_data_t pHwData)
 {
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
-	pWb35Tx->Tx4Urb = wb_usb_alloc_urb(0);
+	pWb35Tx->Tx4Urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!pWb35Tx->Tx4Urb)
 		return FALSE;
 
-	pWb35Tx->Tx2Urb = wb_usb_alloc_urb(0);
+	pWb35Tx->Tx2Urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!pWb35Tx->Tx2Urb)
 	{
 		usb_free_urb( pWb35Tx->Tx4Urb );
diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
index db47e1d..dd633ba 100644
--- a/drivers/staging/winbond/linux/wbusb_f.h
+++ b/drivers/staging/winbond/linux/wbusb_f.h
@@ -16,12 +16,5 @@ void WbUsb_destroy(phw_data_t pHwData);
 unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
 #define	WbUsb_Stop( _A )
 
-#define wb_usb_alloc_urb(_A) usb_alloc_urb(_A, GFP_ATOMIC)
-
 #define WbUsb_CheckForHang( _P )
 #define WbUsb_DetectStart( _P, _I )
-
-
-
-
-
-- 
1.6.0.2

