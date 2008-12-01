Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYLAAiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYLAAiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYLAAhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:37:54 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49631 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYLAAhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:37:53 -0500
Date: Mon, 1 Dec 2008 00:37:37 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Manfred Spraul <manfred@colorfullife.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 0/8] badpage: more resilient bad page pte and rmap
Message-ID: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a batch of 8 mm patches, intended for 2.6.29: revisiting
bad_page() and print_bad_pte() and the page_remove_rmap() Eeek BUG.
Diffed to slot in to the mmotm series just before "mmend".

The only clash with later mmotm patches is with Manfred's
mm-debug-dump-pageframes-on-bad_page.patch
which puts a hexdump in there.  Trivial to fix up, but I've never
actually found that patch helpful - perhaps because it isn't an -mm
tree that "Bad page state" reporters are running.  Time to drop it?

 include/linux/page-flags.h |   25 ++------
 include/linux/rmap.h       |    2 
 include/linux/swap.h       |   12 ---
 mm/filemap_xip.c           |    2 
 mm/fremap.c                |    2 
 mm/internal.h              |    1 
 mm/memory.c                |  109 ++++++++++++++++++++++++++---------
 mm/page_alloc.c            |  108 +++++++++++++++++++---------------
 mm/rmap.c                  |   24 -------
 mm/swapfile.c              |    7 +-
 10 files changed, 166 insertions(+), 126 deletions(-)
