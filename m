Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYJXBZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYJXBZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJXBZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:25:28 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:24996 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751015AbYJXBZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:25:27 -0400
X-YMail-OSG: dSnMqO4VM1m0RCxPunwqh3mZOl6hZZ1RMtutLZooxID9wCTcXNmrS0cew70iEC2b1mfRGLoqMT5DuVTC4vtcpXXuBgqXmdJuxICktF3ZAubS5Uu5Zk8YG6i0UbrYCPOkJPUjG2Nh4XTpLEJ7R8kFStLZz9yFvkcmrGUOv4odQxEWcGeupprJzvhGj_c-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [LIO-Target/ConfigFS]: Convert NACL_ATTR() and TPG_ATTR()
	to use internal show()/store()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 18:25:24 -0700
Message-Id: <1224811524.16558.24.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dce9b1143bf4a6fe4562972ded9cd5af30781ca2 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 23 Oct 2008 07:33:10 -0700
Subject: [PATCH] [LIO-Target/ConfigFS]: Convert NACL_ATTR() and TPG_ATTR() to use internal show()/store()

Using __CONFIGFS_EATTR_RO() and following TPG_PARAM_ATTR() and NACL_PARAM_ATTR(),
use the same internal function with macro agrument "_name" and get rid "_store"
and "_store" as macro arguments.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |   72 +++++++++---------------------
 1 files changed, 22 insertions(+), 50 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index fa3b6a0..0cf1813 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -727,66 +727,51 @@ static ssize_t lio_target_store_nacl_attrib_##name (			\
  * Define the iSCSI Node attributes using hybrid wrappers from include/linux/configfs.h
  */
 CONFIGFS_EATTR_STRUCT(iscsi_node_attrib, iscsi_node_attrib_s);
-#define NACL_ATTR(_name, _mode, _show, _store)				\
+#define NACL_ATTR(_name, _mode)						\
 static struct iscsi_node_attrib_attribute iscsi_node_attrib_##_name =	\
