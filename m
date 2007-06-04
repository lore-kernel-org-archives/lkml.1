Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbXFDMR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbXFDMR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXFDMRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:17:22 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:5086 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXFDMRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:17:22 -0400
Date: Mon, 4 Jun 2007 16:26:16 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: xemul@sw.ru, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH -mm] Fix /proc/slab_allocators re seq_list_next() conversion
Message-ID: <20070604122616.GA6155@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong pointer was used as kmem_cache pointer.

[Here /proc/slab_allocators appears as empty file, but it's just me, probably]

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4401,7 +4401,7 @@ static void show_symbol(struct seq_file *m, unsigned long address)
 
 static int leaks_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *cachep = p;
+	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, next);
 	struct slab *slabp;
 	struct kmem_list3 *l3;
 	const char *name;

