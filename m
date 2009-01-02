Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZABQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZABQdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbZABQc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:32:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:36211 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbZABQc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=w4HV1TCihEAPR3MF/9bn4q1vbt7U3PXbpoDGQJLadGdnhGBAOcoULcb7+FE/BpSjA7
         7adzK3PvwjFLt3ojLKrYl+zhMXKw8PRmnrSVCyBYdYIyxjL2SM9rMPfkPS7QRllK0ig5
         0VWvx83ha0zQPELUcXg3duHIWQ14fJiLtz7nk=
Message-ID: <495E41B7.6010706@gmail.com>
Date: Fri, 02 Jan 2009 17:32:55 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] [SCSI] libsas: fix test for negative unsigned and typos
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned req->data_len cannot be negative, and fix =-/-= typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 16f9312..d110a36 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -199,8 +199,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_DISCOVER:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		req->data_len -= 16;
+		if ((int)req->data_len < 0) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
@@ -215,8 +215,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_REPORT_PHY_SATA:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		req->data_len -= 16;
+		if ((int)req->data_len < 0) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
@@ -238,8 +238,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_PHY_CONTROL:
-		req->data_len =- 44;
-		if (req->data_len < 0) {
+		req->data_len -= 44;
+		if ((int)req->data_len < 0) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