-		__CONFIGFS_EATTR(_name, _mode, _show, _store)
+		__CONFIGFS_EATTR(_name, _mode,				\
+		lio_target_show_nacl_attrib_##_name,			\
+		lio_target_store_nacl_attrib_##_name);			
 /*
  * Define iscsi_node_attrib_s_dataout_timeout
  */
 DEF_NACL_ATTRIB(dataout_timeout);
-NACL_ATTR(dataout_timeout, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_dataout_timeout,
-	lio_target_store_nacl_attrib_dataout_timeout);
+NACL_ATTR(dataout_timeout, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_node_attrib_s_dataout_timeout_retries
  */
 DEF_NACL_ATTRIB(dataout_timeout_retries);
-NACL_ATTR(dataout_timeout_retries, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_dataout_timeout_retries,
-	lio_target_store_nacl_attrib_dataout_timeout_retries);
+NACL_ATTR(dataout_timeout_retries, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_node_attrib_s_default_erl
  */
 DEF_NACL_ATTRIB(default_erl);
-NACL_ATTR(default_erl, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_default_erl,
-	lio_target_store_nacl_attrib_default_erl);
+NACL_ATTR(default_erl, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_node_attrib_s_nopin_timeout
  */
 DEF_NACL_ATTRIB(nopin_timeout);
-NACL_ATTR(nopin_timeout, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_nopin_timeout,
-	lio_target_store_nacl_attrib_nopin_timeout);
+NACL_ATTR(nopin_timeout, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_node_attrib_s_nopin_response_timeout
  */
 DEF_NACL_ATTRIB(nopin_response_timeout);
-NACL_ATTR(nopin_response_timeout, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_nopin_response_timeout,
-	lio_target_store_nacl_attrib_nopin_response_timeout);
+NACL_ATTR(nopin_response_timeout, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_node_attrib_s_random_datain_pdu_offsets
  */
 DEF_NACL_ATTRIB(random_datain_pdu_offsets);
-NACL_ATTR(random_datain_pdu_offsets, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_random_datain_pdu_offsets,
-	lio_target_store_nacl_attrib_random_datain_pdu_offsets);
+NACL_ATTR(random_datain_pdu_offsets, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_node_attrib_s_random_datain_seq_offsets
  */
 DEF_NACL_ATTRIB(random_datain_seq_offsets);
-NACL_ATTR(random_datain_seq_offsets, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_random_datain_seq_offsets,
-	lio_target_store_nacl_attrib_random_datain_seq_offsets);
+NACL_ATTR(random_datain_seq_offsets, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_node_attrib_s_random_r2t_offsets
  */
 DEF_NACL_ATTRIB(random_r2t_offsets);
-NACL_ATTR(random_r2t_offsets, S_IRUGO | S_IWUSR,
-	lio_target_show_nacl_attrib_random_r2t_offsets,
-	lio_target_store_nacl_attrib_random_r2t_offsets);
-
+NACL_ATTR(random_r2t_offsets, S_IRUGO | S_IWUSR);
 /*
  * Finally, define functions iscsi_node_attrib_s_attr_show() and
  * iscsi_node_attrib_s_attr_store() for lio_target_nacl_attrib_ops below..
@@ -1617,58 +1602,45 @@ out:									\
 CONFIGFS_EATTR_STRUCT(iscsi_tpg_attrib, iscsi_tpg_attrib_s);
 #define TPG_ATTR(_name, _mode, _show, _store)				\
 static struct iscsi_tpg_attrib_attribute iscsi_tpg_attrib_##_name =	\
-	__CONFIGFS_EATTR(_name, _mode, _show, _store)
+	__CONFIGFS_EATTR(_name, _mode,					\
+		lio_target_show_tpg_attrib_##_name,			\
+		lio_target_store_tpg_attrib_##_name);		
 
 /*
  * Define iscsi_tpg_attrib_s_authentication
  */
 DEF_TPG_ATTRIB(authentication);
-TPG_ATTR(authentication, S_IRUGO | S_IWUSR,
-	lio_target_show_tpg_attrib_authentication,
-	lio_target_store_tpg_attrib_authentication);
+TPG_ATTR(authentication, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_tpg_attrib_s_login_timeout
  */
 DEF_TPG_ATTRIB(login_timeout);
-TPG_ATTR(login_timeout, S_IRUGO | S_IWUSR,
-	lio_target_show_tpg_attrib_login_timeout,
-	lio_target_store_tpg_attrib_login_timeout);
+TPG_ATTR(login_timeout, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_tpg_attrib_s_netif_timeout
  */
 DEF_TPG_ATTRIB(netif_timeout);
-TPG_ATTR(netif_timeout, S_IRUGO | S_IWUSR,
-	lio_target_show_tpg_attrib_netif_timeout,
-	lio_target_store_tpg_attrib_netif_timeout);
+TPG_ATTR(netif_timeout, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_tpg_attrib_s_generate_node_acls
  */
 DEF_TPG_ATTRIB(generate_node_acls);
-TPG_ATTR(generate_node_acls, S_IRUGO | S_IWUSR,
-	lio_target_show_tpg_attrib_generate_node_acls,
-	lio_target_store_tpg_attrib_generate_node_acls);
+TPG_ATTR(generate_node_acls, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_tpg_attrib_s_default_cmdsn_depth
  */
 DEF_TPG_ATTRIB(default_cmdsn_depth);
-TPG_ATTR(default_cmdsn_depth, S_IRUGO | S_IWUSR,
-	lio_target_show_tpg_attrib_default_cmdsn_depth,
-	lio_target_store_tpg_attrib_default_cmdsn_depth);
+TPG_ATTR(default_cmdsn_depth, S_IRUGO | S_IWUSR);
 /*
  Define iscsi_tpg_attrib_scache_dynamic_acls
  */
 DEF_TPG_ATTRIB(cache_dynamic_acls);
-TPG_ATTR(cache_dynamic_acls, S_IRUGO | S_IWUSR,
-	lio_target_show_tpg_attrib_cache_dynamic_acls,
-	lio_target_store_tpg_attrib_cache_dynamic_acls);
+TPG_ATTR(cache_dynamic_acls, S_IRUGO | S_IWUSR);
 /*
  * Define iscsi_tpg_attrib_sdemo_mode_lun_access
  */
 DEF_TPG_ATTRIB(demo_mode_lun_access);
-TPG_ATTR(demo_mode_lun_access, S_IRUGO | S_IWUSR,
-	lio_target_show_tpg_attrib_demo_mode_lun_access,
-	lio_target_store_tpg_attrib_demo_mode_lun_access);
-
+TPG_ATTR(demo_mode_lun_access, S_IRUGO | S_IWUSR);
 /*
  * Finally, define functions iscsi_tpg_attrib_s_attr_show() and
  * iscsi_tpg_attrib_s_attr_store() for lio_target_tpg_attrib_ops below..
-- 
1.5.4.1



