Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbYK2QbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbYK2QbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 11:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYK2QbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 11:31:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:23497 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYK2QbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 11:31:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=vl8+ZNO2LYk0RQo4/50elE0kjVXOhRCUQgp5w0DFwNLuwvajBphC6RiW5klvPeb37z
         f0oDsRShUSACMYw10+Nkbc8GNdVUQdxYMR959d2E5opAWlQrERJQugzSNsyJx14yNorm
         08UdfokkjIIU5xH3aA33/jdGiodo5ccJ4lvQM=
Message-ID: <49316E4C.7070808@gmail.com>
Date: Sat, 29 Nov 2008 11:31:08 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: James.Bottomley@HansenPartnership.com
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] libsas: fix test for negative unsigned and typos
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned req->data_len cannot be negative, and fix typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I am not sure whether this is what was intended, please review.

diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 16f9312..6eb0779 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -199,12 +199,12 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_DISCOVER:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		if (req->data_len < 15) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 16;
 		resp_data_len -= 56;
 		sas_host_smp_discover(sas_ha, resp_data, req_data[9]);
 		break;
@@ -215,12 +215,12 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_REPORT_PHY_SATA:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		if (req->data_len < 15) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 16;
 		resp_data_len -= 60;
 		sas_report_phy_sata(sas_ha, resp_data, req_data[9]);
 		break;
@@ -238,12 +238,12 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_PHY_CONTROL:
-		req->data_len =- 44;
-		if (req->data_len < 0) {
+		if (req->data_len < 43) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 44;
 		resp_data_len -= 8;
 		sas_phy_control(sas_ha, req_data[9], req_data[10],
 				req_data[32] >> 4, req_data[33] >> 4,


