Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZBLRLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZBLRLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZBLRLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:11:38 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58429 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZBLRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:11:38 -0500
Date: Thu, 12 Feb 2009 19:11:35 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       herbert@gondor.apana.org.au, kirill@shutemov.name,
       cl@linux-foundation.org, mpm@selenic.com, nickpiggin@yahoo.com.au
Subject: [GIT PULL] SLAB/SLOB/SLUB updates for 2.6.29-rc4
Message-ID: <Pine.LNX.4.64.0902121908580.14293@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

It contains patches that export ksize() to fix modular crypto build.

                Pekka

Kirill A. Shutemov (1):
      mm: Export symbol ksize()

 mm/slab.c |    1 +
 mm/slob.c |    1 +
 mm/slub.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index ddc41f3..4d00855 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4457,3 +4457,4 @@ size_t ksize(const void *objp)
 
 	return obj_size(virt_to_cache(objp));
 }
+EXPORT_SYMBOL(ksize);
diff --git a/mm/slob.c b/mm/slob.c
index bf7e8fc..52bc8a2 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -521,6 +521,7 @@ size_t ksize(const void *block)
 	} else
 		return sp->page.private;
 }
+EXPORT_SYMBOL(ksize);
 
 struct kmem_cache {
 	unsigned int size, align;
diff --git a/mm/slub.c b/mm/slub.c
index bdc9abb..0280eee 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2736,6 +2736,7 @@ size_t ksize(const void *object)
 	 */
 	return s->size;
 }
+EXPORT_SYMBOL(ksize);
 
 void kfree(const void *x)
 {
