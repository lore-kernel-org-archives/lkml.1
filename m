Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYJ0WOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYJ0WOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYJ0WOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:14:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50003 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYJ0WOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:14:15 -0400
Date: Tue, 28 Oct 2008 00:14:14 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] w35und: remove macro magic from MLME_GetNextPacket()
Message-ID: <Pine.LNX.4.64.0810280013460.9821@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This removes the macro magic from MLME_GetNextPacket() to de-obfuscate the
code.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mlmetxrx.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index eab562a..a071855 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -96,21 +96,15 @@ u8 MLMESendFrame(struct wb35_adapter * adapter, u8 *pMMPDU, u16 len, u8 DataType
 	return true;
 }
 
-void
-MLME_GetNextPacket(struct wb35_adapter * adapter, PDESCRIPTOR pDes)
+void MLME_GetNextPacket(struct wb35_adapter *adapter, PDESCRIPTOR desc)
 {
-#define DESCRIPTOR_ADD_BUFFER( _D, _A, _S ) \
-{\
-	_D->InternalUsed = _D->buffer_start_index + _D->buffer_number; \
-	_D->InternalUsed %= MAX_DESCRIPTOR_BUFFER_INDEX; \
-	_D->buffer_address[ _D->InternalUsed ] = _A; \
-	_D->buffer_size[ _D->InternalUsed ] = _S; \
-	_D->buffer_total_size += _S; \
-	_D->buffer_number++;\
-}
-
-	DESCRIPTOR_ADD_BUFFER( pDes, adapter->sMlmeFrame.pMMPDU, adapter->sMlmeFrame.len );
-	pDes->Type = adapter->sMlmeFrame.DataType;
+	desc->InternalUsed = desc->buffer_start_index + desc->buffer_number;
+	desc->InternalUsed %= MAX_DESCRIPTOR_BUFFER_INDEX;
+	desc->buffer_address[desc->InternalUsed] = adapter->sMlmeFrame.pMMPDU;
+	desc->buffer_size[desc->InternalUsed] = adapter->sMlmeFrame.len;
+	desc->buffer_total_size += adapter->sMlmeFrame.len;
+	desc->buffer_number++;
+	desc->Type = adapter->sMlmeFrame.DataType;
 }
 
 void MLMEfreeMMPDUBuffer(struct wb35_adapter * adapter, s8 *pData)
-- 
1.5.3.7

