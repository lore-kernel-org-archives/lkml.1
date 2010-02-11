Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0BKEUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 23:20:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41451 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0BKEUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 23:20:21 -0500
Date: Thu, 11 Feb 2010 04:20:07 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm
Message-ID: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-810061732-1265862007=:516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-810061732-1265862007=:516
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

vmware + nouveau staging fixes are the bulk of this.

one vgaarb patch that I found in mmtom but can't find in my inbox for some 
reason ah well better late than never.

radeon: fix the Kconfig msg to be more explicit, and some oops crashers
in the presence of bad bioses, along with a get rid of stupid white 
borders on fbcon patch.

The following changes since commit e28cab42f384745c8a947a9ccd51e4aae52f5d51:
  Linus Torvalds (1):
        Merge branch 'i2c-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Andy Getzendanner (1):
      vgaarb: fix incorrect dereference of userspace pointer.

Ben Skeggs (5):
      drm/nouveau: fix non-vram notifier blocks
      drm/nv40: make INIT_COMPUTE_MEM a NOP, just like nv50
      drm/nouveau: make dp auxch xfer len check for reads only
      drm/nv50: prevent multiple init tables being parsed at the same time
      drm/nv50: disregard dac outputs in nv50_sor_dpms()

Dave Airlie (7):
      drm/radeon/kms: change Kconfig text to reflect the new option.
      drm/radeon/kms: don't crash if no DDC bus on VGA/DVI connector.
      drm/radeon/kms: add quirk for VGA without DDC on rv730 XFX card.
      drm/radeon/kms: fix screen clearing before fbcon.
      Merge remote branch 'nouveau/for-airlied' of nouveau-2.6
      drm/radeon/kms: retry auxch on 0x20 timeout value.
      Merge branch 'drm-radeon-linus' of ../drm-next

Francisco Jerez (1):
      drm/nouveau: Fixup semaphores on pre-nv50 cards.

Jakob Bornecrantz (2):
      drm/vmwgfx: Report propper framebuffer_{max|min}_{width|height}
      drm/vmwgfx: Drop scanout flag compat and add execbuf ioctl parameter members. Bumps major.

Julia Lawall (1):
      drivers/gpu/drm/nouveau/nouveau_grctx.c: correct NULL test

Luca Barbieri (1):
      drm/nouveau: call ttm_bo_wait with the bo lock held to prevent hang

Maarten Maathuis (4):
      drm/nv50: align size of buffer object to the right boundaries.
      drm/nv50: avoid unloading pgraph context when ctxprog is running
      drm/nv50: delete ramfc object after disabling fifo, not before
      drm/nv50: make the pgraph irq handler loop like the pre-nv50 version

Marcin Ko¶cielnicki (4):
      drm/nouveau: Add module options to disable acceleration.
      drm/nouveau: Add getparam to get available PGRAPH units.
      drm/nouveau: Fix fbcon on mixed pre-NV50 + NV50 multicard.
      drm/nouveau: Add proper vgaarb support.

Marcin Slusarz (1):
      drm/nouveau: move dereferences after null checks

Matthew Garrett (1):
      nouveau: fix state detection with switchable graphics

Pauli Nieminen (1):
      drm/radeon: Skip dma copy test in benchmark if card doesn't have dma engine.

Rafa³ Mi³ecki (1):
      drm/radeon/kms: suspend and resume audio stuff

Thomas Hellstrom (2):
      drm/vmwgfx: Update the user-space interface.
      drm/vmwgfx: Fix a circular locking dependency bug.

 drivers/gpu/drm/nouveau/nouveau_acpi.c      |   12 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |   19 ++--
 drivers/gpu/drm/nouveau/nouveau_bios.h      |    2 +
 drivers/gpu/drm/nouveau/nouveau_bo.c        |   10 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c   |    7 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c |    7 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c        |   10 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c       |   10 ++-
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    2 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c     |   40 +++++++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.h     |    6 +
 drivers/gpu/drm/nouveau/nouveau_gem.c       |    2 +
 drivers/gpu/drm/nouveau/nouveau_grctx.c     |    4 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c       |  155 ++++++++++++++++-----------
 drivers/gpu/drm/nouveau/nouveau_notifier.c  |   13 ++-
 drivers/gpu/drm/nouveau/nouveau_object.c    |    3 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h       |    1 +
 drivers/gpu/drm/nouveau/nouveau_sgdma.c     |    7 +-
 drivers/gpu/drm/nouveau/nouveau_state.c     |   49 +++++++--
 drivers/gpu/drm/nouveau/nv04_fbcon.c        |    9 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c         |   11 ++-
 drivers/gpu/drm/nouveau/nv50_fbcon.c        |    9 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c         |    9 +-
 drivers/gpu/drm/nouveau/nv50_graph.c        |   10 ++-
 drivers/gpu/drm/nouveau/nv50_sor.c          |    1 +
 drivers/gpu/drm/radeon/Kconfig              |   12 ++-
 drivers/gpu/drm/radeon/atombios_dp.c        |   10 ++-
 drivers/gpu/drm/radeon/r600.c               |    8 ++
 drivers/gpu/drm/radeon/r600_audio.c         |    3 +-
 drivers/gpu/drm/radeon/radeon_atombios.c    |    9 ++
 drivers/gpu/drm/radeon/radeon_benchmark.c   |   55 ++++++----
 drivers/gpu/drm/radeon/radeon_connectors.c  |   20 ++--
 drivers/gpu/drm/radeon/radeon_display.c     |   11 ++-
 drivers/gpu/drm/radeon/radeon_fb.c          |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h         |   11 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c        |   17 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c       |    6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c         |   13 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c         |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c    |   16 +---
 drivers/gpu/vga/vgaarb.c                    |    2 +-
 include/drm/nouveau_drm.h                   |    1 +
 include/drm/vmwgfx_drm.h                    |   20 +++-
 43 files changed, 402 insertions(+), 230 deletions(-)
--29444707-810061732-1265862007=:516--
