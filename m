Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbZDWIDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbZDWIDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757811AbZDWHhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:37:19 -0400
Received: from sous-sol.org ([216.99.217.87]:47523 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757753AbZDWHhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:37:17 -0400
Message-Id: <20090423073101.273491207@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
       Dave Airlie <airlied@redhat.com>
Subject: [patch 094/100] agp: zero pages before sending to userspace
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=agp-zero-pages-before-sending-to-userspace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Shaohua Li <shaohua.li@intel.com>

upstream commit: 59de2bebabc5027f93df999d59cc65df591c3e6e

CVE-2009-1192

AGP pages might be mapped into userspace finally, so the pages should be
set to zero before userspace can use it. Otherwise there is potential
information leakage.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/agp/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1226,7 +1226,7 @@ int agp_generic_alloc_pages(struct agp_b
 	int i, ret = -ENOMEM;
 
 	for (i = 0; i < num_pages; i++) {
-		page = alloc_page(GFP_KERNEL | GFP_DMA32);
+		page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
 		/* agp_free_memory() needs gart address */
 		if (page == NULL)
 			goto out;
@@ -1257,7 +1257,7 @@ void *agp_generic_alloc_page(struct agp_
 {
 	struct page * page;
 
-	page = alloc_page(GFP_KERNEL | GFP_DMA32);
+	page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
 	if (page == NULL)
 		return NULL;
 

