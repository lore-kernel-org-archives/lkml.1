Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbZHUHgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbZHUHgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZHUHgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:36:09 -0400
Received: from server1.wserver.cz ([82.113.45.157]:54929 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZHUHgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:36:08 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/1] kcore-use-registerd-physmem-information-fix2
Date: Fri, 21 Aug 2009 09:36:08 +0200
Message-Id: <1250840168-4614-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this compilation warning on x86_64:
fs/proc/kcore.c: In function ‘kclist_add_private’:
fs/proc/kcore.c:175: warning: comparison between pointer and integer

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/kcore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index aabbc3a..98fcf17 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -172,7 +172,7 @@ kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
 		ent->size = ULONG_MAX - ent->addr;
 
 	/* cut when vmalloc() area is higher than direct-map area */
-	if (VMALLOC_START > __va(0)) {
+	if (VMALLOC_START > (unsigned long)__va(0)) {
 		if (ent->addr > VMALLOC_START)
 			goto free_out;
 		if (VMALLOC_START - ent->addr < ent->size)
-- 
1.6.3.3

