Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZDWVXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZDWVXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZDWVXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:23:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZDWVXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:23:45 -0400
Date: Thu, 23 Apr 2009 23:19:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: mm_need_new_owner: use ->real_parent to search in
	the siblings
Message-ID: <20090423211920.GA22377@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Search in the siblings" should use ->real_parent, not ->parent. If the
task is traced then ->parent == tracer, while the task's parent is always
->real_parent.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/exit.c~	2009-04-09 00:39:10.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-04-23 23:08:37.000000000 +0200
@@ -590,7 +590,7 @@ retry:
 	/*
 	 * Search in the siblings
 	 */
-	list_for_each_entry(c, &p->parent->children, sibling) {
+	list_for_each_entry(c, &p->real_parent->children, sibling) {
 		if (c->mm == mm)
 			goto assign_new_owner;
 	}

