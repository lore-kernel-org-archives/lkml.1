Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZJ1RSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZJ1RSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZJ1RSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:18:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33416 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167AbZJ1RSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:18:22 -0400
Subject: [PATCH 2/3] kmemleak: Show the age of an unreferenced object
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 28 Oct 2009 17:18:26 +0000
Message-ID: <20091028171826.19220.54561.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091028171426.19220.658.stgit@pc1117.cambridge.arm.com>
References: <20091028171426.19220.658.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-1-g9f9ed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2009 17:18:26.0774 (UTC) FILETIME=[A94F7760:01CA57F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jiffies shown for unreferenced objects isn't always meaningful to
people debugging kernel memory leaks. This patch adds the age as well to
the displayed information.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index f06c092..ce79d91 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -346,11 +346,13 @@ static void print_unreferenced(struct seq_file *seq,
 			       struct kmemleak_object *object)
 {
 	int i;
+	unsigned int msecs_age = jiffies_to_msecs(jiffies - object->jiffies);
 
 	seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
 		   object->pointer, object->size);
-	seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
-		   object->comm, object->pid, object->jiffies);
+	seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu (age %d.%03ds)\n",
+		   object->comm, object->pid, object->jiffies,
+		   msecs_age / 1000, msecs_age % 1000);
 	hex_dump_object(seq, object);
 	seq_printf(seq, "  backtrace:\n");
 

