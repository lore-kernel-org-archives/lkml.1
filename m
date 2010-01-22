Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117Ab0AVNlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0AVNlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861Ab0AVNlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:41:22 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62793 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0AVNjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:39:22 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/12] lockdep: Fix the way to initialize class_mutex for information of file and line
Date: Fri, 22 Jan 2010 22:39:10 +0900
Message-Id: <1264167553-6510-10-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds __FILE__ and __LINE__ to arguments passed for
__mutex_init() called in __class_register().
This affects to lockdep_map of class_mutex of struct class_private,
and these will be used to make trace lock events more human friendly.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 161746d..cc0630f 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -162,7 +162,8 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	klist_init(&cp->class_devices, klist_class_dev_get, klist_class_dev_put);
 	INIT_LIST_HEAD(&cp->class_interfaces);
 	kset_init(&cp->class_dirs);
-	__mutex_init(&cp->class_mutex, "struct class mutex", key);
+	__mutex_init(&cp->class_mutex, "struct class mutex", key,
+		     __FILE__, __LINE__);
 	error = kobject_set_name(&cp->class_subsys.kobj, "%s", cls->name);
 	if (error) {
 		kfree(cp);
-- 
1.6.5.2

