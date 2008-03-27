Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYCZKUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYCZKUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbYCZKTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:19:38 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:47398 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbYCZKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:19:35 -0400
X-IronPort-AV: E=Sophos;i="4.25,557,1199682000"; 
   d="scan'208";a="50790403"
From: Bryan Wu <cooloney@kernel.org>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] Blackfin Video Driver: fix bug when opening/reading/mmaping BF54x and BF52x framebuffer simultaneously
Date: Wed, 26 Mar 2008 18:19:35 -0700
Message-Id: <1206580775-23929-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3974

opening/reading/mmaping BF54x and BF52x framebuffer simultaneously
triggers BUG: failure at mm/nommu.c:470/add_nommu_vma()
Add VM_SHARED to the default vm_flags

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/video/bf54x-lq043fb.c    |    2 +-
 drivers/video/bfin-t350mcqb-fb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 986a550..eefba3d 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -384,7 +384,7 @@ static int bfin_bf54x_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	 *   Other flags can be set, and are documented in
 	 *   include/linux/mm.h
 	 */
-	vma->vm_flags |= VM_MAYSHARE;
+	vma->vm_flags |=  VM_MAYSHARE | VM_SHARED;
 
 	return 0;
 }
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 68d5857..c92d457 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -302,7 +302,7 @@ static int bfin_t350mcqb_fb_mmap(struct fb_info *info, struct vm_area_struct *vm
 	 *   Other flags can be set, and are documented in
 	 *   include/linux/mm.h
 	 */
-	vma->vm_flags |= VM_MAYSHARE;
+	vma->vm_flags |= VM_MAYSHARE | VM_SHARED;
 
 	return 0;
 }
-- 
1.5.4.3
