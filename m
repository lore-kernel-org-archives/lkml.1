Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYLTXCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYLTXCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 18:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYLTXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 18:02:44 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45675 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754082AbYLTXCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 18:02:43 -0500
X-YMail-OSG: T.i5w6EVM1lmAWithrQLy1VYM3hpBakdCKC8qPQ9vJ_xGSMVYZ7KGUOQuf0S8_ULN72hi.LMM5riQPQjs7J63j2Kdxg9eU4Cllw2FNqxXUz89anIolOx_4pt6NEYfi4.HSXRnIfYUQZbGkTVm9d3yzr37fqvvp5d8BUWkFSVV8bkf1UY5MxoGKpjxNcreCJvMLMhk58by_gSuX7DX.yCCrB4Frsq6hbjeJzb4w.2Zngl4W5AUg8-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 5/8] [LIO-Target]: Add transport_free_session() in
	iscsi_target_login_thread() exception path
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 15:02:13 -0800
Message-Id: <1229814133.4560.202.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5717324513c2db0000d15af92083614aa28cee8b Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 02:55:22 -0800
Subject: [PATCH 5/8] [LIO-Target]: Add transport_free_session() in iscsi_target_login_thread() exception path

This patch adds transport_free_session() usage to iscsi_target_login_thread():new_sess_out
label to properly release the iscsi_session_t->se_sess allocated in iscsi_login_zero_tsih_s1()
with transport_init_session().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_login.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_login.c b/drivers/lio-core/iscsi_target_login.c
index 40d9b65..53c4ae5 100644
--- a/drivers/lio-core/iscsi_target_login.c
+++ b/drivers/lio-core/iscsi_target_login.c
@@ -1240,7 +1240,8 @@ new_sess_out:
 
 	if (!zero_tsih || !SESS(conn))
 		goto old_sess_out;
-
+	if (SESS(conn)->se_sess)
+		transport_free_session(SESS(conn)->se_sess);
 	if (SESS(conn)->sess_ops)
 		kfree(SESS(conn)->sess_ops);
 	if (SESS(conn))
-- 
1.5.4.1



