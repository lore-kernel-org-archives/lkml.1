Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZA3SUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZA3SUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZA3SUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:20:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:61289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbZA3SUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:20:08 -0500
Message-ID: <498344E0.6000304@vlnb.net>
Date: Fri, 30 Jan 2009 21:20:16 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net
Subject: [PATCH][iSCSI-SCST]: Fix list corruption if SCST target registration
 fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18CO+yRr1uLzUkny+shD+pryMoXjG/giBwndu0
 VCvbvAnKT7Zpi21s5GPjOFaBaDK2GI/B637lcJjIcTcq7OWaLl
 0URzZVSJEHjLqf8rVmG9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes list corruption if SCST target registration fails.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>
Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: iscsi-scst/kernel/target.c
===================================================================
--- iscsi-scst/kernel/target.c	(revision 648)
+++ iscsi-scst/kernel/target.c	(working copy)
@@ -116,8 +116,6 @@ static int iscsi_target_create(struct ta
 	mutex_init(&target->target_mutex);
 	INIT_LIST_HEAD(&target->session_list);
 
-	list_add(&target->target_list_entry, &target_list);
-
 	target->scst_tgt = scst_register(&iscsi_template, target->name);
 	if (!target->scst_tgt) {
 		PRINT_ERROR("%s", "scst_register() failed");
@@ -125,6 +123,8 @@ static int iscsi_target_create(struct ta
 		goto out_free;
 	}
 
+	list_add(&target->target_list_entry, &target_list);
+
 	return 0;
 
 out_free:

