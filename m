Return-Path: <linux-kernel-owner+w=401wt.eu-S1422713AbXBHFW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422713AbXBHFW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422741AbXBHFW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:22:26 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:59649 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422713AbXBHFWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:22:25 -0500
Date: Thu, 8 Feb 2007 05:22:23 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm tree for 2.6.21-rc1
Message-ID: <Pine.LNX.4.64.0702080521400.6611@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from the 'drm-patches' branch of
git://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

This contains the drm patches for the 2.6.21-rc1, and contains a cleanup of the
drm ioremap code to avoid some paravirt_op exports, fixes to the ioremap code to zero out vmalloced memory, a bunch of fixes to the via driver, and an update tothe simple memory manager used by sis and via drivers.

Dave.

  drivers/char/drm/drmP.h             |   36 ++-----
  drivers/char/drm/drm_bufs.c         |   19 ++--
  drivers/char/drm/drm_memory.c       |   94 +++---------------
  drivers/char/drm/drm_memory.h       |   20 ----
  drivers/char/drm/drm_memory_debug.h |   70 -------------
  drivers/char/drm/drm_mm.c           |  183 +++++++++++++++++++++++++++--------
  drivers/char/drm/drm_pciids.h       |    4 +
  drivers/char/drm/drm_proc.c         |    4 -
  drivers/char/drm/drm_sman.c         |    3 -
  drivers/char/drm/drm_vm.c           |   16 ++-
  drivers/char/drm/i810_dma.c         |   34 ++++---
  drivers/char/drm/i810_drv.h         |    2
  drivers/char/drm/i830_dma.c         |   32 ++++--
  drivers/char/drm/i830_drv.h         |    2
  drivers/char/drm/via_dma.c          |    9 ++
  drivers/char/drm/via_dmablit.c      |    2
  drivers/char/drm/via_drv.h          |   11 +-
  drivers/char/drm/via_irq.c          |   16 ++-
  drivers/char/drm/via_map.c          |    3 -
  drivers/char/drm/via_verifier.c     |   50 +++++++---
  drivers/char/drm/via_verifier.h     |    1
  21 files changed, 304 insertions(+), 307 deletions(-)

commit 6e4296a85bb40854b2cb6eff125ff1906d47c66f
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Thu Feb 8 13:17:44 2007 +1100

     drm: Allow for 44 bit user-tokens (or drm_file offsets)

commit 756db73df7b7d6b9f6421c1fb2e1cabeaede5846
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Thu Feb 8 12:57:40 2007 +1100

     drm/via: Disable AGP DMA for chips with the new 3D engine.

commit 1d58420bad15d08f93bf1e0342c1b1d1234d69b7
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Mon Jan 8 22:25:47 2007 +1100

     drm: update core memory manager from git drm tree

     Remove the memory manager parameter from the put_block function, as this
     makes the client code a lot cleaner. Prepare buffer manager for lock and
     unlock calls.
     Fix buggy aligned allocations.
     Remove the stupid root_node field from the core memory manager.
     Support multi-page buffer offset alignments
     Add improved alignment functionality to the core memory manager.
     This makes an allocated block actually align itself and returns any
     wasted space to the manager.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 004a7727421fd202bbdfcc0231a3359085199a52
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Jan 8 21:56:59 2007 +1100

     drm: remove drm_ioremap and drm_ioremapfree

     hch originally submitted this for paravirt ops work, airlied took it
     and cleaned up a lot of unused code caused by using this.

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b9094d3aaa9550e740b6fd12b68f485d9979ce27
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Jan 8 21:31:13 2007 +1100

     i810/i830: use drm_core_ioremap instead of drm_ioremap

     This makes the i810/i830 use the drm_core_ioremap functions.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f239b7b0cac0682d582949087710a9663b1300d5
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Mon Jan 8 21:22:50 2007 +1100

     drm: use vmalloc_user instead of vmalloc_32 for DRM_SHM

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9b8d9d0e0181286c0608e6426da1eac45463ecd2
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Mon Jan 8 21:21:41 2007 +1100

     via: allow for npot texture pitch alignment

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 689692e73ea4b95c9fa5d5913eade33147db2e5a
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Mon Jan 8 21:19:57 2007 +1100

     via: add some new chipsets

     Disable 3D functionality and AGP DMA for chipsets with the DX9 3D engine.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 76f625511e61f9d5561885c77d2ff1436ed83797
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Mon Jan 8 21:03:23 2007 +1100

     via: some PCI posting flushes

     Signed-off-by: Dave Airlie <airlied@linux.ie>
