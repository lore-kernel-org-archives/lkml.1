Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZFPVrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZFPVrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZFPVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:47:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60183 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFPVrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:47:16 -0400
Date: Tue, 16 Jun 2009 22:47:16 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm git - fixes + radeon KMS (staging)
Message-ID: <alpine.DEB.2.00.0906162245360.13551@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This contains the late_initcall fix, actually fixing it properly will 
require some investigation (we don't build in drm and radeon on distro 
kernels), I'll get the main author to take a look when he wakes up.

Dave.

 drivers/gpu/drm/Kconfig                         |   13 +
 drivers/gpu/drm/Makefile                        |    2 +-
 drivers/gpu/drm/drm_mm.c                        |   20 +-
 drivers/gpu/drm/radeon/Kconfig                  |   34 +
 drivers/gpu/drm/radeon/Makefile                 |   12 +-
 drivers/gpu/drm/radeon/ObjectID.h               |  578 +++
 drivers/gpu/drm/radeon/atom-bits.h              |   48 +
 drivers/gpu/drm/radeon/atom-names.h             |  100 +
 drivers/gpu/drm/radeon/atom-types.h             |   42 +
 drivers/gpu/drm/radeon/atom.c                   | 1215 ++++++
 drivers/gpu/drm/radeon/atom.h                   |  149 +
 drivers/gpu/drm/radeon/atombios.h               | 4785 +++++++++++++++++++++++
 drivers/gpu/drm/radeon/atombios_crtc.c          |  695 ++++
 drivers/gpu/drm/radeon/r100.c                   | 1524 ++++++++
 drivers/gpu/drm/radeon/r300.c                   | 1116 ++++++
 drivers/gpu/drm/radeon/r300_reg.h               |   52 +-
 drivers/gpu/drm/radeon/r420.c                   |  223 ++
 drivers/gpu/drm/radeon/r500_reg.h               |  749 ++++
 drivers/gpu/drm/radeon/r520.c                   |  234 ++
 drivers/gpu/drm/radeon/r600.c                   |  169 +
 drivers/gpu/drm/radeon/r600_reg.h               |  114 +
 drivers/gpu/drm/radeon/radeon.h                 |  793 ++++
 drivers/gpu/drm/radeon/radeon_agp.c             |  249 ++
 drivers/gpu/drm/radeon/radeon_asic.h            |  405 ++
 drivers/gpu/drm/radeon/radeon_atombios.c        | 1298 ++++++
 drivers/gpu/drm/radeon/radeon_benchmark.c       |  133 +
 drivers/gpu/drm/radeon/radeon_bios.c            |  390 ++
 drivers/gpu/drm/radeon/radeon_clocks.c          |  833 ++++
 drivers/gpu/drm/radeon/radeon_combios.c         | 2481 ++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c      |  603 +++
 drivers/gpu/drm/radeon/radeon_cs.c              |  249 ++
 drivers/gpu/drm/radeon/radeon_cursor.c          |  252 ++
 drivers/gpu/drm/radeon/radeon_device.c          |  813 ++++
 drivers/gpu/drm/radeon/radeon_display.c         |  692 ++++
 drivers/gpu/drm/radeon/radeon_drv.c             |  217 +-
 drivers/gpu/drm/radeon/radeon_encoders.c        | 1708 ++++++++
 drivers/gpu/drm/radeon/radeon_fb.c              |  825 ++++
 drivers/gpu/drm/radeon/radeon_fence.c           |  387 ++
 drivers/gpu/drm/radeon/radeon_fixed.h           |   50 +
 drivers/gpu/drm/radeon/radeon_gart.c            |  233 ++
 drivers/gpu/drm/radeon/radeon_gem.c             |  287 ++
 drivers/gpu/drm/radeon/radeon_i2c.c             |  209 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |  158 +
 drivers/gpu/drm/radeon/radeon_kms.c             |  295 ++
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     | 1276 ++++++
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c | 1288 ++++++
 drivers/gpu/drm/radeon/radeon_mode.h            |  398 ++
 drivers/gpu/drm/radeon/radeon_object.c          |  511 +++
 drivers/gpu/drm/radeon/radeon_object.h          |   45 +
 drivers/gpu/drm/radeon/radeon_reg.h             | 3570 +++++++++++++++++
 drivers/gpu/drm/radeon/radeon_ring.c            |  485 +++
 drivers/gpu/drm/radeon/radeon_ttm.c             |  653 +++
 drivers/gpu/drm/radeon/rs400.c                  |  411 ++
 drivers/gpu/drm/radeon/rs600.c                  |  324 ++
 drivers/gpu/drm/radeon/rs690.c                  |  181 +
 drivers/gpu/drm/radeon/rs780.c                  |  102 +
 drivers/gpu/drm/radeon/rv515.c                  |  504 +++
 drivers/gpu/drm/radeon/rv770.c                  |  124 +
 drivers/gpu/drm/ttm/Makefile                    |    8 +
 drivers/gpu/drm/ttm/ttm_agp_backend.c           |  150 +
 drivers/gpu/drm/ttm/ttm_bo.c                    | 1698 ++++++++
 drivers/gpu/drm/ttm/ttm_bo_util.c               |  561 +++
 drivers/gpu/drm/ttm/ttm_bo_vm.c                 |  454 +++
 drivers/gpu/drm/ttm/ttm_global.c                |  114 +
 drivers/gpu/drm/ttm/ttm_memory.c                |  234 ++
 drivers/gpu/drm/ttm/ttm_module.c                |   50 +
 drivers/gpu/drm/ttm/ttm_tt.c                    |  635 +++
 drivers/staging/Kconfig                         |    2 +
 include/drm/drm_pciids.h                        |    8 +-
 include/drm/radeon_drm.h                        |  130 +
 include/drm/ttm/ttm_bo_api.h                    |  618 +++
 include/drm/ttm/ttm_bo_driver.h                 |  867 ++++
 include/drm/ttm/ttm_memory.h                    |  153 +
 include/drm/ttm/ttm_module.h                    |   58 +
 include/drm/ttm/ttm_placement.h                 |   92 +
 75 files changed, 41092 insertions(+), 46 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/Kconfig
 create mode 100644 drivers/gpu/drm/radeon/ObjectID.h
 create mode 100644 drivers/gpu/drm/radeon/atom-bits.h
 create mode 100644 drivers/gpu/drm/radeon/atom-names.h
 create mode 100644 drivers/gpu/drm/radeon/atom-types.h
 create mode 100644 drivers/gpu/drm/radeon/atom.c
 create mode 100644 drivers/gpu/drm/radeon/atom.h
 create mode 100644 drivers/gpu/drm/radeon/atombios.h
 create mode 100644 drivers/gpu/drm/radeon/atombios_crtc.c
 create mode 100644 drivers/gpu/drm/radeon/r100.c
 create mode 100644 drivers/gpu/drm/radeon/r300.c
 create mode 100644 drivers/gpu/drm/radeon/r420.c
 create mode 100644 drivers/gpu/drm/radeon/r500_reg.h
 create mode 100644 drivers/gpu/drm/radeon/r520.c
 create mode 100644 drivers/gpu/drm/radeon/r600.c
 create mode 100644 drivers/gpu/drm/radeon/r600_reg.h
 create mode 100644 drivers/gpu/drm/radeon/radeon.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_agp.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_asic.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_atombios.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_benchmark.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_bios.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_clocks.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_combios.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_connectors.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_cs.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_cursor.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_device.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_display.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_encoders.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_fb.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_fence.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_fixed.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_gart.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_gem.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_i2c.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_irq_kms.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_kms.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_legacy_crtc.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_legacy_encoders.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_mode.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_object.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_object.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_reg.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_ring.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_ttm.c
 create mode 100644 drivers/gpu/drm/radeon/rs400.c
 create mode 100644 drivers/gpu/drm/radeon/rs600.c
 create mode 100644 drivers/gpu/drm/radeon/rs690.c
 create mode 100644 drivers/gpu/drm/radeon/rs780.c
 create mode 100644 drivers/gpu/drm/radeon/rv515.c
 create mode 100644 drivers/gpu/drm/radeon/rv770.c
 create mode 100644 drivers/gpu/drm/ttm/Makefile
 create mode 100644 drivers/gpu/drm/ttm/ttm_agp_backend.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo_util.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo_vm.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_global.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_memory.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_module.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_tt.c
 create mode 100644 include/drm/ttm/ttm_bo_api.h
 create mode 100644 include/drm/ttm/ttm_bo_driver.h
 create mode 100644 include/drm/ttm/ttm_memory.h
 create mode 100644 include/drm/ttm/ttm_module.h
 create mode 100644 include/drm/ttm/ttm_placement.h

