Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbXDINNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbXDINNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXDINNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:13:49 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:41135 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbXDINNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=ngnSxmu0nRNcZ36XpTGTDM1fpP75ZmhwCbMd8/wFmrf6xGySCJh3EMwzG2y1rWlJg81fQ1j0buRkvNznQ5z3gWI80sCslwp57dZKbLQn79yqMNEgOYYQSuytL3DaByVsF/55dWYNRBaL2NrqlV+inUKZdLCw2l9NPgoUUS1RBeY=
Date: Mon, 9 Apr 2007 22:08:47 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, linux-arch@vger.kernel.org
Subject: [PATCH] slob: handle SLAB_PANIC flag
Message-ID: <20070409130847.GA5048@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	linux-arch@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_create() for slob doesn't handle SLAB_PANIC.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/slob.c |    3 +++
 1 file changed, 3 insertions(+)

Index: 2.6-mm/mm/slob.c
===================================================================
--- 2.6-mm.orig/mm/slob.c
+++ 2.6-mm/mm/slob.c
@@ -298,6 +298,9 @@ struct kmem_cache *kmem_cache_create(con
 		c->align = (flags & SLAB_MUST_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
 		if (c->align < align)
 			c->align = align;
+	} else {
+		if (flags & SLAB_PANIC)
+			panic("Cannot create slab cache %s\n", name);
 	}
 
 	return c;
