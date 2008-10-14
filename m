Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYJNAzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYJNAzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYJNAyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:54:50 -0400
Received: from ozlabs.org ([203.10.76.45]:38033 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbYJNAyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:54:50 -0400
To: <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, <yhlu.kernel@gmail.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 14 Oct 2008 11:53:05 +1100
Subject: [PATCH] Fix broken debug output reserve_region_with_split()
Message-Id: <20081014005428.EC2D8DDF93@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That debug outpout in kernel/resource.c is busted on 32-bit
machines, fix it with appropriate casts.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

One day Yinghai will figure out that resource_size_t can be 32-bit
and thus as printk arguments must be cast to (unsigned long long)
explicitely when using %llx... hopefully, that day, Ingo will also
catch these before committing them as it's not the first one like
this :-)


 kernel/resource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-work.orig/kernel/resource.c	2008-10-14 11:48:31.000000000 +1100
+++ linux-work/kernel/resource.c	2008-10-14 11:48:50.000000000 +1100
@@ -550,8 +550,9 @@ static void __init __reserve_region_with
 
 	if (!res) {
 		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-			 conflict->name, conflict->start, conflict->end,
-			 name, start, end);
+		       conflict->name, (unsigned long long)conflict->start,
+		       (unsigned long long)conflict->end,
+		       name, (unsigned long long)start, (unsigned long long)end);
 
 		/* failed, split and try again */
 

