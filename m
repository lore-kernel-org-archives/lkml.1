Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZKCE1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZKCE1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZKCE1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:27:36 -0500
Received: from ozlabs.org ([203.10.76.45]:39452 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbZKCE1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:27:35 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031457.39368.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:57:39 +1030
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 7/14] cpumask: avoid deprecated function in mm/slab.c
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These days we use cpumask_empty() which takes a pointer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1120,7 +1120,7 @@ static void __cpuinit cpuup_canceled(lon
 		if (nc)
 			free_block(cachep, nc->entry, nc->avail, node);
 
-		if (!cpus_empty(*mask)) {
+		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&l3->list_lock);
 			goto free_array_cache;
 		}

