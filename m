Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZEJOlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZEJOlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 10:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZEJOk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 10:40:57 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:38671 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbZEJOk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 10:40:57 -0400
Subject: [PATCH] mm: exit.c reorder wait_opts to remove padding on 64 bit
 builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain
Date: Sun, 10 May 2009 15:40:55 +0100
Message-Id: <1241966455.2724.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder struct wait_opts to remove 8 bytes of alignment padding on 64
bit builds

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

Hi Andrew,
Oleg asked me to send you this patch against your tree.

patch against latest mmotm.git.
successfully compiled but has had no other testing.

regards
Richard


diff --git a/kernel/exit.c b/kernel/exit.c
index 6e8c9fd..576e626 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1080,8 +1080,8 @@ SYSCALL_DEFINE1(exit_group, int, error_code)
 
 struct wait_opts {
 	enum pid_type		wo_type;
-	struct pid		*wo_pid;
 	int			wo_flags;
+	struct pid		*wo_pid;
 
 	struct siginfo __user	*wo_info;
 	int __user		*wo_stat;


