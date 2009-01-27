Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbZA0WIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbZA0WIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZA0WIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:08:37 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40133 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751857AbZA0WIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:08:36 -0500
X-YMail-OSG: UUpT7jYVM1mFrsFIljPypP5aMgKSFOdW.i4vgnIVY4TzlANMPe7b1f2XsuCOEbD2uvsJuHs8mmRxjpiXgrQdpR3ggIWziPWyE.Deresu8ML6v_qJb1jHN826ifm4XvrwvvCtv1rymRlGfwE3RBshYkCvVjVggcTMDe3G6Liou8N9XWVfe3Nh_Q3f4mF.5tzZlHhS3QJnudiCr_Uv8TEHVI234yqaaB94KlRkC.2cVqWAKPJd_Mc-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 2/4] [Target_Core_Mod]: Change RECEIVE_CREDENTIAL ->
	VARIABLE_LENGTH_CMD
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 14:07:27 -0800
Message-Id: <1233094047.6442.103.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f55bb2d93bc8bd37d18e99b19929c635016df537 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 13:32:12 -0800
Subject: [PATCH 2/4] [Target_Core_Mod]: Change RECEIVE_CREDENTIAL -> VARIABLE_LENGTH_CMD

This patch changes transport_generic_cmd_sequencer() logic to use VARIABLE_LENGTH_CMD
instead of RECEIVE_CREDENTIAL, which is now defined as a VARIABLE_LENGTH_CMD
service action (VLC_SA_RECEIVE_CREDENTIAL) in linux/include/scsi/scsi.h

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index ad2dd75..a0a7710 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4612,7 +4612,7 @@ static int transport_generic_cmd_sequencer (
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
-	case RECEIVE_CREDENTIAL:
+	case VARIABLE_LENGTH_CMD:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[10] << 8) | cdb[11];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
-- 
1.5.4.1



