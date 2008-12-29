Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbYL2Ic1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbYL2Ic1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 03:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYL2IcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 03:32:18 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34217 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYL2IcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 03:32:17 -0500
Date: Mon, 29 Dec 2008 08:32:13 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm
Message-ID: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-481736133-1230539533=:20427"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-481736133-1230539533=:20427
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

Major highlights:
Kernel Modesetting (KMS) core code (jbarnes you can go to drinking island 
now)
Intel i915 support for kernel modesetting
multi-master split out for allow multiple X servers use DRI if driver 
supports it.

for anyone interested in kms:
a) don't enable it by default  unless you have a userspace to run on top 
of it, if you really want X to work, really kms is for developers at the 
moment, and later for distros to enable.
b) there isn't a stable userspace to run on top of it yet.

I might have to temporarily handoff drm maintainer job to jbarnes or 
anholt for the rest of this cycle, as today is the due date for my first 
kid, needless to say no sign yet, I actually thought the baby would 
arrive before kms got merged :)

Dave.

 drivers/gpu/drm/Kconfig                |   17 +
 drivers/gpu/drm/Makefile               |    3 +-
 drivers/gpu/drm/drm_auth.c             |   29 +-
 drivers/gpu/drm/drm_bufs.c             |   27 +-
 drivers/gpu/drm/drm_context.c          |   10 +-
 drivers/gpu/drm/drm_crtc.c             | 2446 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_crtc_helper.c      |  826 +++++++++++
 drivers/gpu/drm/drm_drv.c              |   95 +-
 drivers/gpu/drm/drm_edid.c             |  732 ++++++++++
 drivers/gpu/drm/drm_fops.c             |  223 ++--
 drivers/gpu/drm/drm_gem.c              |  111 ++
 drivers/gpu/drm/drm_hashtab.c          |    2 +
 drivers/gpu/drm/drm_ioctl.c            |   61 +-
 drivers/gpu/drm/drm_irq.c              |   73 +-
 drivers/gpu/drm/drm_lock.c             |   42 +-
 drivers/gpu/drm/drm_mm.c               |    1 +
 drivers/gpu/drm/drm_modes.c            |  576 ++++++++
 drivers/gpu/drm/drm_proc.c             |   71 +-
 drivers/gpu/drm/drm_stub.c             |  142 ++-
 drivers/gpu/drm/drm_sysfs.c            |  329 +++++-
 drivers/gpu/drm/drm_vm.c               |    7 +-
 drivers/gpu/drm/i915/Makefile          |   17 +-
 drivers/gpu/drm/i915/dvo.h             |  157 ++
 drivers/gpu/drm/i915/dvo_ch7017.c      |  454 ++++++
 drivers/gpu/drm/i915/dvo_ch7xxx.c      |  368 +++++
 drivers/gpu/drm/i915/dvo_ivch.c        |  442 ++++++
 drivers/gpu/drm/i915/dvo_sil164.c      |  302 ++++
 drivers/gpu/drm/i915/dvo_tfp410.c      |  335 +++++
 drivers/gpu/drm/i915/i915_dma.c        |  338 ++++-
 drivers/gpu/drm/i915/i915_drv.c        |   42 +-
 drivers/gpu/drm/i915/i915_drv.h        |   93 ++-
 drivers/gpu/drm/i915/i915_gem.c        |  628 ++++++++-
 drivers/gpu/drm/i915/i915_gem_proc.c   |   34 +
 drivers/gpu/drm/i915/i915_gem_tiling.c |    1 +
 drivers/gpu/drm/i915/i915_irq.c        |   51 +-
 drivers/gpu/drm/i915/i915_mem.c        |    3 +-
 drivers/gpu/drm/i915/i915_opregion.c   |    4 +-
 drivers/gpu/drm/i915/i915_reg.h        |   20 +-
 drivers/gpu/drm/i915/intel_bios.c      |  193 +++
 drivers/gpu/drm/i915/intel_bios.h      |  405 ++++++
 drivers/gpu/drm/i915/intel_crt.c       |  284 ++++
 drivers/gpu/drm/i915/intel_display.c   | 1618 +++++++++++++++++++++
 drivers/gpu/drm/i915/intel_drv.h       |  146 ++
 drivers/gpu/drm/i915/intel_dvo.c       |  495 +++++++
 drivers/gpu/drm/i915/intel_fb.c        |  925 ++++++++++++
 drivers/gpu/drm/i915/intel_i2c.c       |  184 +++
 drivers/gpu/drm/i915/intel_lvds.c      |  525 +++++++
 drivers/gpu/drm/i915/intel_modes.c     |   83 ++
 drivers/gpu/drm/i915/intel_sdvo.c      | 1128 +++++++++++++++
 drivers/gpu/drm/i915/intel_sdvo_regs.h |  327 +++++
 drivers/gpu/drm/i915/intel_tv.c        | 1725 ++++++++++++++++++++++
 drivers/gpu/drm/radeon/r300_cmdbuf.c   |   11 +-
 drivers/gpu/drm/radeon/radeon_cp.c     |   73 +-
 drivers/gpu/drm/radeon/radeon_drv.c    |    2 +
 drivers/gpu/drm/radeon/radeon_drv.h    |   14 +-
 drivers/gpu/drm/radeon/radeon_state.c  |  166 ++-
 drivers/video/console/vgacon.c         |   17 +
 include/drm/Kbuild                     |    2 +-
 include/drm/drm.h                      |   24 +
 include/drm/drmP.h                     |  108 ++-
 include/drm/drm_crtc.h                 |  733 ++++++++++
 include/drm/drm_crtc_helper.h          |  124 ++
 include/drm/drm_edid.h                 |  202 +++
 include/drm/drm_mode.h                 |  271 ++++
 include/drm/drm_sarea.h                |    6 +-
 include/drm/i915_drm.h                 |   41 +-
 include/linux/console.h                |    4 +
 67 files changed, 18476 insertions(+), 472 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_crtc.c
 create mode 100644 drivers/gpu/drm/drm_crtc_helper.c
 create mode 100644 drivers/gpu/drm/drm_edid.c
 create mode 100644 drivers/gpu/drm/drm_modes.c
 create mode 100644 drivers/gpu/drm/i915/dvo.h
 create mode 100644 drivers/gpu/drm/i915/dvo_ch7017.c
 create mode 100644 drivers/gpu/drm/i915/dvo_ch7xxx.c
 create mode 100644 drivers/gpu/drm/i915/dvo_ivch.c
 create mode 100644 drivers/gpu/drm/i915/dvo_sil164.c
 create mode 100644 drivers/gpu/drm/i915/dvo_tfp410.c
 create mode 100644 drivers/gpu/drm/i915/intel_bios.c
 create mode 100644 drivers/gpu/drm/i915/intel_bios.h
 create mode 100644 drivers/gpu/drm/i915/intel_crt.c
 create mode 100644 drivers/gpu/drm/i915/intel_display.c
 create mode 100644 drivers/gpu/drm/i915/intel_drv.h
 create mode 100644 drivers/gpu/drm/i915/intel_dvo.c
 create mode 100644 drivers/gpu/drm/i915/intel_fb.c
 create mode 100644 drivers/gpu/drm/i915/intel_i2c.c
 create mode 100644 drivers/gpu/drm/i915/intel_lvds.c
 create mode 100644 drivers/gpu/drm/i915/intel_modes.c
 create mode 100644 drivers/gpu/drm/i915/intel_sdvo.c
 create mode 100644 drivers/gpu/drm/i915/intel_sdvo_regs.h
 create mode 100644 drivers/gpu/drm/i915/intel_tv.c
 create mode 100644 include/drm/drm_crtc.h
 create mode 100644 include/drm/drm_crtc_helper.h
 create mode 100644 include/drm/drm_edid.h
 create mode 100644 include/drm/drm_mode.h

