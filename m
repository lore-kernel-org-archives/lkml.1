Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYHOVEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYHOVEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYHOVE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:04:29 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:4462 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYHOVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wX5hKZmNvjYtJHsPsxPlMwpV5aeaUM69B9DI97I+ZbFSFns4cvVt6kPkDGSEZJwkNC
         io6kT6H29jq/5XRBtJ9tozsr4bkvrywT7IdRO6tvNHVBrlqMf/Qx8ljkBgEyRcbwCuhj
         HIAdBvyGugQlVvKDXhM3jURC/iFxfrkQgrNNY=
Date: Fri, 15 Aug 2008 23:02:21 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: mminit_loglevel cannot be __meminitdata anymore
Message-ID: <20080815210216.GA14783@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mminit_loglevel is now used from mminit_verify_zonelist <- build_all_zonelists <-

1. online_pages <- memory_block_action <- memory_block_change_state <- store_mem_state (sys handler)
2. numa_zonelist_order_handler (proc handler)

so it cannot be annotated __meminit - drop it

fixes following section mismatch warning:
WARNING: vmlinux.o(.text+0x71628): Section mismatch in reference from the function mminit_verify_zonelist() to the variable .meminit.data:mminit_loglevel
The function mminit_verify_zonelist() references
the variable __meminitdata mminit_loglevel.
This is often because mminit_verify_zonelist lacks a __meminitdata
annotation or the annotation of mminit_loglevel is wrong.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mm_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 936ef2e..4e0e265 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -12,7 +12,7 @@
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
-int __meminitdata mminit_loglevel;
+int mminit_loglevel;
 
 #ifndef SECTIONS_SHIFT
 #define SECTIONS_SHIFT	0
-- 
1.5.4.5

