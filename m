Return-Path: <linux-kernel-owner+w=401wt.eu-S1763185AbYA1WPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763185AbYA1WPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYA1WLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:11:04 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52266 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761248AbYA1WLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:11:00 -0500
Date: Tue, 29 Jan 2008 00:11:27 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Olaf Kirch <olaf.kirch@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make __iscsi_complete_pdu() static
Message-ID: <20080128221127.GX8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__iscsi_complete_pdu() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/libiscsi.c |    5 ++---
 include/scsi/libiscsi.h |    2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

4d4f211556f92590bfc32a243f562853c499b314 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 553168a..e794262 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -541,8 +541,8 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
  * queuecommand or send generic. session lock must be held and verify
  * itt must have been called.
  */
-int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-			 char *data, int datalen)
+static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				char *data, int datalen)
 {
 	struct iscsi_session *session = conn->session;
 	int opcode = hdr->opcode & ISCSI_OPCODE_MASK, rc = 0;
@@ -672,7 +672,6 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
 
 int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		       char *data, int datalen)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 889f51f..71eda24 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -349,8 +349,6 @@ extern int iscsi_conn_send_pdu(struct iscsi_cls_conn *, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 			      char *, int);
-extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
-				char *, int);
 extern int iscsi_verify_itt(struct iscsi_conn *, struct iscsi_hdr *,
 			    uint32_t *);
 extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);

