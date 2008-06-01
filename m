Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYFAXe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYFAXe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbYFAX3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:29:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYFAX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=ascSlQ/UK38VAM9gKaOJeEpubew1HXk5siYd1uh0Co89Wl82sh1TOnK1r9QlGYo3zyTpJbuYOd91DsN2TR/EnBdrWXv8GYu2gXI81Y1Fin4WfIjJfmKzfRTCuXSoKB6ol/oDaxkInmZoUf+GbZ6CjiFSPvQphxs4nneDQA201RI=
Message-Id: <20080601231648.183353549@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:51 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Brian King <brking@us.ibm.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org
Subject: [patch -v2 22/23] ipr: use memory_read_from_buffer
Content-Disposition: inline; filename=scsi-ipr-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ipr.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: 2.6-git/drivers/scsi/ipr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/ipr.c
+++ 2.6-git/drivers/scsi/ipr.c
@@ -2455,20 +2455,14 @@ static ssize_t ipr_read_trace(struct kob
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 	unsigned long lock_flags = 0;
-	int size = IPR_TRACE_SIZE;
-	char *src = (char *)ioa_cfg->trace;
-
-	if (off > size)
-		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
+	ssize_t ret;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	memcpy(buf, &src[off], count);
+	ret = memory_read_from_buffer(buf, count, &off, ioa_cfg->trace,
+				IPR_TRACE_SIZE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return count;
+
+	return ret;
 }
 
 static struct bin_attribute ipr_trace_attr = {

-- 
