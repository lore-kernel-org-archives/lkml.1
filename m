Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYCMLdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYCMLdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYCMLcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:32:53 -0400
Received: from sacred.ru ([62.205.161.221]:34070 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbYCMLcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:32:52 -0400
Message-ID: <47D910BD.2010805@openvz.org>
Date: Thu, 13 Mar 2008 14:32:13 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Shmem: compilation fix for !NUMA case
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 13 Mar 2008 14:32:14 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shmem_parse_mpol stub's 3rd argument is a pointer on flags:

  CC      mm/shmem.o
mm/shmem.c: In function ‘shmem_parse_options’:
mm/shmem.c:2228: warning: passing argument 3 of ‘shmem_parse_mpol’ makes integer from pointer without a cast

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 mm/shmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 281f6c2..e40f56d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1215,7 +1215,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
 static inline int shmem_parse_mpol(char *value, unsigned short *policy,
-				unsigned short flags, nodemask_t *policy_nodes)
+				unsigned short *flags, nodemask_t *policy_nodes)
 {
 	return 1;
 }