commit aa5966296675a5092505f68d72563d5939a92353
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Dec 29 16:35:02 2008 +1000

    drm/i915: fix modeset devname allocation + agp init return check.
    
    devname needs to be allocated before the irq is installed, so the
    irq routines get the correct name in /proc.
    
    Also check the return value from the AGP init function, and
    fixup the exit points.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aad87dff5acb232666932e750318ec1fdb716e79
Author: Julia Lawall <julia@diku.dk>
Date:   Sun Dec 21 16:28:47 2008 +0100

    drm/i915: Remove redundant test in error path.
    
    The error path for object list being null is in the second goto target.
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit fede5c91c4a8a7701d205b2b84b9835ddc7d6f02
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Dec 19 17:23:38 2008 -0800

    drm: Add a debug node for vblank state.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f51c5b6e623cc737d47f513cbb893cec914f0bd2
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Dec 19 15:07:11 2008 -0800

    drm: Avoid use-before-null-test on dev in drm_cleanup().
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f1acec933848219c402c165686677b1c307407f8
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Dec 19 14:47:48 2008 -0800

    drm/i915: Don't print to dmesg when taking signal during object_pin.
    
    This showed up in logs where people had a hung chip, so pinning was blocked
    on the chip unpinning other buffers, and the X Server took its scheduler
    signal during that time.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 3c4fdcfb2941dc36b6a16bc509a2adb97c131716
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Wed Dec 17 22:14:46 2008 -0500

    drm: pin new and unpin old buffer when setting a mode.
    
    This removes the requirement for user space to pin a buffer before
    setting a mode that is backed by the pixels from that buffer.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d1e22c6ed05f3bfb3a7de0947498e7f3c868b296
