Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZIXQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZIXQkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZIXQkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:40:45 -0400
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:37051 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZIXQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:40:43 -0400
Subject: [git pull] drm-intel updates for 2.6.32.
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QNERZUS/o/WzFukLuFhM"
Date: Thu, 24 Sep 2009 09:40:59 -0700
Message-Id: <1253810459.7409.20.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QNERZUS/o/WzFukLuFhM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The following changes since commit cecc6b63a5de547a345c491bb4c18c01a15984a4=
:
  Alex Deucher (1):
        drm/radeon/r600: use fence->timeout directly

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

I expected airlied to include this with his pull-request, but I guess
I'll send it to you directly.  Overview:
      * GPU reset on hangs.  I've actually seen this work in practice.
      * shrinker.  Now when you're running out of memory, we can throw
        out userland's BO cache, or evict buffers to make things
        pageable.
      * Tracepoints.  This is useful for people trying to track down
        performance and other issues in the driver.
      * 8xx works again, since the regression with GEM's introduction
        back in .27
      * FBC support.  This is something like half a watt of savings when
        idle.
      * More Ironlake and KMS fixes.

Ben Gamari (7):
      drm/i915: Check whether chip is wedged in i915_wait_request()
      drm/i915: Refactor save/restore code
      drm/i915: make i915_seqno_passed non-static
      drm/i915: Add hangcheck timer
      drm/i915: Implement GPU reset on i965
      drm/i915: Hookup chip reset in error handler
      drm/i915: Make dev_priv->mm.wedged an atomic_t

Chris Wilson (20):
      drm/i915: Only destroy a constructed mmap offset
      drm/i915: Add buffer to inactive list immediately during fault
      drm/i915: Remove stored gtt_alignment
      drm/i915: Include buffer size and dirty state in debugfs lists
      drm/i915: Register a shrinker to free inactive lists under memory pre=
ssure
      drm/i915: Add ioctl to set 'purgeability' of objects
      drm/i915: Improve behaviour under memory pressure
      drm/i915: Check that the relocation points to within the target
      drm/i915: Skip the sanity checks if the current relocation is valid
      drm/i915: Add tracepoints
      drm/i915: Clean up evict from list.
      drm/i915: Search harder for a reusable object
      drm/i915: BUG_ON page refleak during unbind
      drm/i915: Whitespace correction for madv
      drm/i915: Do not mis-classify clean objects as purgeable
      drm/i915: Immediately discard any backing storage for uneeded objects
      drm/i915: Remove eviction debug spam
      drm/i915: Track purged state.
      drm/i915: Warn before mmaping a purgeable buffer.
      drm/i915: Handle ERESTARTSYS during page fault

Eric Anholt (2):
      drm/i915: Zap mmaps of objects before unbinding them from the GTT.
      agp/intel: Fix the pre-9xx chipset flush.

Fabian Henze (2):
      agp/intel: Add B43 chipset support
      drm/i915: add B43 chipset support

Jaswinder Singh Rajput (1):
      drm/i915: intel_display.c handle latency variable efficiently

Jesse Barnes (14):
      ACPI button: provide lid status functions
      drm/i915: force mode set at lid open time
      drm/i915: use ACPI LID status for LVDS ->detect hook
      drm/i915: generate a KMS uevent at lid open/close time
      drm/i915: framebuffer compression for pre-GM45
      drm/i915: fix typo in compressed buffer setup
      drm/i915: fix suspend/resume breakage in lid notifier
      drm/i915: fix startup hang on some non-mobile platforms
      drm/i915: prevent FIFO calculation overflows on 32 bits with high dot=
clocks
      ACPI: make ACPI button funcs no-ops if not built in
      drm/i915: blacklist Acer AspireOne lid status
      drm/i915: correct FBC update when pipe base update occurs
      drm/i915: split display functions by chip type
      drm/i915: framebuffer compression for GM45+

Li Peng (2):
      Add G33 series in VGA hotplug support category
      drm/i915: fix opregion backlight chip detect and range

Zhao Yakui (4):
      drm/i915: Add the enhancement property for SDVO-TV
      drm/i915: Add the brightness property for SDVO-LVDS
      drm/i915: Add the missing clone_mask for SDVO-VGA(RGB1)
      drm/i915: Write zero to DPLL_MD Reg for non-SDVO output

Zhenyu Wang (5):
      drm/i915: Fix typo for wrong LVDS clock setting on IGDNG
      drm/i915: Fix SSC frequence for IGDNG
      drm/i915: Remove DAC disable in CRT force detect on IGDNG
      drm/i915: Fix LVDS panel fitting on Arrandale
      drm/i915: remove restore in resume

 arch/x86/mm/pageattr.c                   |    1 +
 drivers/acpi/button.c                    |   45 ++-
 drivers/char/agp/intel-agp.c             |   37 +-
 drivers/gpu/drm/Kconfig                  |    1 +
 drivers/gpu/drm/drm_gem.c                |   13 +
 drivers/gpu/drm/i915/Makefile            |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c      |    6 +-
 drivers/gpu/drm/i915/i915_dma.c          |  194 +++++++-
 drivers/gpu/drm/i915/i915_drv.c          |  133 +++++-
 drivers/gpu/drm/i915/i915_drv.h          |   77 +++-
 drivers/gpu/drm/i915/i915_gem.c          |  876 ++++++++++++++++++++++----=
----
 drivers/gpu/drm/i915/i915_irq.c          |   92 +++-
 drivers/gpu/drm/i915/i915_opregion.c     |   22 +-
 drivers/gpu/drm/i915/i915_reg.h          |   34 ++
 drivers/gpu/drm/i915/i915_suspend.c      |  170 ++++---
 drivers/gpu/drm/i915/i915_trace.h        |  315 +++++++++++
 drivers/gpu/drm/i915/i915_trace_points.c |   11 +
 drivers/gpu/drm/i915/intel_bios.c        |    3 +
 drivers/gpu/drm/i915/intel_crt.c         |    9 +-
 drivers/gpu/drm/i915/intel_display.c     |  616 +++++++++++++++++----
 drivers/gpu/drm/i915/intel_drv.h         |    5 +-
 drivers/gpu/drm/i915/intel_lvds.c        |   63 ++-
 drivers/gpu/drm/i915/intel_sdvo.c        |  502 +++++++++++++++++-
 include/acpi/button.h                    |   25 +
 include/drm/drm_pciids.h                 |    1 +
 include/drm/i915_drm.h                   |   19 +
 26 files changed, 2811 insertions(+), 460 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_trace.h
 create mode 100644 drivers/gpu/drm/i915/i915_trace_points.c
 create mode 100644 include/acpi/button.h

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-QNERZUS/o/WzFukLuFhM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq7oRgACgkQHUdvYGzw6vdd/ACeI66bY6SygwAqbEtnKsYijBrp
h9YAmweMjfDN89fVQbF9jURwSngxCLiS
=PLhR
-----END PGP SIGNATURE-----

--=-QNERZUS/o/WzFukLuFhM--

