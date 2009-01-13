Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZAMMn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZAMMn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZAMMnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:43:49 -0500
Received: from tservice.net.ru ([195.178.208.66]:34383 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZAMMns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:43:48 -0500
Date: Tue, 13 Jan 2009 15:43:46 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Add two VFS exports used by POHMELFS
Message-ID: <20090113124346.GA26101@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

POHMELFS is a very high-performance parallel network filesystem with
coherent local cache of data and metadata. It entered maintenance mode
and is being prepared for the next submission cycle.
I decided first to push it into the drivers/staging which was acked
by Greg for the wider testing and review and move into the vanilla tree
in the next merge window.

POHMELFS needs two exports from the core VFS: add_to_page_cache_lru and
__lock_page_killable.

Please apply given patch to the current tree.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -513,6 +513,7 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(add_to_page_cache_lru);
 
 #ifdef CONFIG_NUMA
 struct page *__page_cache_alloc(gfp_t gfp)
@@ -627,6 +628,7 @@ int __lock_page_killable(struct page *page)
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sync_page_killable, TASK_KILLABLE);
 }
+EXPORT_SYMBOL_GPL(__lock_page_killable);
 
 /**
  * __lock_page_nosync - get a lock on the page, without calling sync_page()


-- 
	Evgeniy Polyakov
