Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYLTXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYLTXAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 18:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYLTXAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 18:00:19 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45028 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752214AbYLTXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 18:00:17 -0500
X-YMail-OSG: EJkcmGsVM1lsmjbynSsGv6w2vU786mSHymnOP11CB.RgMRMLRTPQ09MBPSJE28Nh47g12qbzB0o4u0413f4XrdxuZzvBDd.fwyyWnhdhPJJF0tBteLvvmXZQ3I1lQ25IGhZSLbJnyQ6iCFiC7oZdlYf3p.CFce9OMZcysM9XYJ_hiBxGxlq7ZaYE.fypMjgwgO5aJPafnxBypzd38dt3dNFrH9EaVfBlfVfBDgLIUPBh1syFaPM-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 1/8] [Target_Core_Mod]: Add EXPORT_SYMBOL() to
	transport_release_cmd_to_pool()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 14:59:46 -0800
Message-Id: <1229813986.4560.193.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e55f26fb1dfd4e549208297d66735bcd80a4ffac Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 02:00:16 -0800
Subject: [PATCH 1/8] [Target_Core_Mod]: Add EXPORT_SYMBOL() to transport_release_cmd_to_pool()

This patch exports transport_release_cmd_to_pool() for transport core, which
is intended to be used by $FABRIC_MODs for release se_cmd_t, along with the
already exported transport_generic_free_cmd().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |    5 +++--
 drivers/lio-core/target_core_transport.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 9866584..ed042eb 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -214,7 +214,6 @@ struct kmem_cache *se_sess_cache = NULL;
 
 EXPORT_SYMBOL(se_global);
 extern int iscsi_release_sessions_for_tpg (iscsi_portal_group_t *, int);
-static void transport_release_cmd_to_pool (se_cmd_t *);
 static int transport_generic_write_pending (se_cmd_t *);
 static int transport_processing_thread (void *);
 
@@ -5930,7 +5929,7 @@ static int transport_generic_write_pending (se_cmd_t *cmd)
  *
  *
  */
-static void transport_release_cmd_to_pool (se_cmd_t *cmd)
+extern void transport_release_cmd_to_pool (se_cmd_t *cmd)
 {
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH) 
 		kfree(cmd->se_lun);
@@ -5943,6 +5942,8 @@ static void transport_release_cmd_to_pool (se_cmd_t *cmd)
 	return;
 }
 
+EXPORT_SYMBOL(transport_release_cmd_to_pool);
+
 /*	transport_generic_free_cmd():
  *
  *	Called from processing frontend to release storage engine resources
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index dce7bd6..9c989bd 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -182,6 +182,7 @@ extern int iscsi_send_check_condition_and_sense (se_cmd_t *, __u8, int);
 extern int core_tpg_persistent_reservation_check (se_cmd_t *);
 extern int core_tpg_persistent_reservation_release (se_cmd_t *);
 extern int core_tpg_persistent_reservation_reserve (se_cmd_t *);
+extern void transport_release_cmd_to_pool (se_cmd_t *);
 extern void transport_generic_free_cmd (se_cmd_t *, int, int, int);
 extern void transport_generic_wait_for_cmds (se_cmd_t *, int);
 extern int transport_generic_do_transform (struct se_cmd_s *, struct se_transform_info_s *);
-- 
1.5.4.1



