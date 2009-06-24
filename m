Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZFXGmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZFXGmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZFXGmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:42:25 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44659 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZFXGmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:42:24 -0400
Date: Wed, 24 Jun 2009 07:42:24 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes + intel display port
Message-ID: <alpine.DEB.2.00.0906240723420.18292@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1970699625-1245825744=:18292"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1970699625-1245825744=:18292
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

You might want to test this one on the Mac-Mini at least, I think it 
should fix most of the issues you were seeing.

It is a bit big and I'm not sure if the merge window closed yet, but Eric 
was away for a lot of it and is gone again so I've just pulled his latest
Intel tree from him, it contains some fixes but also DisplayPort support.

In non-intel code, there is mainly KMS radeon fixes, but primarily is the
EDID parser fixes from Michel since the endian changes, the fbcon/radeon 
load ordering proper fix, and the radeon kms fb smem_start proper fix.

Dave.

 drivers/gpu/drm/Kconfig                |    1 +
 drivers/gpu/drm/Makefile               |    2 +-
 drivers/gpu/drm/drm_edid.c             |   12 +-
 drivers/gpu/drm/i915/Makefile          |    2 +
 drivers/gpu/drm/i915/dvo.h             |    4 +-
 drivers/gpu/drm/i915/dvo_ch7017.c      |   20 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c      |   25 +-
 drivers/gpu/drm/i915/dvo_ivch.c        |   21 +-
 drivers/gpu/drm/i915/dvo_sil164.c      |   25 +-
 drivers/gpu/drm/i915/dvo_tfp410.c      |   25 +-
 drivers/gpu/drm/i915/i915_drv.c        |    4 +-
 drivers/gpu/drm/i915/i915_drv.h        |   12 +
 drivers/gpu/drm/i915/i915_gem.c        |   19 +-
 drivers/gpu/drm/i915/i915_gem_debug.c  |    6 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c |    2 +
 drivers/gpu/drm/i915/i915_irq.c        |   12 +-
 drivers/gpu/drm/i915/i915_reg.h        |   29 +
 drivers/gpu/drm/i915/i915_suspend.c    |   34 +-
 drivers/gpu/drm/i915/intel_bios.c      |   12 +-
 drivers/gpu/drm/i915/intel_display.c   |  199 ++++--
 drivers/gpu/drm/i915/intel_dp.c        | 1153 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_dp.h        |  144 ++++
 drivers/gpu/drm/i915/intel_dp_i2c.c    |  272 ++++++++
 drivers/gpu/drm/i915/intel_drv.h       |   17 +-
 drivers/gpu/drm/i915/intel_dvo.c       |   16 +-
 drivers/gpu/drm/i915/intel_hdmi.c      |   35 +-
 drivers/gpu/drm/i915/intel_i2c.c       |   16 +-
 drivers/gpu/drm/i915/intel_lvds.c      |  344 +++++++++-
 drivers/gpu/drm/i915/intel_modes.c     |   14 +-
 drivers/gpu/drm/i915/intel_sdvo.c      |   72 +--
 drivers/gpu/drm/i915/intel_tv.c        |   53 +-
 drivers/gpu/drm/radeon/radeon_device.c |   22 +-
 drivers/gpu/drm/radeon/radeon_drv.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_fb.c     |   33 +-
 drivers/gpu/drm/radeon/radeon_object.c |   30 -
 drivers/gpu/drm/ttm/ttm_bo_util.c      |    1 -
 drivers/gpu/drm/ttm/ttm_bo_vm.c        |    1 -
 drivers/gpu/drm/ttm/ttm_tt.c           |    1 -
 include/drm/drm_edid.h                 |   38 +-
 39 files changed, 2395 insertions(+), 335 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/intel_dp.c
 create mode 100644 drivers/gpu/drm/i915/intel_dp.h
 create mode 100644 drivers/gpu/drm/i915/intel_dp_i2c.c

