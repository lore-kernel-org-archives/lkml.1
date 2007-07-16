Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbXGPExT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbXGPExT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 00:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXGPExK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 00:53:10 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:50747 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbXGPExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 00:53:09 -0400
X-Greylist: delayed 2635 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 00:53:08 EDT
Date: Mon, 16 Jul 2007 05:09:11 +0100 (IST)
From: Dave Airlie <airlied@skynet.ie>
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm patches for 2.6.23-rc1 - FIXED
Message-ID: <Pine.LNX.4.64.0707160508430.25885@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

(apologies for the first borked tree, I cross compiled this for ppc64,
  you can blame Telstra - no ADSL or phone at home)

Please pull the 'drm-patches' branch from the drm git tree.
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

It contains a removal of a lot of typedefs from the core drm and their use in
drivers. Drivers will have their own typedefs cleaned later. It also
fixes the 32-bit compat ioctl code

It also contains an updated r300 register file, and radeon vblank routing
support along with a list macro cleanup.

  drivers/char/drm/ati_pcigart.c    |    8 +-
  drivers/char/drm/drm.h            |  329 ++++++-----
  drivers/char/drm/drmP.h           |  349 ++++++------
  drivers/char/drm/drm_agpsupport.c |  116 ++--
  drivers/char/drm/drm_auth.c       |   40 +-
  drivers/char/drm/drm_bufs.c       |  209 ++++----
  drivers/char/drm/drm_context.c    |   97 ++--
  drivers/char/drm/drm_dma.c        |   12 +-
  drivers/char/drm/drm_drawable.c   |   34 +-
  drivers/char/drm/drm_drv.c        |   76 ++--
  drivers/char/drm/drm_fops.c       |   68 +--
  drivers/char/drm/drm_hashtab.c    |   34 +-
  drivers/char/drm/drm_hashtab.h    |   24 +-
  drivers/char/drm/drm_ioc32.c      |   82 ++--
  drivers/char/drm/drm_ioctl.c      |   68 ++-
  drivers/char/drm/drm_irq.c        |   58 +-
  drivers/char/drm/drm_lock.c       |   28 +-
  drivers/char/drm/drm_memory.c     |    8 +-
  drivers/char/drm/drm_mm.c         |   66 +-
  drivers/char/drm/drm_os_linux.h   |   22 +-
  drivers/char/drm/drm_pci.c        |    6 +-
  drivers/char/drm/drm_proc.c       |   50 +-
  drivers/char/drm/drm_sarea.h      |   26 +-
  drivers/char/drm/drm_scatter.c    |   22 +-
  drivers/char/drm/drm_sman.c       |   93 ++--
  drivers/char/drm/drm_sman.h       |   50 +-
  drivers/char/drm/drm_stub.c       |   30 +-
  drivers/char/drm/drm_sysfs.c      |    4 +-
  drivers/char/drm/drm_vm.c         |  106 ++--
  drivers/char/drm/i810_dma.c       |  164 +++---
  drivers/char/drm/i810_drm.h       |    2 +-
  drivers/char/drm/i810_drv.h       |   18 +-
  drivers/char/drm/i830_dma.c       |  157 +++---
  drivers/char/drm/i830_drm.h       |    2 +-
  drivers/char/drm/i830_drv.h       |   24 +-
  drivers/char/drm/i830_irq.c       |   20 +-
  drivers/char/drm/i915_dma.c       |   44 +-
  drivers/char/drm/i915_drm.h       |    8 +-
  drivers/char/drm/i915_drv.h       |   22 +-
  drivers/char/drm/i915_irq.c       |   28 +-
  drivers/char/drm/i915_mem.c       |    6 +-
  drivers/char/drm/mga_dma.c        |   79 ++--
  drivers/char/drm/mga_drm.h        |    6 +-
  drivers/char/drm/mga_drv.c        |    4 +-
  drivers/char/drm/mga_drv.h        |   22 +-
  drivers/char/drm/mga_irq.c        |   12 +-
  drivers/char/drm/mga_state.c      |   36 +-
  drivers/char/drm/r128_cce.c       |   41 +-
  drivers/char/drm/r128_drm.h       |    4 +-
  drivers/char/drm/r128_drv.h       |   20 +-
  drivers/char/drm/r128_irq.c       |   10 +-
  drivers/char/drm/r128_state.c     |   60 +-
  drivers/char/drm/r300_cmdbuf.c    |   53 +-
  drivers/char/drm/r300_reg.h       | 1163 +++++++++++++++++++++----------------
  drivers/char/drm/radeon_cp.c      |   54 +-
  drivers/char/drm/radeon_drm.h     |   12 +-
  drivers/char/drm/radeon_drv.c     |    3 +-
  drivers/char/drm/radeon_drv.h     |   45 +-
  drivers/char/drm/radeon_irq.c     |  118 ++++-
  drivers/char/drm/radeon_state.c   |  108 ++--
  drivers/char/drm/savage_bci.c     |   44 +-
  drivers/char/drm/savage_drm.h     |    4 +-
  drivers/char/drm/savage_drv.h     |   20 +-
  drivers/char/drm/savage_state.c   |   28 +-
  drivers/char/drm/sis_drv.c        |    4 +-
  drivers/char/drm/sis_drv.h        |    9 +-
  drivers/char/drm/sis_mm.c         |   16 +-
  drivers/char/drm/via_dma.c        |   10 +-
  drivers/char/drm/via_dmablit.c    |   20 +-
  drivers/char/drm/via_dmablit.h    |    2 +-
  drivers/char/drm/via_drm.h        |    4 +-
  drivers/char/drm/via_drv.h        |   32 +-
  drivers/char/drm/via_irq.c        |   12 +-
  drivers/char/drm/via_map.c        |   10 +-
  drivers/char/drm/via_mm.c         |    6 +-
  drivers/char/drm/via_verifier.c   |   12 +-
  drivers/char/drm/via_verifier.h   |    6 +-
  77 files changed, 2485 insertions(+), 2214 deletions(-)

commit ff4135aeb1f9a0201f8e22400ebc1d570df9016e
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Jul 16 13:53:57 2007 +1000

     drm: remove core typedefs from the ioc32 wrappers

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit bd63cb52c05bbb154f539369cae4fb9c9b6277da
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Jul 12 10:35:02 2007 +1000

     drm: remove sarea typedefs

     Leave the userspace typedefs in place

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e0be428e6645f2891fab6be92d1b0e9aad972e7d
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Jul 12 10:26:44 2007 +1000

     drm: detypedef the hashtab and more of sman

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9698b4dba42eb758ad98012c21e5fbdb372fe2d9
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Jul 12 10:21:05 2007 +1000

     drm: de-typedef sman

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 55910517af381eba4f978740e5e46e23eb269326
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 16:53:40 2007 +1000

     drm: detypedeffing continues...

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit cdd55a294c13f8bf05b2f4fee4c96934d5ebd2e4
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 16:32:08 2007 +1000

     drm: detypef waitlist/freelist/buf_entry/device_dma/drm_queue structs

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 8fc2fdf4c9437576f38e97c2f5b700ec77038984
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 16:21:47 2007 +1000

     drm: drop drm_vma_entry_t, drm_magic_entry_t

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 056219e2fa6664ec83bc258ebcf30f1a7919d423
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 16:17:42 2007 +1000

     drm: drop drm_buf_t typedef

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit eddca551a3e7be2fed54282f255f18efe9ead131
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 16:09:54 2007 +1000

     drm: fixup other drivers for typedef removals

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 84b1fd103dbbe01b5905db1444d3fc8afa9a7207
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 15:53:27 2007 +1000

     drm: remove drm_file_t, drm_device_t and drm_head_t typedefs

     some drivers still todo.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit c60ce623bd16137627009d05e311d877729f2ad6
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 15:27:12 2007 +1000

     drm: remove a bunch of typedefs on the userspace interface

     This moves a bunch of typedefs into a !defined __KERNEL__ to keep userspace
     API compatiblity, it changes all internal usages to structs/enum/unions.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit c6c656b4b6ddfc964f1a43394bf86bc76c5e8119
Author: Oliver McFadden <z3ro.geek@gmail.com>
Date:   Wed Jul 11 12:24:10 2007 +1000

     r300: updates register header

     This updates the R300 register names and allows the VAP_PVS_WAITIDLE register
     to be written.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ddbee33328dcfb892cd91f2d57a1822f4d6f70d9
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 12:16:01 2007 +1000

     radeon: add support for vblank on crtc2

     This adds support for CRTC2 vblank on radeon similiar to the i915.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7c158acef8f0e51c3a5f71133aaf402628370a64
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jul 11 12:05:36 2007 +1000

     drm: cleanup list initialisation

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 6f710105f5a4971078c46ae258cbb76db1ee967a
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon May 28 19:41:35 2007 +1000

     drm: fix typo on code drm getsarea

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit da509d7a02cb54938776439edc81f057e39f81e0
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat May 26 05:04:51 2007 +1000

     drm: remove DRM_GETSAREA and replace with drm_getsarea function

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit bd1b331fae2813d9f03ceee649296f02edc0b893
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat May 26 05:01:51 2007 +1000

     drm: cleanup use of Linux list handling macros

     This makes the drms use of the list handling macros a lot cleaner
     and more along the lines of how they should be used and uses them
     in some more places.

     Signed-off-by: Dave Airlie <airlied@linux.ie>
