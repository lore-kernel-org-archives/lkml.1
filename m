Return-Path: <linux-kernel-owner+w=401wt.eu-S1762774AbZCQI0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774AbZCQI0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZCQI0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:26:06 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:60334 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZCQI0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:26:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WI8lj0W7tWA2JngtKzcy4iNJ08U1qUIsL2g9EgL+Re6AbnMaTmvmRLV/wPGdvgmLI6
         g6UAhY9U3FsXphzddANoOXfoZOxZMeTHj/c/4NBhLxlWiX1X8k2DEURNwf+BnDHYLGVS
         f3bV95qNVxsNUfRkq4cGgoaLOfhfZZ2eIqrow=
Date: Tue, 17 Mar 2009 11:25:49 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: [PATCH next] slob: fix build problem
Message-ID: <20090317082549.GA5127@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/slob.c: In function '__kmalloc_node':
mm/slob.c:480: error: 'flags' undeclared (first use in this function)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 mm/slob.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 081cf1e..e49b258 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -477,7 +477,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 	void *ret;
 
-	lockdep_trace_alloc(flags);
+	lockdep_trace_alloc(gfp);
 
 	if (size < PAGE_SIZE - align) {
 		if (!size)
