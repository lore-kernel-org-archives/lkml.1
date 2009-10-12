Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZJLIY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZJLIY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZJLIY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:24:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:43668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbZJLIY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:24:26 -0400
Message-ID: <4AD2E791.2000006@kernel.org>
Date: Mon, 12 Oct 2009 17:23:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] percpu fixes for 2.6.32-rc2
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 08:23:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following percpu fix branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

It only contains build warning fix for 32bit archs.

Thanks.
---
Tejun Heo (1):
      percpu: fix compile warnings

 mm/percpu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4a048ab..6af78c1 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1870,13 +1870,14 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
 	max_distance = 0;
 	for (group = 0; group < ai->nr_groups; group++) {
 		ai->groups[group].base_offset = areas[group] - base;
-		max_distance = max(max_distance, ai->groups[group].base_offset);
+		max_distance = max_t(size_t, max_distance,
+				     ai->groups[group].base_offset);
 	}
 	max_distance += ai->unit_size;

 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
-		pr_warning("PERCPU: max_distance=0x%lx too large for vmalloc "
+		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
 			   "space 0x%lx\n",
 			   max_distance, VMALLOC_END - VMALLOC_START);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
