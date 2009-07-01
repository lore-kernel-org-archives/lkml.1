Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbZGABRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbZGABRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761626AbZGAAf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:58 -0400
Received: from kroah.org ([198.145.64.141]:60737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575AbZGAAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:43 2009
Message-Id: <20090701002443.637484445@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zygo Blaxell <zygo.blaxell@xandros.com>,
       Jiri Kosina <trivial@kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: [patch 102/108] lib/genalloc.c: remove unmatched write_lock() in gen_pool_destroy
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=lib-genalloc.c-remove-unmatched-write_lock-in-gen_pool_destroy.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zygo Blaxell <zygo.blaxell@xandros.com>

commit 8e8a2dea0ca91fe2cb7de7ea212124cfe8c82c35 upstream.

There is a call to write_lock() in gen_pool_destroy which is not balanced
by any corresponding write_unlock().  This causes problems with preemption
because the preemption-disable counter is incremented in the write_lock()
call, but never decremented by any call to write_unlock().  This bug is
gen_pool_destroy, and one of them is non-x86 arch-specific code.

Signed-off-by: Zygo Blaxell <zygo.blaxell@xandros.com>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/genalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -85,7 +85,6 @@ void gen_pool_destroy(struct gen_pool *p
 	int bit, end_bit;
 
 
-	write_lock(&pool->lock);
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);


