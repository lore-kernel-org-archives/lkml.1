Return-Path: <linux-kernel-owner+w=401wt.eu-S1761192AbXEQFTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192AbXEQFTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXEQFT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:19:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38964 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752276AbXEQFTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:19:25 -0400
Message-Id: <20070517051659.055631233@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 May 2007 22:16:59 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, dgc@sgi.com
Subject: [patch 0/3] Slab Defrag / Slab Targeted Reclaim
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Initial support for Slab defragmentation and targeted reclaim. The
functionality here is minimal. We establish a slab API to allow removal
or moving of objects between slabs.

The only user provided here is a dentry cache reclaim capability. This is
limited to the removal of unused dentries for now. It is planned to later
add a similar inode reclaim capability and then extend the move/reclaim
to support moving of dentries and inodes.

Slab defragmentation is performed during kmem_cache_shrink. This is usually
triggered through the slab shrinkers but can also be manually triggered
through the slabinfo command.

Support is provided for antifrag/defrag to evict a specific slab page
through the kmem_cache_vacate function call. Since we can only reclaim
unused dentries for now that functionality is pretty limited (we need to
put some work into making dentries and inode more reclaimable or movable)
but we can increase the capabilities over time which will allow us to move
slabs from the reclaimable area into the movable area. This will shrink
the reclaimable area significantly. Since we can target the vacating of
pages this may allow the antifrag code to remove a page that hinders the
freeing of higher order page.

-- 
