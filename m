Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbXKWT1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbXKWT1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 14:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXKWT1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 14:27:06 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55659 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbXKWT1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 14:27:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] utsns: Restore proper namespace handling.
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       <linux-kernel@vger.kernel.org>
Date: Fri, 23 Nov 2007 12:25:29 -0700
Message-ID: <m11wagpxw6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_UTS_NS was removed it seems that we also deleted
the code for handling sysctls in the other then the initial
uts namespace.   This patch restores that code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/utsname_sysctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index c76c064..71f58c3 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -18,6 +18,8 @@
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
+	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
+	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
 
 	if (!write)
 		down_read(&uts_sem);
-- 
1.5.3.rc6.17.g1911

