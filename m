Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZHCL4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZHCL4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZHCL4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:56:36 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60365 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZHCL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=p1xHjg4P1GOYtxVj+7d+WK+JcVHTxS6kgGAAhR0HkWkco7gspLDR1VnXQlq7/XAESM
         0s4YTSTec8Hro1DxpURPji/aEg1si3dH8B+6VyqxljED1099Ez/nQxor+oQx0AZ8ZDBt
         YOuIC5QMeTvJtX5bSXMzITEmGsp719NqyLv2k=
Message-ID: <4A76D136.2040900@gmail.com>
Date: Mon, 03 Aug 2009 13:59:50 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mwave: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether index is within bounds before grabbing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 94ad2c3..c6e6345 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -281,12 +281,6 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 		case IOCTL_MW_REGISTER_IPC: {
 			unsigned int ipcnum = (unsigned int) ioarg;
 	
-			PRINTK_3(TRACE_MWAVE,
-				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
-				" ipcnum %x entry usIntCount %x\n",
-				ipcnum,
-				pDrvData->IPCs[ipcnum].usIntCount);
-	
 			if (ipcnum >= ARRAY_SIZE(pDrvData->IPCs)) {
 				PRINTK_ERROR(KERN_ERR_MWAVE
 						"mwavedd::mwave_ioctl:"
@@ -295,6 +289,12 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 						ipcnum);
 				return -EINVAL;
 			}
+			PRINTK_3(TRACE_MWAVE,
+				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
+				" ipcnum %x entry usIntCount %x\n",
+				ipcnum,
+				pDrvData->IPCs[ipcnum].usIntCount);
+	
 			lock_kernel();
 			pDrvData->IPCs[ipcnum].bIsHere = FALSE;
 			pDrvData->IPCs[ipcnum].bIsEnabled = TRUE;
@@ -310,11 +310,6 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 		case IOCTL_MW_GET_IPC: {
 			unsigned int ipcnum = (unsigned int) ioarg;
 	
-			PRINTK_3(TRACE_MWAVE,
-				"mwavedd::mwave_ioctl IOCTL_MW_GET_IPC"
-				" ipcnum %x, usIntCount %x\n",
-				ipcnum,
-				pDrvData->IPCs[ipcnum].usIntCount);
 			if (ipcnum >= ARRAY_SIZE(pDrvData->IPCs)) {
 				PRINTK_ERROR(KERN_ERR_MWAVE
 						"mwavedd::mwave_ioctl:"
@@ -322,6 +317,11 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 						" Invalid ipcnum %x\n", ipcnum);
 				return -EINVAL;
 			}
+			PRINTK_3(TRACE_MWAVE,
+				"mwavedd::mwave_ioctl IOCTL_MW_GET_IPC"
+				" ipcnum %x, usIntCount %x\n",
+				ipcnum,
+				pDrvData->IPCs[ipcnum].usIntCount);
 	
 			lock_kernel();
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
