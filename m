Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZAPDSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZAPDSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZAPDSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:18:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51864 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZAPDSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:18:33 -0500
Date: Fri, 16 Jan 2009 12:17:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       containers@lists.linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] use hierarchy mutex in creation failure path
Message-Id: <20090116121725.fff7dad9.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, cgrp->sibling is handled under hierarchy mutex.
error route should do so, too.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

Index: mmotm-2.6.29-Jan14/kernel/cgroup.c
===================================================================
--- mmotm-2.6.29-Jan14.orig/kernel/cgroup.c
+++ mmotm-2.6.29-Jan14/kernel/cgroup.c
@@ -2434,7 +2434,9 @@ static long cgroup_create(struct cgroup 
 
  err_remove:
 
+	cgroup_lock_hierarchy(root);
 	list_del(&cgrp->sibling);
+	cgroup_unlock_hierarchy(root);
 	root->number_of_cgroups--;
 
  err_destroy:

