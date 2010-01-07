Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832Ab0AGOUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0AGOUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725Ab0AGOUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:20:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36079 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0AGOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=wz+tEBC5EQCiyE9fSkdFullft9rWwvRaskjxajgp0UM3cp0YAyV9in0648fhKt623f
         6Ka7+SO4uXEw0A16RuXFqa2EWbPH2KiqcppdY2RfvrXEzjB+PAt7uwEsYVw1lItofZGj
         cSQ0v2FOOBJJjdExLwxOj77RgkFxkb25SOJY4=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: James.Bottomley@suse.de, james.smart@emulex.com,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH,RESEND] scsi: use __uX types for headers exported to user space
Date: Thu,  7 Jan 2010 15:20:05 +0100
Message-Id: <1262874005-25089-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e4f5e29 (FC Pass Thru support) exported a number of header files
in include/scsi to user space, but didn't change the uX types to the
userspace-compatible __uX types. Without that you'll get compile errors
when including them - E.G.:

/tmp/include/scsi/scsi.h:145: error: expected specifier-qualifier-list
before ‘u8’

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 No feedback since 27/11, resending.

 include/scsi/scsi.h         |    8 ++++----
 include/scsi/scsi_netlink.h |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8b4deca..ec3053e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -149,10 +149,10 @@ struct scsi_cmnd;
 
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
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 536752c..7445c46 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -105,8 +105,8 @@ struct scsi_nl_host_vendor_msg {
  *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
  */
 #define SCSI_NL_VID_TYPE_SHIFT		56
-#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
-#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_MASK		((__u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_PCI		((__u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
 #define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
 
 
@@ -125,21 +125,21 @@ struct scsi_nl_host_vendor_msg {
 #include <scsi/scsi_host.h>
 
 /* Exported Kernel Interfaces */
-int scsi_nl_add_transport(u8 tport,
+int scsi_nl_add_transport(__u8 tport,
 	 int (*msg_handler)(struct sk_buff *),
 	void (*event_handler)(struct notifier_block *, unsigned long, void *));
-void scsi_nl_remove_transport(u8 tport);
+void scsi_nl_remove_transport(__u8 tport);
 
-int scsi_nl_add_driver(u64 vendor_id, struct scsi_host_template *hostt,
+int scsi_nl_add_driver(__u64 vendor_id, struct scsi_host_template *hostt,
 	int (*nlmsg_handler)(struct Scsi_Host *shost, void *payload,
-				 u32 len, u32 pid),
+				 __u32 len, __u32 pid),
 	void (*nlevt_handler)(struct notifier_block *nb,
 				 unsigned long event, void *notify_ptr));
-void scsi_nl_remove_driver(u64 vendor_id);
+void scsi_nl_remove_driver(__u64 vendor_id);
 
-void scsi_nl_send_transport_msg(u32 pid, struct scsi_nl_hdr *hdr);
-int scsi_nl_send_vendor_msg(u32 pid, unsigned short host_no, u64 vendor_id,
-			 char *data_buf, u32 data_len);
+void scsi_nl_send_transport_msg(__u32 pid, struct scsi_nl_hdr *hdr);
+int scsi_nl_send_vendor_msg(__u32 pid, unsigned short host_no, __u64 vendor_id,
+			 char *data_buf, __u32 data_len);
 
 #endif /* __KERNEL__ */
 
-- 
1.6.5

