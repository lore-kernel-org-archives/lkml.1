Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbXJYPDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbXJYPDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbXJYPDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:03:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:38066 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808AbXJYPDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MT91ywSOqHUAYG21DRICFc7QMGfClJ43qAK3rOcAwf2nJFdf3Tj/TrFemttjPiOfFCt7DIC5gWmDVdaUu7PRsqOkEjN9Y8TyCb/kVbf6lPOBibJYUwggZ4xVcdKWQhGdD6gSKbRSeaI2KtOt7NC05LEg1rN+xYu7nHI5CB5yrYk=
Message-ID: <728201270710250803p72c656d1nca58ad0bf4f91d41@mail.gmail.com>
Date: Thu, 25 Oct 2007 10:03:28 -0500
From: "Ram Gupta" <ram.gupta5@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH]fs: Fix to correct the mbcache entries counter
Cc: "linux mailing-list" <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the c_entry_count counter of the mbcache. Currently
it increments the counter first & allocate the cache entry later. In
case of failure to allocate the entry due to insufficient memory this
counter is still left incremented. This patch fixes this anomaly.

Signed-off-by: Ram Gupta <ram.gupta5@gmail.com>
---------------
--- linux-2.6.23.1/fs/mbcache.c.orig    2007-10-25 09:19:28.000000000 -0500
+++ linux-2.6.23.1/fs/mbcache.c 2007-10-25 09:19:59.000000000 -0500
@@ -403,9 +403,9 @@ mb_cache_entry_alloc(struct mb_cache *ca
 {
        struct mb_cache_entry *ce;

-       atomic_inc(&cache->c_entry_count);
        ce = kmem_cache_alloc(cache->c_entry_cache, GFP_KERNEL);
        if (ce) {
+               atomic_inc(&cache->c_entry_count);
                INIT_LIST_HEAD(&ce->e_lru_list);
                INIT_LIST_HEAD(&ce->e_block_list);
                ce->e_cache = cache;

Thanks
Ram Gupta
