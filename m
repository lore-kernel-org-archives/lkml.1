Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbZAHJcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbZAHJcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZAHJbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:31:31 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60826 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197AbZAHJb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:31:29 -0500
Date: Thu, 8 Jan 2009 11:31:28 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] w35und: remove useless macro from common.h
Message-ID: <Pine.LNX.4.64.0901081130530.15334@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The DebugUsbdStatusInformation macro doesn't do anything useful so remove the
definition and the two users of it from driver code.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/common.h  |    3 ---
 drivers/staging/winbond/wb35reg.c |    1 -
 drivers/staging/winbond/wb35rx.c  |    1 -
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/common.h b/drivers/staging/winbond/common.h
index 61ccc86..4409edd 100644
--- a/drivers/staging/winbond/common.h
+++ b/drivers/staging/winbond/common.h
@@ -4,9 +4,6 @@
 // This file contains the OS dependant definition and function.
 // Every OS has this file individual.
 //
-
-#define DebugUsbdStatusInformation( _A )
-
 #ifndef COMMON_DEF
 #define COMMON_DEF
 
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index c74b3fd..9d0a3aa 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -481,7 +481,6 @@ Wb35Reg_EP0VM_complete(struct urb *urb)
 		if (reg->EP0VM_status) {
 #ifdef _PE_REG_DUMP_
 			WBDEBUG(("EP0 IoCompleteRoutine return error\n"));
-			DebugUsbdStatusInformation( reg->EP0VM_status );
 #endif
 			reg->EP0vm_state = VM_STOP;
 			pHwData->SurpriseRemove = 1;
diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 7f8b6d7..63d5591 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -195,7 +195,6 @@ static void Wb35Rx_Complete(struct urb *urb)
 	if (pWb35Rx->EP3VM_status != 0) {
 		#ifdef _PE_USB_STATE_DUMP_
 		WBDEBUG(("EP3 IoCompleteRoutine return error\n"));
-		DebugUsbdStatusInformation( pWb35Rx->EP3VM_status );
 		#endif
 		pWb35Rx->EP3vm_state = VM_STOP;
 		goto error;
-- 
1.5.4.3

