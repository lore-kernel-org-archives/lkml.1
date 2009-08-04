Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZHDDpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZHDDpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 23:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbZHDDpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 23:45:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59296 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbZHDDpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 23:45:42 -0400
Date: Tue, 4 Aug 2009 04:45:43 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0908040444030.10932@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This contain some fixes to the normal drm modesetting code (mainly better
validation of some userspace args), some radeon KMS fixes, along with some 
new radeon PCI IDs from AMD.

Dave.

 drivers/gpu/drm/drm_crtc.c          |    2 +-
 drivers/gpu/drm/drm_crtc_helper.c   |    6 ++++--
 drivers/gpu/drm/radeon/r100.c       |    3 ++-
 drivers/gpu/drm/radeon/radeon_drv.c |   17 ++++++++---------
 drivers/gpu/drm/radeon/radeon_kms.c |    2 ++
 drivers/gpu/drm/radeon/rv515.c      |    1 +
 drivers/gpu/drm/ttm/ttm_bo.c        |    7 ++++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c   |    8 ++++----
 include/drm/drm_pciids.h            |    5 +++++
 9 files changed, 33 insertions(+), 18 deletions(-)

commit c96e7c7a3a79931446ecf9494a8415e4d164ebd8
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Mon Aug 3 14:22:53 2009 +0200

    drm/ttm: Read buffer overflow
    
    Check whether index is within bounds before grabbing the element.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fa99239cb73dbf419bea9f334b85ba94ac88a532
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Mon Aug 3 14:20:32 2009 +0200

    drm/radeon: Read buffer overflow
    
    Check whether index is within bounds before grabbing the element.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fee280d3fd9bc5247bef9f4ab35a4693bfffdcfd
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Aug 3 12:39:06 2009 +0200

    drm/ttm: Fix a sync object leak.
    
    If there are multiple simultaneous waiters for the same buffer object,
    a temporary reference to its sync object may be leaked.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c9b7fb54f0a51e587fa09be3a85666b43d36a850
Author: Xiaotian Feng <dfeng@redhat.com>
Date:   Wed Jul 29 21:28:24 2009 +0800

    drm/radeon/kms: fix memory leak in radeon_driver_load_kms
    
    This patch fixes following kmemleak report:
    unreferenced object 0xffff88022cb53000 (size 4096):
      comm "work_for_cpu", pid 97, jiffies 4294672345
      backtrace:
        [<ffffffff810eb222>] create_object+0x19f/0x2a0
        [<ffffffff810eb422>] kmemleak_alloc+0x26/0x4c
        [<ffffffff810e363f>] __kmalloc+0x187/0x1b0
        [<ffffffffa005f3db>] kzalloc.clone.0+0x13/0x15 [radeon]
        [<ffffffffa005f403>] radeon_driver_load_kms+0x26/0xe1 [radeon]
        [<ffffffffa0017432>] drm_get_dev+0x37f/0x480 [drm]
        [<ffffffffa007f424>] radeon_pci_probe+0x15/0x269 [radeon]
        [<ffffffff811f8779>] local_pci_probe+0x17/0x1b
        [<ffffffff8105ffbb>] do_work_for_cpu+0x18/0x2a
        [<ffffffff81063c38>] kthread+0x8a/0x92
        [<ffffffff81012cba>] child_rip+0xa/0x20
        [<ffffffffffffffff>] 0xffffffffffffffff
    
    Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit de05065ff5d6878523317ff4a0b48a1239f80f73
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 3 12:05:34 2009 +1000

    drm/radeon/kms: fix nomodeset.
    
    The ordering was wrong to get the nomodeset parameter to work.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6d0897ba58139523d37e97855ee0fe2d78629da6
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Fri Jul 31 10:47:51 2009 +0200

    drm/ttm: Fix a potential comparison of structs.
    
    On some architectures the comparison may cause a compilation failure.
    
    Original partial fix Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    
    Signed-off-by: Pekka Paalanen <pq@iki.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0924d942256ac470c5f7b4ebaf7fe0415fc6fa59
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 3 12:03:03 2009 +1000

    drm/radeon/kms: fix rv515 VRAM initialisation.
    
    This got missed in the VRAM init re-workings.
    
    Signed-of-by: Dave Airlie <airlied@redhat.com>

commit 7320700df1864b601cef5adbddce8654a0e3f78b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Aug 3 17:01:53 2009 -0400

    drm/radeon: add some new r7xx pci ids
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4cb72b1727140f131b2df5f37c2e54f5965f98c2
Author: Jakob Bornecrantz <jakob@vmware.com>
Date:   Mon Aug 3 13:43:59 2009 +0100

    drm: Catch stop possible NULL pointer reference
    
    This was caught by Weiss. Also added some comments to the
    fb_changed and mode_changed variables to explain what they do.
    
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Tested-by: Thomas White <taw@bitwiz.org.uk>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7781de74568bddfefbd2d32a934a8c791a2420cd
Author: Jakob Bornecrantz <jakob@vmware.com>
Date:   Mon Aug 3 13:43:58 2009 +0100

    drm: Small logic fix in drm_mode_setcrtc
    
    Match the logic to the comments in the debug message
    
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
