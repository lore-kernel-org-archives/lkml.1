Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZI2KgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZI2KgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZI2KgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:36:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZI2KgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:36:09 -0400
Date: Tue, 29 Sep 2009 12:34:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv2 1/4] scsi: consistent use of __u8 in scsi/scsi.h
Message-ID: <20090929103407.GB11183@redhat.com>
References: <cover.1254220284.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1254220284.git.mst@redhat.com>
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
1.6.5.rc2

