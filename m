Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbXLZDGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbXLZDGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 22:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXLZDFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 22:05:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:31329 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXLZDFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 22:05:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=v4T3N1FiyHnkDPWyjp6I9vwX6SwxC71BP4HmuNgT5+81kRUY407fOq4Zym67plNE3l3Y/JPpGR5v3T/WeIiZFeANcIn8TG1mrF1briu4jdviJTHCOTy7XIcPCD4cvw7rELp52J4bT1IzKZ62P60abjRxV4Fv+8lEJyoXQfbk5/U=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: <mark.fasheh@oracle.com>, <kurt.hackel@oracle.com>
Subject: [PATCH 2/2] fs/ocfs2: get rid of unnecessary initialization
Date: Wed, 26 Dec 2007 12:04:34 +0900
Message-ID: <000401c8476c$21f60330$47e7a8c0@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AchHajahPVJC/xakQHq5yO/C7QK3Eg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_groups was allocated with kcalloc, so initialization to NULL is unnecessary.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 fs/ocfs2/cluster/nodemanager.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index af2070d..113ef6b 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -840,7 +840,6 @@ static struct config_group *o2nm_cluster_group_make_group(struct config_group *g
 	cluster->cl_group.default_groups = defs;
 	cluster->cl_group.default_groups[0] = &ns->ns_group;
 	cluster->cl_group.default_groups[1] = o2hb_group;
-	cluster->cl_group.default_groups[2] = NULL;
 	rwlock_init(&cluster->cl_nodes_lock);
 	cluster->cl_node_ip_tree = RB_ROOT;
 	cluster->cl_reconnect_delay_ms = O2NET_RECONNECT_DELAY_MS_DEFAULT;
---

Thanks.
Joonwoo

