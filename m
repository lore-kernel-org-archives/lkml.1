Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab0CMBeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:34:19 -0500
Received: from kroah.org ([198.145.64.141]:60545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934821Ab0CMATk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:40 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001506.321117957@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Haicheng Li <haicheng.li@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 013/123] slab: initialize unused alien cache entry as NULL at alloc_alien_cache().
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

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
@@ -983,13 +983,11 @@ static struct array_cache **alloc_alien_
 
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


