Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZGJWIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZGJWIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZGJWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:08:08 -0400
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:54720 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZGJWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:08:07 -0400
Subject: [git pull] drm/i915 fixes for 2.6.30-rc2
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1AIuu9UwCHyjEwLZe3J9"
Date: Fri, 10 Jul 2009 15:07:53 -0700
Message-Id: <1247263673.4678.10.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1AIuu9UwCHyjEwLZe3J9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The following changes since commit c2cc49a2f8a479dde96a599646d30b6cc9dbed78=
:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

Didn't send a request out for a while as there were some suspend/resume
regressions that I figured were ours but apparently came from elsewhere
in the tree.  Lots of KMS fixes in here, some of which fixed several
reported bugs at the same time.  Also fixes the reported tiling
regression we hope.

There's one featurey bit here, "enable error detection & state
collection."  There's more to this series coming, but I think it's
valuable enough to let it in.  The plan is that we end up with the GPU
catching interrupts, sending a uevent up to userland, and misc userland
magic seeing that, capturing the error state for debugging, and then
resetting the GPU.  No more losing your whole X session just because you
tried to play some game and the GPU segfaulted.  Add in the ability to
do kerneloops style reporting in the future, and we're pretty excited.

Andy Whitcroft (1):
      drm/i915: fix up a raw 64bit divide

Ben Gamari (3):
      drm/i915: Remove gtt_bound from drm_i915_gem_object
      drm/i915: Add gtt_offset to gem object list debugfs output
      drm/i915: Move lock to more reasonable location

Chris Wilson (1):
      drm/i915: Refactor calls to unmap_mapping_range

Eric Anholt (3):
      drm/i915: Disable GEM when a broken video BIOS takes up the whole ape=
rture.
      drm/i915: Fix harmless warning from patch merged after i2c rework.
      drm/i915: Zap the GTT mapping when transitioning from untiled to tile=
d.

Jesse Barnes (1):
      drm/i915: enable error detection & state collection

Keith Packard (2):
      drm/i915: Make driver less chatty
      drm/i915: Adjust DisplayPort clocks to use 96MHz reference

Shaohua Li (1):
      drm/i915: add FIFO watermark support

Zhao Yakui (4):
      drm/i915: Check the LID device to decide whether the LVDS should be i=
nitialized
      drm/i915: Restore the KMS modeset for every activated CRTC
      drm: Disable the unused connectors explicitly when resuming with KMS.
      drm/i915: Avoid saving/restore the modesetting registers twice in KMS=
 mode

Zhenyu Wang (2):
      drm/i915: Don't update display FIFO watermark on IGDNG
      drm/i915: Fix for LVDS VBT change on IGDNG

ling.ma@intel.com (4):
      drm/i915: Set SSC frequency for 8xx chips correctly
      drm/i915: enable sdvo lvds scaling function.
      drm/i915: crt fetch EDID by DVI-I converter on G4x platform
      drm/i915: Disable VGA output when doing DRM_MODE_DPMS_OFF.

 drivers/gpu/drm/drm_crtc_helper.c       |    2 +
 drivers/gpu/drm/i915/i915_dma.c         |   72 +++++-
 drivers/gpu/drm/i915/i915_drv.c         |    9 +-
 drivers/gpu/drm/i915/i915_drv.h         |   27 ++-
 drivers/gpu/drm/i915/i915_gem.c         |   36 ++-
 drivers/gpu/drm/i915/i915_gem_debugfs.c |   44 +++-
 drivers/gpu/drm/i915/i915_gem_tiling.c  |    6 +
 drivers/gpu/drm/i915/i915_irq.c         |  143 ++++++++++-
 drivers/gpu/drm/i915/i915_reg.h         |   60 ++++-
 drivers/gpu/drm/i915/i915_suspend.c     |  221 +++++++++-------
 drivers/gpu/drm/i915/intel_bios.c       |   20 +-
 drivers/gpu/drm/i915/intel_crt.c        |   30 ++-
 drivers/gpu/drm/i915/intel_display.c    |  448 +++++++++++++++++++++++++++=
++-
 drivers/gpu/drm/i915/intel_dp.c         |   11 +-
 drivers/gpu/drm/i915/intel_dp_i2c.c     |   11 +-
 drivers/gpu/drm/i915/intel_fb.c         |   18 +-
 drivers/gpu/drm/i915/intel_lvds.c       |   74 +++++-
 drivers/gpu/drm/i915/intel_sdvo.c       |  114 +++++++-
 drivers/gpu/drm/i915/intel_sdvo_regs.h  |    1 +
 19 files changed, 1159 insertions(+), 188 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-1AIuu9UwCHyjEwLZe3J9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpXu7UACgkQHUdvYGzw6veWKwCeIRo0vt6syTH1x2DuIz+ZP9HS
xbUAn044cpLY0Jhu97cfAorqBbPXtFXo
=R80g
-----END PGP SIGNATURE-----

--=-1AIuu9UwCHyjEwLZe3J9--

