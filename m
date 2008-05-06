Return-Path: <linux-kernel-owner+w=401wt.eu-S1764296AbYEFP13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764296AbYEFP13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbYEFP1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:27:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36617 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbYEFP1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:27:17 -0400
Date: Tue, 6 May 2008 16:27:14 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: parisc DISCONTIGMEM compile breakage
Message-ID: <20080506152713.GA5034@csn.ul.ie>
References: <20080506134648.GA30082@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080506134648.GA30082@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/05/08 16:46), Adrian Bunk didst pronounce:
> Commit 54a6eb5c4765aa573a030ceeba2c14e3d2ea5706
> (mm: use two zonelist that are filtered by GFP mask)
> causes the following build error with CONFIG_DISCONTIGMEM=y
> on parisc:
> 

Thanks Adrian. I don't have a pa-risc cross-compiler and there isn't one
at the usual source http://userweb.kernel.org/~akpm/cross-compilers but the
patch below should fix it. Note that this debugging code should be deleted if
the mm-initialisation-and-debugging framework in -mm is merged to mainline
as it knows how to print all the zonelists where as the pa-risc equivilant
misses the GFP_THISNODE lists.

=====
Subject: [PATCH] Fix pa-risc DISCONTIGMEM compile breakage
    
PA-RISC to aid debugging prints out the zonelists setup by the system. A
bad call to node_zonelist() breaks at compile-time. This patch fixes it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 arch/parisc/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 1f01284..b0ed709 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -606,7 +606,7 @@ void show_mem(void)
 		int i, j;
 
 		for (i = 0; i < npmem_ranges; i++) {
-			zl = node_zonelist(i);
+			zl = node_zonelist(i, 0);
 			for (j = 0; j < MAX_NR_ZONES; j++) {
 				struct zoneref *z;
 				struct zone *zone;

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
