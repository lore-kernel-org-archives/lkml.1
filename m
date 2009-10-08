Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZJHFx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZJHFx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZJHFx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:53:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51691 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZJHFx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:53:57 -0400
Date: Thu, 8 Oct 2009 06:53:23 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] more drm kms code
Message-ID: <alpine.DEB.2.00.0910080648450.5562@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Its had a recent merge because it was definitely getting non-trivial to 
fixup,

non-radeon-kms: adds proper fb layer colormap support + 8/16 bpp support,
since I added mode selection it seems like a bug that depth select didn't 
work. Tested on Intel and radeon gpus.

radeon-kms: move all gpus to new cleaner init path, drop old paths, this
gives better suspend/resume on most chips, r600 AGP additions, multi-card 
TTM unload refcount fix, single crtc server gpu support, some r600 
stability fixes.

Dave.

 drivers/gpu/drm/drm_crtc.c                      |    2 -
 drivers/gpu/drm/drm_fb_helper.c                 |  138 +++++--
 drivers/gpu/drm/i915/intel_display.c            |   11 +
 drivers/gpu/drm/i915/intel_drv.h                |    2 +
 drivers/gpu/drm/i915/intel_fb.c                 |   10 +-
 drivers/gpu/drm/radeon/atombios_crtc.c          |    1 +
 drivers/gpu/drm/radeon/r100.c                   |  432 +++++++++++++--------
 drivers/gpu/drm/radeon/r100d.h                  |  145 ++++++-
 drivers/gpu/drm/radeon/r200.c                   |    3 +-
 drivers/gpu/drm/radeon/r300.c                   |  308 ++++++++++-----
 drivers/gpu/drm/radeon/r300d.h                  |  205 ++++++++++
 drivers/gpu/drm/radeon/r420.c                   |    6 +-
 drivers/gpu/drm/radeon/r420d.h                  |   24 +-
 drivers/gpu/drm/radeon/r520.c                   |    3 +-
 drivers/gpu/drm/radeon/r600.c                   |  314 ++++++++-------
 drivers/gpu/drm/radeon/r600_blit.c              |   10 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c          |    3 +-
 drivers/gpu/drm/radeon/r600_cs.c                |    2 +-
 drivers/gpu/drm/radeon/r600d.h                  |    1 +
 drivers/gpu/drm/radeon/radeon.h                 |   58 ++--
 drivers/gpu/drm/radeon/radeon_asic.h            |  253 +++----------
 drivers/gpu/drm/radeon/radeon_bios.c            |   49 +++-
 drivers/gpu/drm/radeon/radeon_clocks.c          |    8 +-
 drivers/gpu/drm/radeon/radeon_device.c          |  237 ++----------
 drivers/gpu/drm/radeon/radeon_display.c         |   45 ++-
 drivers/gpu/drm/radeon/radeon_encoders.c        |    6 +-
 drivers/gpu/drm/radeon/radeon_fb.c              |   18 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |    6 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |    1 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    9 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |    2 +
 drivers/gpu/drm/radeon/radeon_object.c          |   17 +-
 drivers/gpu/drm/radeon/rs100d.h                 |   40 ++
 drivers/gpu/drm/radeon/rs400.c                  |  275 +++++++++----
 drivers/gpu/drm/radeon/rs400d.h                 |  160 ++++++++
 drivers/gpu/drm/radeon/rs600.c                  |  481 +++++++++++++---------
 drivers/gpu/drm/radeon/rs600d.h                 |  470 ++++++++++++++++++++++
 drivers/gpu/drm/radeon/rs690.c                  |  355 +++++++++++------
 drivers/gpu/drm/radeon/rs690d.h                 |  307 +++++++++++++++
 drivers/gpu/drm/radeon/rs690r.h                 |   99 -----
 drivers/gpu/drm/radeon/rv200d.h                 |   36 ++
 drivers/gpu/drm/radeon/rv250d.h                 |  123 ++++++
 drivers/gpu/drm/radeon/rv350d.h                 |   52 +++
 drivers/gpu/drm/radeon/rv515.c                  |    5 +-
 drivers/gpu/drm/radeon/rv770.c                  |  199 ++++------
 drivers/gpu/drm/ttm/ttm_global.c                |    2 +-
 include/drm/drm_crtc_helper.h                   |    3 +
 include/drm/drm_fb_helper.h                     |    7 +-
 include/drm/drm_pciids.h                        |    4 +-
 49 files changed, 3337 insertions(+), 1610 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/rs100d.h
 create mode 100644 drivers/gpu/drm/radeon/rs400d.h
 create mode 100644 drivers/gpu/drm/radeon/rs600d.h
 create mode 100644 drivers/gpu/drm/radeon/rs690d.h
 delete mode 100644 drivers/gpu/drm/radeon/rs690r.h
 create mode 100644 drivers/gpu/drm/radeon/rv200d.h
 create mode 100644 drivers/gpu/drm/radeon/rv250d.h
 create mode 100644 drivers/gpu/drm/radeon/rv350d.h