Author: Hannes Eder <hannes@hanneseder.net>
Date:   Fri Dec 19 12:34:27 2008 +0100

    drm/i915: un-EXPORT and make 'intelfb_panic' static
    
    Fix this sparse warning:
    
      drivers/gpu/drm/i915/intel_fb.c:417:5: warning: symbol 'intelfb_panic' was not declared. Should it be static?
    
    Signed-off-by: Hannes Eder <hannes@hanneseder.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit bae7ec657305def791a946f5d791054c48a5f081
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Dec 19 14:30:31 2008 -0800

    drm/i915: Delete unused, pointless i915_driver_firstopen.
    
    Thanks to Hannes Eder for pointing out that this code was dead according to
    sparse.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d4da3af667d251cc853d1873a1fad4db6daabf5f
Author: Hannes Eder <hannes@hanneseder.net>
Date:   Thu Dec 18 21:24:18 2008 +0100

    drm/i915: fix sparse warnings: returning void-valued expression
    
    Signed-off-by: Hannes Eder <hannes@hanneseder.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 606df4e024bc8e921dd516cdb7160250658d9b7a
Author: Hannes Eder <hannes@hanneseder.net>
Date:   Thu Dec 18 21:22:24 2008 +0100

    drm/i915: fix sparse warnings: move 'extern' decls to header file
    
    Move 'extern'-decls from "intel_dvo.c" to "dvo.h", as "dvo.h" is
    included by and only by files where the symbols are either defined or
    used.
    
    Signed-off-by: Hannes Eder <hannes@hanneseder.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b358d0a6252d8ed16afb20caaec35b24c76074bb
Author: Hannes Eder <hannes@hanneseder.net>
Date:   Thu Dec 18 21:18:47 2008 +0100

    drm/i915: fix sparse warnings: make symbols static
    
    Signed-off-by: Hannes Eder <hannes@hanneseder.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 95281e352e19b670458563a5ca746195c183a98f
Author: Hannes Eder <hannes@hanneseder.net>
Date:   Thu Dec 18 15:09:00 2008 +0100

    drm/i915: fix sparse warnings: declare one-bit bitfield as unsigned
    
    Signed-off-by: Hannes Eder <hannes@hanneseder.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b117763627ef4d24086801dd5f74c9eb2f487790
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Dec 10 10:09:41 2008 -0800

    drm/i915: Don't double-unpin buffers if we take a signal in evict_everything().
    
    We haven't seen this in practice, but it was visible when looking at a bug
    report from when i915_gem_evict_everything() was broken and would always
    return error.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e7da40f0c89c10ad3cbb63b754abaf6c3e792f79
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Dec 10 17:23:00 2008 -0800

    drm/i915: Fix fbcon setup to align display pitch to 64b.
    
    This is required by the display plane, and fixes 1400x1050 laptop displays.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8d391aa410ecb230fc4c3147b94eec25b9f3c20f
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Dec 17 22:32:14 2008 -0800

    drm/i915: Add missing userland definitions for gem init/execbuffer.
    
    fdo bug #19132.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dfef24592257805af0bee42dced099459c68a307
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 19 15:07:46 2008 +1000

    i915/drm: provide compat defines for userspace for certain struct members.
    
    Painfully userspace started using new names that were never actually to be
    used from the external repo.
    
    Also fill out the gaps in the structure for old/new userspace compat
    
    Add compat defines for these structs.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0c7c26647579e9e647e8b969bb0e7b3f5f1a1492
