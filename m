Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbYHRUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbYHRUid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbYHRUiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:38:07 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:39687 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYHRUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=J8C1FvVxkRE5WeK712qTJ83vmWbFbxABS3IKMcybqhM0Yi22vZK668MfGYSTev4HjI
         BEMkf6ibdtZc0lXCb/gn/nQAJ+86vAlLQv55b7WkzBrSH10i+rmMWKOvyU5LHNcluPdl
         XRrClZhIpBm+6TUPBjebg4UUg/e+d+TKMHwuM=
Subject: [PATCH 2/2] pvrusb2: use proper byteorder interface
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 13:38:01 -0700
Message-Id: <1219091881.23637.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

___swab32 is an internal detail of the implementation.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I really suspect this should be something like be32_to_cpu...if this code
was written on an x86.

 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index f051c6a..7fa903a 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1314,8 +1314,7 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 		memcpy(fw_ptr, fw_entry->data + fw_done, bcnt);
 		/* Usbsnoop log shows that we must swap bytes... */
 		for (icnt = 0; icnt < bcnt/4 ; icnt++)
-			((u32 *)fw_ptr)[icnt] =
-				___swab32(((u32 *)fw_ptr)[icnt]);
+			((u32 *)fw_ptr)[icnt] = swab32(((u32 *)fw_ptr)[icnt]);
 
 		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,bcnt,
 				    &actual_length, HZ);
-- 
1.6.0.274.g8aacc