commit cc8da5263fa743c33d6503f85113bcb70048e633
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jun 17 07:41:23 2009 +1000

    drm/radeon: switch to using late_initcall
    
    This fixes an issue where we get inited before fbcon when built-in.
    
    Ideally this should work as a non late_initcall, but this fixes it for now.
    We also don't suggest people build this in (at least distro maintainers).
    
    Reported-by: Ryan Hope <rmh3093@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6fe7ac3f5b544703581f3829c8c950dc721d976e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Jun 12 17:26:08 2009 +0000

    radeon legacy chips: tv dac bg/dac adj updates
    
    COMBIOS - fallback to table values if there are no tv dac or lvds bios tables
    ATOMBIOS - add support for looking up these values from the bios table
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 771fe6b912fca54f03e8a72eb63058b582775362
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Jun 5 14:42:42 2009 +0200

    drm/radeon: introduce kernel modesetting for radeon hardware
    
    Add kernel modesetting support to radeon driver, use the ttm memory
    manager to manage memory and DRM/GEM to provide userspace API.
    In order to avoid backward compatibility issue and to allow clean
    design and code the radeon kernel modesetting use different code path
    than old radeon/drm driver.
    
    When kernel modesetting is enabled the IOCTL of radeon/drm
    driver are considered as invalid and an error message is printed
    in the log and they return failure.
    
    KMS enabled userspace will use new API to talk with the radeon/drm
    driver. The new API provide functions to create/destroy/share/mmap
    buffer object which are then managed by the kernel memory manager
    (here TTM). In order to submit command to the GPU the userspace
    provide a buffer holding the command stream, along this buffer
    userspace have to provide a list of buffer object used by the
    command stream. The kernel radeon driver will then place buffer
    in GPU accessible memory and will update command stream to reflect
    the position of the different buffers.
    
    The kernel will also perform security check on command stream
    provided by the user, we want to catch and forbid any illegal use
    of the GPU such as DMA into random system memory or into memory
    not owned by the process supplying the command stream. This part
    of the code is still incomplete and this why we propose that patch
    as a staging driver addition, future security might forbid current
    experimental userspace to run.
    
    This code support the following hardware : R1XX,R2XX,R3XX,R4XX,R5XX
    (radeon up to X1950). Works is underway to provide support for R6XX,
    R7XX and newer hardware (radeon from HD2XXX to HD4XXX).
    
    Authors:
        Jerome Glisse <jglisse@redhat.com>
        Dave Airlie <airlied@redhat.com>
        Alex Deucher <alexdeucher@gmail.com>
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ba4e7d973dd09b66912ac4c0856add8b0703a997
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jun 10 15:20:19 2009 +0200

    drm: Add the TTM GPU memory manager subsystem.
    
    TTM is a GPU memory manager subsystem designed for use with GPU
    devices with various memory types (On-card VRAM, AGP,
    PCI apertures etc.). It's essentially a helper library that assists
    the DRM driver in creating and managing persistent buffer objects.
    
    TTM manages placement of data and CPU map setup and teardown on
    data movement. It can also optionally manage synchronization of
    data on a per-buffer-object level.
    
    TTM takes care to provide an always valid virtual user-space address
    to a buffer object which makes user-space sub-allocation of
    big buffer objects feasible.
    
    TTM uses a fine-grained per buffer-object locking scheme, taking
    care to release all relevant locks when waiting for the GPU.
    Although this implies some locking overhead, it's probably a big
    win for devices with multiple command submission mechanisms, since
    the lock contention will be minimal.
    
    TTM can be used with whatever user-space interface the driver
    chooses, including GEM. It's used by the upcoming Radeon KMS DRM driver
    and is also the GPU memory management core of various new experimental
    DRM drivers.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e6c03c5b40314d787f7053f631594d6b1bd609e8
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri May 22 14:14:22 2009 +0100

    drm: Memory fragmentation from lost alignment blocks
    
    If the block needs an alignment but otherwise fits exactly into the tail,
    then the split-off block from the start would remain marked as non-free.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 602c11a8ee62d49cddbc5972e5edb876dd415113
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jun 15 09:24:41 2009 +1000

    drm/radeon: fix mobility flags on new PCI IDs.
    
    These aren't used that much on r600, but may be needed in the future,
    so get them correct now.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
