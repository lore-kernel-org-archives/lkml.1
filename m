Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941Ab0A2KTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0A2KTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716Ab0A2KTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:19:33 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42032 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0A2KTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:19:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=BfenbMVJGxkejytYGXiVQjmBf92X00zSM67ZSYdcT/cE4gQ0PrLhdu4QquOLTJftiF
         PFPL2vjbXeiQGWIndJJ/ZhMcjQSV5825kxLU4aF/MxJ4IrDhlw8K2iTnDc8+BvgIKSuv
         u7LMquBKMMUEe/wRjgFZzyftHRwq1t2LVCnI8=
Message-ID: <4B62B78F.2010404@gmail.com>
Date: Fri, 29 Jan 2010 11:25:19 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] qla2xxx: negative error return in qla2x00_change_queue_depth()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *change_queue_depth functions usually return a negative error return.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8529eb1..0753877 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1258,7 +1258,7 @@ qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 		qla2x00_adjust_sdev_qdepth_up(sdev, qdepth);
 		break;
 	default:
-		return EOPNOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return sdev->queue_depth;
