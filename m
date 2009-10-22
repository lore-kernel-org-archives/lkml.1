Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZJVGD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZJVGD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZJVGD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:03:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39468 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZJVGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:30 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] HWPOISON: fix/proc/meminfo alignment
Date: Thu, 22 Oct 2009 08:02:30 +0200
Message-Id: <1256191352-6903-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1256191352-6903-6-git-send-email-andi@firstfloor.org>
References: <i>
 <1256191352-6903-1-git-send-email-andi@firstfloor.org>
 <1256191352-6903-2-git-send-email-andi@firstfloor.org>
 <1256191352-6903-3-git-send-email-andi@firstfloor.org>
 <1256191352-6903-4-git-send-email-andi@firstfloor.org>
 <1256191352-6903-5-git-send-email-andi@firstfloor.org>
 <1256191352-6903-6-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Given such a long name, the kB count in /proc/meminfo's HardwareCorrupted
line is being shown too far right (it does align with x86_64's VmallocChunk
above, but I hope nobody will ever have that much corrupted!).  Align it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/proc/meminfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index c7bff4f..a65239c 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -99,7 +99,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		"VmallocUsed:    %8lu kB\n"
 		"VmallocChunk:   %8lu kB\n"
 #ifdef CONFIG_MEMORY_FAILURE
-		"HardwareCorrupted: %8lu kB\n"
+		"HardwareCorrupted: %5lu kB\n"
 #endif
 		,
 		K(i.totalram),
-- 
1.6.0.2

