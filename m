Return-Path: <linux-kernel-owner+w=401wt.eu-S1422747AbXDDSXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422747AbXDDSXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422745AbXDDSWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:22:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52606 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422664AbXDDSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:22:35 -0400
Date: Wed, 4 Apr 2007 11:22:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
In-Reply-To: <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704041120250.793@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com> 
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com> 
 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com> 
 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com>
 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Christoph Lameter wrote:

> Yes. slub_debug=U. But user tracking may need to increase the slab 
> size (depends on the padding available in the slab) to store the 
> tracking information, so you may not get the same corruption.

Hummm U is switching off merging and you may need merging to trigger the 
discovery of the overwrite.

Here is a patch to enable merging even while tracking slabs. This patch 
should not be applied to mm. In general tracking requires knowing which
slab the objects come from and merging looses that information.

Index: linux-2.6.21-rc5-mm4/mm/slub.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-04 11:19:29.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-04 11:19:35.000000000 -0700
@@ -86,7 +86,7 @@
 /*
  * Set of flags that will prevent slab merging
  */
-#define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
+#define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | \
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \

