Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbZAZJIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbZAZJIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZAZJIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:08:10 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:41585 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752250AbZAZJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:08:08 -0500
X-YMail-OSG: 8QovnlAVM1l_lhpUt8TJVjPA8a2sln_FNI0ltamHla15zZh70GBntUr6aLQdkqYAvAopmHf1_7GXwypbsNw8UD0rtTL.8Ea6mPtq9ET1mA99Cj6NTDRMNnrcXeoy5NVKlRI7EvnBj8SAIrygHybhWHPPXeWTeDYmUs2KKS1ThtAcmeNt4tHHF9xkWeQFnfpBCCoe8GKOnevskYWnb._ZDMZVNPvnHzZOJRtT3KaYjBqBf6dfpws-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 2/7] [LIO-Target]: Convert
	iscsi_send_check_condition_and_sense ->
	transport_send_check_condition_and_sense()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 01:07:45 -0800
Message-Id: <1232960865.24642.124.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 858884071810c0ac99ad7e3d0efcc08b7253905f Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:35:00 -0800
Subject: [PATCH 2/7] [LIO-Target]: Convert iscsi_send_check_condition_and_sense -> transport_send_check_condition_and_sense()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c      |    2 +-
 drivers/lio-core/iscsi_target_erl0.c |    6 +++---
 drivers/lio-core/iscsi_target_erl1.c |    2 +-
 drivers/lio-core/iscsi_target_util.c |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index fc9b6c9..2a952d6 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -1922,7 +1922,7 @@ static inline int iscsi_handle_data_out (iscsi_conn_t *conn, unsigned char *buf)
 		if (SESS_OPS_C(conn)->InitialR2T) {
 			TRACE_ERROR("Received unexpected unsolicited data"
 				" while InitialR2T=Yes, protocol error.\n");
-			iscsi_send_check_condition_and_sense(SE_CMD(cmd),
+			transport_send_check_condition_and_sense(SE_CMD(cmd),
 					UNEXPECTED_UNSOLICITED_DATA, 0);
 			return(-1);
 		}
diff --git a/drivers/lio-core/iscsi_target_erl0.c b/drivers/lio-core/iscsi_target_erl0.c
index 4bd5c19..98f8e90 100644
--- a/drivers/lio-core/iscsi_target_erl0.c
+++ b/drivers/lio-core/iscsi_target_erl0.c
@@ -62,7 +62,7 @@ extern int iscsi_close_session (iscsi_session_t *);
 extern int iscsi_close_connection (iscsi_conn_t *);
 
 /* From target_core_mod */
-extern int iscsi_send_check_condition_and_sense (iscsi_cmd_t *, __u8, int);
+extern int transport_send_check_condition_and_sense (iscsi_cmd_t *, __u8, int);
 
 
 /*	iscsi_set_dataout_sequence_values():
@@ -211,7 +211,7 @@ static inline int iscsi_dataout_check_unsolicited_sequence (
 		TRACE_ERROR("Total %u bytes exceeds FirstBurstLength: %u"
 			" for this Unsolicited DataOut Burst.\n",
 			first_burst_len, SESS_OPS_C(conn)->FirstBurstLength);
-		iscsi_send_check_condition_and_sense(cmd,
+		transport_send_check_condition_and_sense(cmd,
 				INCORRECT_AMOUNT_OF_DATA, 0);
 		return(DATAOUT_CANNOT_RECOVER);
 	}
@@ -236,7 +236,7 @@ static inline int iscsi_dataout_check_unsolicited_sequence (
 				" equal ExpXferLen %u.\n", first_burst_len,
 				SESS_OPS_C(conn)->FirstBurstLength,
 				cmd->data_length);
-			iscsi_send_check_condition_and_sense(cmd,
+			transport_send_check_condition_and_sense(cmd,
 					INCORRECT_AMOUNT_OF_DATA, 0);
 			return(DATAOUT_CANNOT_RECOVER);
 		}
diff --git a/drivers/lio-core/iscsi_target_erl1.c b/drivers/lio-core/iscsi_target_erl1.c
index 9cb0f31..3408d82 100644
--- a/drivers/lio-core/iscsi_target_erl1.c
+++ b/drivers/lio-core/iscsi_target_erl1.c
@@ -1022,7 +1022,7 @@ extern int iscsi_execute_cmd (iscsi_cmd_t *cmd, int ooo)
 			}
 			spin_unlock_bh(&cmd->istate_lock);
 
-			return(iscsi_send_check_condition_and_sense(se_cmd,
+			return(transport_send_check_condition_and_sense(se_cmd,
 					se_cmd->scsi_sense_reason, 0));	
 		}
 		
diff --git a/drivers/lio-core/iscsi_target_util.c b/drivers/lio-core/iscsi_target_util.c
index ea66704..842d09e 100644
--- a/drivers/lio-core/iscsi_target_util.c
+++ b/drivers/lio-core/iscsi_target_util.c
@@ -627,7 +627,7 @@ extern int iscsi_check_unsolicited_dataout (iscsi_cmd_t *cmd, unsigned char *buf
 	if (SESS_OPS_C(conn)->InitialR2T) {
 		TRACE_ERROR("Received unexpected unsolicited data"
 			" while InitialR2T=Yes, protocol error.\n");
-		iscsi_send_check_condition_and_sense(se_cmd,
+		transport_send_check_condition_and_sense(se_cmd,
 				UNEXPECTED_UNSOLICITED_DATA, 0);
 		return(-1);
 	}
@@ -638,7 +638,7 @@ extern int iscsi_check_unsolicited_dataout (iscsi_cmd_t *cmd, unsigned char *buf
 			" for this Unsolicited DataOut Burst.\n",
 			(cmd->first_burst_len + hdr->length),
 				SESS_OPS_C(conn)->FirstBurstLength);
-		iscsi_send_check_condition_and_sense(se_cmd,
+		transport_send_check_condition_and_sense(se_cmd,
 				INCORRECT_AMOUNT_OF_DATA, 0);
 		return(-1);
 	}
@@ -654,7 +654,7 @@ extern int iscsi_check_unsolicited_dataout (iscsi_cmd_t *cmd, unsigned char *buf
 			" not equal ExpXferLen %u.\n",
 			(cmd->first_burst_len + hdr->length),
 			SESS_OPS_C(conn)->FirstBurstLength, cmd->data_length);
-		iscsi_send_check_condition_and_sense(se_cmd,
+		transport_send_check_condition_and_sense(se_cmd,
 				INCORRECT_AMOUNT_OF_DATA, 0);
 		return(-1);
 	}
-- 
1.5.4.1



