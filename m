Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZHTF1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZHTF1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZHTF1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:27:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54558 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbZHTF1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:27:43 -0400
Date: Thu, 20 Aug 2009 15:27:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20090820152743.a5f1088b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/radeon_ttm.c between commit
ad49f501867cba87e1e45e5ebae0b12435d68bf1 ("drm/ttm/radeon: add dma32
support") from Linus' tree and commit
a987fcaa805fcb24ba885c2e29fd4fdb6816f08f ("ttm: Make parts of a struct
ttm_bo_device global") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/radeon_ttm.c
index 15c3531,343b6d6..0000000
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@@ -446,9 -462,8 +467,9 @@@ int radeon_ttm_init(struct radeon_devic
  	}
  	/* No others user of address space so set it to 0 */
  	r = ttm_bo_device_init(&rdev->mman.bdev,
- 			       rdev->mman.mem_global_ref.object,
+ 			       rdev->mman.bo_global_ref.ref.object,
 -			       &radeon_bo_driver, DRM_FILE_PAGE_OFFSET);
 +			       &radeon_bo_driver, DRM_FILE_PAGE_OFFSET,
 +			       rdev->need_dma32);
  	if (r) {
  		DRM_ERROR("failed initializing buffer object driver(%d).\n", r);
  		return r;
