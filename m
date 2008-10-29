Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYJ2WuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYJ2WuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYJ2Woc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:44:32 -0400
Received: from kroah.org ([198.145.64.141]:43783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755907AbYJ2Wo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:28 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/49] Staging: w35und: remove macro magic from MLME_GetNextPacket()
Date: Wed, 29 Oct 2008 15:39:46 -0700
Message-Id: <1225320016-21803-19-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This removes the macro magic from MLME_GetNextPacket() to de-obfuscate the
code.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.0.2

