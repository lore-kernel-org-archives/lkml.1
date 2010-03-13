Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936289Ab0CMBLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:11:15 -0500
Received: from kroah.org ([198.145.64.141]:46697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935357Ab0CMAax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:53 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002707.256946625@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Haicheng Li <haicheng.li@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [023/145] slab: initialize unused alien cache entry as NULL at alloc_alien_cache().
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Haicheng Li <haicheng.li@linux.intel.com>

commit f3186a9c51eabe75b2780153ed7f07778d78b16e upstream.

Comparing with existing code, it's a simpler way to use kzalloc_node()
to ensure that each unused alien cache entry is NULL.

CC: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slab.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -971,13 +971,11 @@ static struct array_cache **alloc_alien_
 
 	if (limit > 1)
 		limit = 12;
-	ac_ptr = kmalloc_node(memsize, gfp, node);
+	ac_ptr = kzalloc_node(memsize, gfp, node);
 	if (ac_ptr) {
 		for_each_node(i) {
-			if (i == node || !node_online(i)) {
-				ac_ptr[i] = NULL;
+			if (i == node || !node_online(i))
 				continue;
-			}
 			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
 			if (!ac_ptr[i]) {
 				for (i--; i >= 0; i--)


