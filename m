Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZJWRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZJWRMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZJWRMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 13:12:17 -0400
Received: from sous-sol.org ([216.99.217.87]:44278 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752525AbZJWRMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 13:12:16 -0400
Message-Id: <20091023171051.993073846@sequoia.sous-sol.org>
User-Agent: quilt/0.47-1
Date: Fri, 23 Oct 2009 10:10:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-mm@kvack.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] allow bootmem to be freed to allocator late
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no way to release bootmem once the bootmem allocator
frees all unreserved memory.  This adds the ability to free reserved
pages directly to the page allocator after the bootmem allocator metadata
is already freed.  It's limited in scope since it's still all marked
__init, and creates a new entry point free_bootmem_late rather than
trying to do this automatically in free_bootmem.  Hence the RFC...

With this we are able to do something like allocate swiotlb, and then
free it later if we discover we had a hw iommu that doesn't need swiotlb.

 include/linux/bootmem.h |    1 +
 mm/bootmem.c            |   98 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 77 insertions(+), 22 deletions(-)

thanks,
-chris
