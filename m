Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbZGOCTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbZGOCTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbZGOCTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:19:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34185 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZGOCTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:19:19 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jul 2009 07:49:03 +0530
Message-Id: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following fix is inspired by David Howells fix few days back:
http://lkml.org/lkml/2009/7/9/109,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
---

--- a/fs/ubifs/commit.c	2009-05-20 10:44:12.000000000 +0530
+++ b/fs/ubifs/commit.c	2009-07-15 05:39:06.000000000 +0530
@@ -510,7 +510,7 @@ int dbg_check_old_index(struct ubifs_inf
 	int lnum, offs, len, err = 0, uninitialized_var(last_level), child_cnt;
 	int first = 1, iip;
 	struct ubifs_debug_info *d = c->dbg;
-	union ubifs_key lower_key, upper_key, l_key, u_key;
+	union ubifs_key uninitialized_var(lower_key), upper_key, l_key, u_key;
 	unsigned long long uninitialized_var(last_sqnum);
 	struct ubifs_idx_node *idx;
 	struct list_head list;

---
Regards--
Subrata

