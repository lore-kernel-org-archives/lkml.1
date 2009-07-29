Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZG2LMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZG2LMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZG2LMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:12:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbZG2LMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:12:17 -0400
Date: Wed, 29 Jul 2009 14:11:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Message-ID: <20090729111114.GA15239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi/scsi.h is exported to userspace, so it should
use __u8 instead of u8 as other userspace-visible headers do.

This fixes the following errors when application includes scsi/scsi.h
generated with make headers_install:
include/scsi/scsi.h:145: error: expected specifier-qualifier-list before ‘u8’
include/scsi/scsi.h: In function ‘scsi_varlen_cdb_length’:
include/scsi/scsi.h:156: error: ‘struct scsi_varlen_cdb_hdr’ has no member named ‘additional_cdb_length’

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/scsi/scsi.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..dfcfaab 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -142,10 +142,10 @@ struct scsi_cmnd;
 
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
-- 
1.6.2.5
