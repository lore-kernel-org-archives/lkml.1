Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZAFMM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZAFMM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZAFMMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:12:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZAFMMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:12:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZbGKyDnGgtO944aQSEKQr86kxUC8K3qNKTSX8XAU9ke8RXgDd4hV11kDn1p6SB1OCP
         TgVVhnGym/juhfa0L+v9OZVOBYNUjJXhileU7ppWSxiWA2rHeK0AHw2c9S2TVxJ2P6Bh
         UV6+3rSiRtosKQEVv0zqgMFeW/HQMx1mpBW2E=
Date: Tue, 6 Jan 2009 15:12:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: mminit_validate_memmodel_limits - get rid of redundant
	test
Message-ID: <20090106121213.GG7671@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if start_pfn overlap the upper bound no need
to test end_pfn again since we have it already trimmed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

I hope this time I don't miss anything.

 mm/sparse.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.git/mm/sparse.c
===================================================================
--- linux-2.6.git.orig/mm/sparse.c
+++ linux-2.6.git/mm/sparse.c
@@ -164,9 +164,7 @@ void __meminit mminit_validate_memmodel_
 		WARN_ON_ONCE(1);
 		*start_pfn = max_sparsemem_pfn;
 		*end_pfn = max_sparsemem_pfn;
-	}
-
-	if (*end_pfn > max_sparsemem_pfn) {
+	} else if (*end_pfn > max_sparsemem_pfn) {
 		mminit_dprintk(MMINIT_WARNING, "pfnvalidation",
 			"End of range %lu -> %lu exceeds SPARSEMEM max %lu\n",
 			*start_pfn, *end_pfn, max_sparsemem_pfn);