Author: Kristian H?gsberg <krh@redhat.com>
Date:   Thu Dec 18 13:14:37 2008 +1000

    drm: drop DRM_IOCTL_MODE_REPLACEFB, add+remove works just as well.
    
    The replace fb ioctl replaces the backing buffer object for a modesetting
    framebuffer object.  This can be acheived by just creating a new
    framebuffer backed by the new buffer object, setting that for the crtcs
    in question and then removing the old framebuffer object.
    
    Signed-off-by: Kristian Hogsberg <krh@redhat.com>
    Acked-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e0c8463a8b00b467611607df0ff369d062528875
Author: Jakob Bornecrantz <jakob@tungstengraphics.com>
Date:   Fri Dec 19 14:50:50 2008 +1000

    drm: sanitise drm modesetting API + remove unused hotplug
    
    The initially merged modesetting API has some uglies in it, this
    cleans up the struct members and ioctl ordering for initial submission.
    
    It also removes the unneeded hotplug infrastructure.
    
    airlied:- I've pulled this patch in from git modesetting-gem tree.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit df989374a9f5356ee815baa1ba6916671a701da2
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 19 12:00:46 2008 +1100

    drm: fix allowing master ioctls on non-master fds.
    
    The multi-master patches changed master to a pointer, and this fell out,
    change to use is_master.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4e74f36d08e83390121d088f1f62e3337603df89
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 19 10:23:14 2008 +1100

    drm/radeon: use locked rmmap to remove sarea mapping.
    
    this exports the locked version of the symbol as struct_mutex locks it all.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 60f2ee0b4a6b852299d8e30aeb2af517ef5ee19c
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 19 10:22:02 2008 +1100

    drm/radeon: fix missing hunk from the master changes.
    
    Thanks to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> for reporting
    this.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f890607b1e93dc6fdc2a42b60656c917adf6257f
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Dec 18 16:59:02 2008 +1000

    drm: fix useless gcc unused variable warning
    
    the calling function doesn't call this function unless one of the two
    states that sets the value is true.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bdf539ad61a8d4d0f0b0865c030a8ecb1ec2a398
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Dec 18 16:56:11 2008 +1000

    drm/radeon: fix warning due to PAGE_SIZE max
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 57a6297e52b32ff402291a7d8fd802f83e746e52
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Dec 13 18:21:08 2008 +1000

    drm: kconfig have drm core select i2c for kms
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ae14dc0505261978ca06075ac39cc5422c6c6b57
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Dec 11 17:06:35 2008 +1000

    drm: PAGE_CACHE_WC is x86 only so far
    
    The page protections need to be checked whether they need to be more flexible.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aa91c6665a5e387e488c4a0b5da2536cc9c9f16e
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Dec 8 14:55:27 2008 +1000

    drm: pick an 800x600@60HZ mode by default for unknown CRT.
    
    This is what X picks now, so we should do the same.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 60fd99e3682c5acc74d58ed61dac93526d6976f7
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Dec 3 22:50:02 2008 -0800

    drm/i915: Fix stolen memory detection on G45 and GM45.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 06d9f33ceb6be29c453915505a2fc88d80c36417
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Dec 3 22:43:14 2008 -0800

    drm/i915: Register module dependencies for the modesetting code.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 79e539453b34e35f39299a899d263b0a1f1670bd
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Nov 7 14:24:08 2008 -0800

    DRM: i915: add mode setting support
    
    This commit adds i915 driver support for the DRM mode setting APIs.
    Currently, VGA, LVDS, SDVO DVI & VGA, TV and DVO LVDS outputs are
    supported.  HDMI, DisplayPort and additional SDVO output support will
    follow.
    
    Support for the mode setting code is controlled by the new 'modeset'
    module option.  A new config option, CONFIG_DRM_I915_KMS controls the
    default behavior, and whether a PCI ID list is built into the module for
    use by user level module utilities.
    
    Note that if mode setting is enabled, user level drivers that access
    display registers directly or that don't use the kernel graphics memory
    manager will likely corrupt kernel graphics memory, disrupt output
    configuration (possibly leading to hangs and/or blank displays), and
    prevent panic/oops messages from appearing.  So use caution when
    enabling this code; be sure your user level code supports the new
    interfaces.
    
    A new SysRq key, 'g', provides emergency support for switching back to
    the kernel's framebuffer console; which is useful for testing.
    
    Co-authors: Dave Airlie <airlied@linux.ie>, Hong Liu <hong.liu@intel.com>
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f453ba0460742ad027ae0c4c7d61e62817b3e7ef
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Nov 7 14:05:41 2008 -0800

    DRM: add mode setting support
    
    Add mode setting support to the DRM layer.
    
    This is a fairly big chunk of work that allows DRM drivers to provide
    full output control and configuration capabilities to userspace.  It was
    motivated by several factors:
      - the fb layer's APIs aren't suited for anything but simple
        configurations
      - coordination between the fb layer, DRM layer, and various userspace
        drivers is poor to non-existent (radeonfb excepted)
      - user level mode setting drivers makes displaying panic & oops
        messages more difficult
      - suspend/resume of graphics state is possible in many more
        configurations with kernel level support
    
    This commit just adds the core DRM part of the mode setting APIs.
    Driver specific commits using these new structure and APIs will follow.
    
    Co-authors: Jesse Barnes <jbarnes@virtuousgeek.org>, Jakob Bornecrantz <jakob@tungstengraphics.com>
    Contributors: Alan Hourihane <alanh@tungstengraphics.com>, Maarten Maathuis <madman2003@gmail.com>
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit de151cf67ce52ed2d88083daa5e60c7858947329
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Nov 12 10:03:55 2008 -0800

    drm/i915: add GEM GTT mapping support
    
    Use the new core GEM object mapping code to allow GTT mapping of GEM
    objects on i915.  The fault handler will make sure a fence register is
    allocated too, if the object in question is tiled.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a2c0a97b784f837300f7b0869c82ab712c600952
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Nov 5 10:31:53 2008 -0800

    drm: GEM mmap support
    
    Add core support for mapping of GEM objects.  Drivers should provide a
    vm_operations_struct if they want to support page faulting of objects.
    The code for handling GEM object offsets was taken from TTM, which was
    written by Thomas Hellström.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a9587470f753d670d910293ecbf1c7b66c99de50
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Nov 5 12:37:42 2008 -0800

    drm/i915: Add /proc debugging entry for reading out the HWS.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Dec 7 12:02:21 2008 +1000

    drm: reorganise start and load.
    
    Make sure we have the primary node so the device can add maps.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1147c9cdd0f60f09a98702a9f865176af18a989f
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Tue Dec 2 13:38:47 2008 +1000

    drm: fix leak of uninitialized data to userspace
    
    ...so drm_getunique() is trying to copy some uninitialized data to
    userspace. The ECX register contains the number of words that are
    left to copy -- so there are 5 * 4 = 20 bytes left. The offset of the
    first uninitialized byte (counting from the start of the string) is
    also 20 (i.e. 0xf65d2294&((1 << 5)-1) == 20). So somebody tried to
    copy 40 bytes when the string was only 19 long.
    
    In drm_set_busid() we have this code:
    
            dev->unique_len = 40;
            dev->unique = drm_alloc(dev->unique_len + 1, DRM_MEM_DRIVER);
          ...
            len = snprintf(dev->unique, dev->unique_len, pci:%04x:%02x:%02x.%d",
    
    ...so it seems that dev->unique is never updated to reflect the
    actual length of the string. The remaining bytes (20 in this case)
    are random uninitialized bytes that are copied into userspace.
    
    This patch fixes the problem by setting dev->unique_len after the
    snprintf().
    
    airlied- I've had to fix this up to store the alloced size so
    we have it for drm_free later.
    
    Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
    Signed-off-by: Vegard Nossum <vegardno@thuin.ifi.uio.no>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Nov 28 14:22:24 2008 +1000

    drm: move to kref per-master structures.
    
    This is step one towards having multiple masters sharing a drm
    device in order to get fast-user-switching to work.
    
    It splits out the information associated with the drm master
    into a separate kref counted structure, and allocates this when
    a master opens the device node. It also allows the current master
    to abdicate (say while VT switched), and a new master to take over
    the hardware.
    
    It moves the Intel and radeon drivers to using the sarea from
    within the new master structures.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e7f7ab45ebcb54fd5f814ea15ea079e079662f67
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Nov 28 13:43:47 2008 +1000

    drm: cleanup exit path for module unload
    
    The current sub-module unload exit path is a mess, it tries
    to abuse the idr. Just keep a list of devices per driver struct
    and free them in-order on rmmod.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-481736133-1230539533=:20427--