commit 8b169b5f1f46da8ece1ce7304cda7155fffe3892
Author: Huang Weiyi <weiyi.huang@gmail.com>
Date:   Wed Jun 24 16:31:50 2009 +1000

    drm: remove unused #include <linux/version.h>'s
    
    Remove unused #include <linux/version.h>('s) in
     drivers/gpu/drm/ttm/ttm_bo_util.c
     drivers/gpu/drm/ttm/ttm_bo_vm.c
     drivers/gpu/drm/ttm/ttm_tt.c
    
    Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5b6345be1b41db5e70f90c3559c3b40c8abcde8b
Merge: 176f613... b5aa8a0...
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jun 24 16:20:19 2009 +1000

    Merge remote branch 'origin/drm-intel-next' of ../drm-intel into drm-fixes

commit 176f613e60b63f2d77e6c69f036cfc754f3aaac6
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Jun 22 18:16:13 2009 +0200

    drm/radeon: fix driver initialization order so radeon kms can be builtin
    
    TTM need to be initialized before radeon if KMS is enabled otherwise
    the kernel will crash hard.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e14cbee401cd00779a5267128371506b22c77bc9
Author: Michel Dänzer <michel@daenzer.net>
Date:   Tue Jun 23 12:36:32 2009 +0200

    drm: Fix shifts which were miscalculated when converting from bitfields.
    
    Looks like I managed to mess up most shifts when converting from bitfields. :(
    
    The patch below works on my Thinkpad T500 (as well as on my PowerBook,
    where the previous change worked as well, maybe out of luck...). I'd
    appreciate more testing and eyes looking over it though.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Tested-by: Michael Pyne <mpyne@kde.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b1e3a6d1c4d0ac75ad8289bcfd69efcc9b1bc6e5
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Jun 23 16:12:54 2009 +0200

    drm/radeon: Clear surface registers at initialization time.
    
    Some PowerMac firmwares set up a tiling surface at the beginning of VRAM
    which messes us up otherwise.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 696d4df1dbfe0b054e94c1990b49c1727ffc1ff0
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Jun 23 16:12:53 2009 +0200

    drm/radeon: Don't initialize acceleration related fields of struct fb_info.
    
    Might lure userspace into trying silly things otherwise.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f92e93eb5f4d56d73215f089580d53597bacd468
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Jun 22 18:15:58 2009 +0200

    drm/radeon: fix radeon kms framebuffer device
    
    smem.start is a physical address which kernel can remap to access
    video memory of the fb buffer. We now pin the fb buffer into vram
    by doing so we are loosing vram but fbdev need to be reworked to
    allow change in framebuffer address.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b5aa8a0fc132dd512c33e7c2621d075e3b77a65e
Author: Grégoire Henry <Gregoire.Henry@pps.jussieu.fr>
Date:   Tue Jun 23 15:41:02 2009 +0200

    drm/i915: initialize fence registers to zero when loading GEM
    
    Unitialized fence register could leads to corrupted display. Problem
    encountered on MacBooks (revision 1 and 2), directly booting from EFI
    or through BIOS emulation.
    
    (bug #21710 at freedestop.org)
    
    Signed-off-by: Grégoire Henry <henry@pps.jussieu.fr>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 56d21b07d44e0a33ab846f4f08e9e33bd87e5d4b
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Wed Jun 17 09:43:25 2009 +0800

    drm/i915: Fix HDMI regression introduced in new chipset support
    
    Remove wrongly added NULL_PACKETS_DURING_VSYNC setting for HDMI.
    
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 1b16de0b070dc6fa29b7a99980eabe3325ee5983
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Jun 22 11:30:30 2009 -0700

    drm/i915: fix LFP data fetch
    
    Apparently the proper way to do this is to use the LFP data pointer
    block to figure out the LFP data block entry size, then use that plus
    the panel index to calculate an offset into the LFP data block array.
    
    Similar fix has already been pushed to the 2D driver to fix fdo bug
    applied to the VBIOS reader, and things look sane).
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 8ed9a5bc9c9425ef93a1b03b418300a5e18b2361
Author: ling.ma@intel.com <ling.ma@intel.com>
Date:   Mon Jun 22 22:08:35 2009 +0800

    drm/i915: set TV detection mode when tv is already connected
    
    We used load_detect_temp flag to determine whether to set tv to the test
    mode. However if the TV already has a mode set, we still need to set the
    test mode to determine connection.  This results in blinking, but there is
    no other reliable way to determine TV connection.
    
    freedesktop.org bug #22035
    
    Signed-off-by: Ma Ling <ling.ma@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 921809a5831821eaf86e799c4b3d7c666ee352b1
Author: Krzysztof Halasa <khc@pm.waw.pl>
Date:   Fri Jun 19 22:35:09 2009 +0200

    drm/i915: Catch up to obj_priv->page_list rename in disabled debug code.
    
    Signed-off-by:  Krzysztof Halasa <khc@pm.waw.pl>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit cfd43c025ddef0b1c723bb9811d2bde52b285710
Author: Krzysztof Halasa <khc@pm.waw.pl>
Date:   Sat Jun 20 00:31:28 2009 +0200

    drm/i915: Fix size_t handling in off-by-default debug printfs
    
    Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit aa0261f230105b86409e29bbe851b09830d93d50
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jun 22 15:31:26 2009 +0800

    drm/i915: Don't change the blank/sync width when calculating scaled modes
    
    Also, use the border instead of border minus one.
    
    At the same time, make sure the horizontal border and hsync are even for
    the LVDS that works in dual-channel mode. So both horizontal border and hsync
    start are also changed to be even, even for the LVDS in single-channel mode.
    
    https://bugs.freedesktop.org/show_bug.cgi?id=20951
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 3fbe18d65d66054667aaee849bed74674bb50062
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jun 22 15:31:25 2009 +0800

    drm/i915: Add support for changing LVDS panel fitting using an output property.
    
    Previously the driver would always scale the chosen video mode to fill the
    panel.  This adds 1:1 and maintain-aspect-ratio scaling modes.
    
    v2: the drm_calloc/drm_free is replaced by kzalloc/kfree based
    on Eric's suggestion.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 9e06dd39f2b6d7e35981e0d7aded618686b32ccb
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Jun 22 18:05:12 2009 -0700

    drm/i915: correct suspend/resume ordering
    
    We need to save register state *after* idling GEM, clearing the ring,
    and uninstalling the IRQ handler, or we might end up saving bogus
    fence regs, for one.  Our restore ordering should already be correct,
    since we do GEM, ring and IRQ init after restoring the last register
    state, which prevents us from clobbering things.
    
    I put this together to potentially address a bug, but I haven't heard
    back if it fixes it yet.  However I think it stands on its own, so I'm
    sending it in.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit be9f1c4f738a715abbd8ea742f3ec60a1ce73f4b
Merge: 8c52da5... fb0f8fb...
Author: Eric Anholt <eric@anholt.net>
Date:   Sun Jun 21 22:14:55 2009 -0700

    Merge commit 'keithp/drm-intel-next' into drm-intel-next

commit 8c52da503b7e4cf961807f11824e3258ef9f7f1c
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Jun 18 20:22:19 2009 -0700

    drm/i915: Add missing dependency on Intel AGP support.
    
    Users could accidentally enable AGP but not the Intel AGP support, and get
    a DRM that doesn't probe as a result.
    
    Bug #22358.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit fb0f8fbf97e8a25074c81c629500d94cafa9e366
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Jun 11 22:31:31 2009 -0700

    drm/i915: Generate 2MHz clock for display port aux channel I/O. Retry I/O.
    
    The display port aux channel clock is taken from the hrawclk value, which is
    provided to the chip as the FSB frequency (as far as I can determine). The
    strapping values for that are available in the CLKCFG register, now used to
    select an appropriate divider to generate a 2MHz clock.
    
    In addition, the DisplayPort spec requires that each aux channel I/O be
    retried 'at least 3 times' in case the sink is idle when the first request
    comes in.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit a5b3da543d4882d57a2f3e05d37ad8e1e1453489
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Jun 11 22:30:32 2009 -0700

    drm/i915: Clarify error returns from display port aux channel I/O
    
    Use distinct error return values for each kind of aux channel I/O failure.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit b11248df4c0decb1e473d5025f237be32c0f67bb
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Jun 11 22:28:56 2009 -0700

    drm/i915: Add CLKCFG register definition
    
    The CLKCFG register holds information about the GMCH plls and input clock
    values.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit e4b366996bc58a02b9dc35db3ef83f0454553f50
Author: Keith Packard <keithp@keithp.com>
Date:   Fri Jun 5 19:22:17 2009 -0700

    drm/i915: Split array of DAC limits into separate structures.
    
    The array of DAC limits was only ever referenced with #defined constant
    offsets, and keeping those #define values in sync with the array itself was a
    nuisance. This will make future changes to the set of DAC limits less
    error-prone.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit c8110e52b753f3d105604df84ac06cd6d1645409
Author: Keith Packard <keithp@keithp.com>
Date:   Wed May 6 11:51:10 2009 -0700

    drm/i915: Use hotplug callback to retrain DP link
    
    When a DP monitor is plugged back in, it needs to be retrained if it was
    active before.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit a4fc5ed69817c73e32571ad7837bb707f9890009
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Apr 7 16:16:42 2009 -0700

    drm/i915: Add Display Port support
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit c31c4ba3437d98efa19710e30d694a1cfdf87aa5
Author: Keith Packard <keithp@keithp.com>
Date:   Wed May 6 11:48:58 2009 -0700

    drm/i915: add per-output hotplug callback for KMS
    
    This allows each output to deal with plug/unplug events as needed.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit 308cd3a2e505b0d15f2852e8db5d648b60a6313b
Author: Keith Packard <keithp@keithp.com>
Date:   Sun Jun 14 11:56:18 2009 -0700

    drm/i915: Clean up SDVO i2c handling
    
    Eliminate the copy of i2c_bus in sdvo_priv.
    Eliminate local copies of i2c_bus and ddcbus.
    Eliminate unused settings of slave_addr.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit f9c10a9b96a31b4a82a4fa807400c04f00284068
Author: Keith Packard <keithp@keithp.com>
Date:   Sat May 30 12:16:25 2009 -0700

    drm/i915: Change I2C api to pass around i2c_adapters
    
    The existing API passed around intel_i2c_chan pointers, which are dependent
    on the i2c bit-banging algo. This precluded the driver from using outputs
    which use a different algo. Switching to the more general i2c_adpater allows
    the driver to support non bit-banging DDC.
    
    This also required moving the slave address into the output private
    structures.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit b99e228d354cc1e7f19fb8b5f1297d493e309186
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jun 10 19:08:16 2009 -0700

    drm/i915: check for CONFIG_PNP before using pnp function
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit 98acd46f356e560c371c0e416d92e8e56be31804
Author: Keith Packard <keithp@keithp.com>
Date:   Sun Jun 14 12:31:58 2009 -0700

    drm/i915: Apple DMI info has inconsistent SYS_VENDOR information
    
    Some machines say 'Apple Inc.' while others say 'Apple Computer, Inc'.
    Switch the test to just look for 'Apple' instead.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>

commit aa93d632c496184e5b779dbcf961bf1c6ececf0b
Author: Keith Packard <keithp@keithp.com>
Date:   Tue May 5 09:52:46 2009 -0700

    drm/i915: Require digital monitor on HDMI ports for detect
    
    HDMI and DVI both require DDC/EDID on monitors, so use
    that to know when a monitor is connected as the hot-plug
    pins are shared with SDVO and DisplayPort
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
--29444707-1970699625-1245825744=:18292--