commit c1176d6f03e1085797ce83648a2c76ae15a2b515
Merge: 0eca52a d4ac6a0
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Oct 8 14:03:05 2009 +1000

    Merge branch 'drm-next' of ../drm-next into drm-linus
    
    conflict in radeon since new init path merged with vga arb code.
    
    Conflicts:
    	drivers/gpu/drm/radeon/radeon.h
    	drivers/gpu/drm/radeon/radeon_asic.h
    	drivers/gpu/drm/radeon/radeon_device.c

commit d4ac6a05d51357e31028cc9076874a58dd197b83
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Oct 8 11:32:49 2009 +1000

    drm/radeon/kms: fix vline register for second head.
    
    Both r100/r600 had this wrong, use the macro to extract the register
    to relocate.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 49c458e544ae14514209ed80ea6829ca1b18ddf0
Author: Robert Noland <rnoland@2hip.net>
Date:   Mon Oct 5 11:56:44 2009 -0400

    drm/r600: avoid assigning vb twice in blit code
    
    There is no need to assign vb before you know that space is available.
    
    [agd5f: adapted for kernel tree.]
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9d8401fcbb8c8a390b649b9c1b18dab113a918d6
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Oct 8 09:28:19 2009 +1000

    drm/radeon: use list_for_each_entry instead of list_for_each
    
    This is just a cleanup of the list macro usage.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1a029b768f9d4a001501bd18d6ba08297ae912fd
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Oct 6 19:04:30 2009 +0200

    drm/radeon/kms: Fix AGP support for R600/RV770 family (v2)
    
    For AGP to work unmapped access must cover VRAM & AGP as
    AGP is treated like VRAM by the GPU (ie physical address).
    This patch properly setup the virtual memory system aperture
    to cover AGP if AGP is enabled. It seems that there is memory
    corruption after resume when using AGP (RV770 seems unaffected
    thought). Version 2 just fix merge issue with updated AGP
    fallback patch.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b574f251f787c5b163da5ea345525569e51775bc
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Oct 6 19:04:29 2009 +0200

    drm/radeon/kms: Fallback to non AGP when acceleration fails to initialize (v2)
    
    When GPU acceleration is not working with AGP try to fallback to non
    AGP GART (either PCI or PCIE GART). This should make KMS failure on
    AGP less painfull. We still need to find out what is wrong when AGP
    fails but at least user have a lot of more chances to get a working
    configuration with acceleration. This patch also cleanup R600/RV770
    fallback path so they use same code as others asics. Version 2
    factorize agp disabling logic to avoid code duplication and bugs.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 01ceae8edd7a0a6d8588dc103ad9f55e2c52cae9
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Oct 7 11:08:22 2009 +0200

    drm/radeon/kms: Fix RS600/RV515/R520/RS690 IRQ
    
    Bad generated header file leaded to use wrong register
    to check IRQ status and acknowledge them. Fix the header
    and use proper registers.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aa96e341c2a14d6bec114c933bd813ecb972605f
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Tue Oct 6 21:48:40 2009 +0200

    drm/radeon: Fix setting of bits
    
    Duplicate bits set
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit df748b025d1357c2b9659e16a6040596e60e4257
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Sep 29 13:56:38 2009 +1000

    drm/ttm: fix refcounting in ttm global code.
    
    the global refcount wasn't being increased after the first reference.
    this caused an oops on unload on a multi-gpu card.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b8c00ac5b50b54491657f8b6740db1df50149944
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Oct 6 13:54:01 2009 +1000

    drm/fb: add more correct 8/16/24/32 bpp fb support.
    
    The previous patches had some unwanted side effects, I've fixed
    the lack of 32bpp working, and fixed up 16bpp so it should also work.
    
    this also adds the interface to allow the driver to set a preferred
    console depth so for example low memory rn50 can set it to 8bpp.
    It also catches 24bpp on cards that can't do it and forces 32bpp.
    
    Tested on r100/r600/i945.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 068143d38804825d59d951a192cfadd2e22f457d
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Oct 5 09:58:02 2009 +1000

    drm/fb: add setcmap and fix 8-bit support.
    
    This adds support for the setcmap api and fixes the 8bpp
    support at least on radeon hardware. It adds a new load_lut
    hook which can be called once the color map is setup.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dfee5614e4d83a32cef9193a8b19bc1d8900f93d
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Oct 2 09:19:09 2009 +1000

    drm/radeon/kms: respect single crtc cards, only create one crtc. (v2)
    
    Also add single crtc for RN50 chips.
    
    changes in v2:
    fix vblank init to respect single crtc flag
    fix r100 mode bandwidth to respect single crtc flag
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 185974dd596e67e73906790c2a4a4579d75911e6
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Sep 30 15:21:43 2009 +0800

    drm: Delete the DRM_DEBUG_KMS in drm_mode_cursor_ioctl
    
    We can get the corresponding info by adding the boot option of "drm.debug=
    0x07". But On some boxes it will print the following message many times in
    course of moving mouse. In such case the useful DRM debug info will be flushed.
       >[drm:drm_mode_cursor_ioctl],
    
    Avoid using the DRM_DEBUG_KMS in drm_mode_cursor_ioctl.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b442962a9e826e6d408886b3e52c88b774201983
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Oct 2 17:36:41 2009 -0400

    drm/radeon/kms: add support for "Surround View"
    
    "Surround View" is an option in the system bios that
    enables the AMD IGP chip in conjunction with a
    discrete AMD card.  However, since the IGP vbios is
    part of the system bios it is not accessible via the
    rom bar or the legacy vga location.  When "Surround View"
    is enabled in the system bios, the system bios puts a
    copy of the IGP vbios image at the start of vram.
    
    This patch adds support for reading the vbios image out
    of vram on IGP cards.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ac447df4f2283a116a3fbbc28cbaabf05758b736
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 30 22:18:43 2009 +0200

    drm/radeon/kms: Fix irq handling on AVIVO hw
    
    Avivo hw have vblank interrupt in different place, fixes
    irq handling (especialy irq disabling while suspending or
    shuting down the module).
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e7d40b9a0a7c857383ef50db9766354bd3be1bf3
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 18:02:15 2009 +0200

    drm/radeon/kms: R600/RV770 remove dead code and print message for wrong BIOS
    
    R600 & RV770 family are all using atombios so remove dead code and
    print an error message if we fail to find a valid atombios.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 75c8129893d78fd0cbe5c26580cadd6001d904fc
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 18:02:14 2009 +0200

    drm/radeon/kms: Fix R600/RV770 disable acceleration path
    
    When acceleration doesn't work we should free associated memory
    and stop GPU block responsible for hardware acceleration so we
    don't waste resource or let think one component of the driver that
    a GPU feature is working/running while it doesn't actualy work.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a3c1945aaf48a5893238d95139f202531994094d
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 18:02:13 2009 +0200

    drm/radeon/kms: Fix R600/RV770 startup path & reset
    
    We were calling reset unconditionaly in the startup path
    this is bad we need to call GPU reset for a good reason
    as after reset the GPU is in unknown states. To avoid any
    more bad things to happen we now also unconditionaly
    reinitialize the GPU after reset. This patch fix few issues
    reported by different people regarding KMS & R6XX/RV7XX hw.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 81cc35bfc19ebe4b823396fe4fef67a923360916
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 18:02:12 2009 +0200

    drm/radeon/kms: Fix R600 write back buffer
    
    This split write back buffer handling into 3 functions,
    wb_fini for cleanup, wb_enable/wb_disable for enabling/disabling
    write back used for suspend/resume. This should fix
    potential issue of letting the write back active before
    suspending. We need to allocate memory in wb_enable because
    we can only allocate once GART is running.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 62a8ea3f7bb61e5f92db0a648b7cc566852c36ec
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 18:02:11 2009 +0200

    drm/radeon/kms: Remove old init path as no hw use it anymore
    
    This remove old init path and allow code cleanup, now all hw
    use the new init path, see top of radeon.h for description of
    this.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c010f8000a925e08d84d9391e13dd297b9fdc393
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 30 22:09:06 2009 +0200

    drm/radeon/kms: Convert RS600 to new init path
    
    New init path allow to simply asic initialization and make easier
    to trace what happen on each different asic. We are removing most
    callback. Do a massive RS600 register cleanup to clarify RS600
    register, we are still bit fuzy on some register and waiting for
    more informations. I don't have hw to test, so this patch is a
    best effort to not break anythings and to try to improve things.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3bc6853593bd4fba357dc252b3cf60cd86a1d2ec
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 09:39:24 2009 +0200

    drm/radeon/kms: Convert RS690/RS740 to new init path (V2).
    
    Also cleanup register specific to RS690/RS740. Version 2 add
    missing header file for register, remove unecessary call to AGP
    function and fix an indentation bug.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d4550907157d8b3d5286157c15f1200c44842269
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 10:12:06 2009 +0200

    drm/radeon/kms: Convert R100 to new init path (V2)
    
    New init path allow to simply asic initialization and make easier
    to trace what happen on each different asic. We are removing most
    callback. More cleanup should happen latter to remove even more
    callback. Also cleanup register specific to R100,RV200,RV250.
    Version 2 correct the placement on IGP of the VRAM inside GPU address
    space to match the stollen RAM placement of IGP.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 207bf9e90cd40f91d4662127b8ae3b64e6b101c4
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 30 15:35:32 2009 +0200

    drm/radeon/kms: Convert R300 to new init path
    
    Also cleanup register specific to R300.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ca6ffc64cba0cdd0a2b3fcad0e1d19edcf277ccc
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Oct 1 10:20:52 2009 +0200

    drm/radeon/kms: Convert RS400/RS480 to new init path & fix legacy VGA (V3)
    
    Also cleanup register specific to RS400/RS480. This patch also fix
    legacy VGA register used to disable VGA access we were programming
    wrong register. Now we should properly disable VGA on r100 up to
    rs400 asics. Note that RS400/RS480 resume is broken, it hangs the
    computer while reprogramming dynamic clock, doesn't work either
    without that patch. We need to spend more time investigating this
    issue. Version 2 of the patch remove dead code that was left
    commented out in the previous version. Version 3 correct the
    placement on IGP of the VRAM inside GPU address space to match the
    stollen RAM placement of IGP.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
