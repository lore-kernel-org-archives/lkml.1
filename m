Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903Ab0AFT6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0AFT6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884Ab0AFT6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:58:51 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:47514 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab0AFT6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:58:51 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2010 14:58:50 EST
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] drm-intel fixes for 2.6.33rc3
CC: linux-kernel@vger.kernel.org
Date: Wed, 06 Jan 2010 10:17:15 -0800
Message-ID: <87zl4rxfmc.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
  Stephen Rothwell (1):
        mfd: compile fix for twl4030 renaming

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

The only scary part in here should be the new execbuf2 ioctl.  A little
background on that one: We've been passing around this patch and
hammering it out for much longer than its author date suggests.  I think
the first iteration was around july or so.  It'll let us fix a big
performance hit on pre-965 chipsets, particularly when windows or
textures get to 1024 pixels wide (but reducing in severity when they get
to around 1280 pixels wide).  We've now had multiple userland developers
spend quite a while trying to track down that strange performance valley
(at a suddenly popular again resolution).  I've been testing the
compatibility side of it, while Chris Wilson's been using the interface
a lot in his performance work.

Highlights for other people: Removing render reclock may fix hangs some
people have seen since we introduced the power stuff.  More Ironlake
love.  And a hibernate fix.

Andrew Lutomirski (1):
      drm/i915: Fix RC6 suspend/resume

Andrew Morton (1):
      drm/i915: fix unused var

Chris Wilson (2):
      drm/i915: Hold struct mutex whilst pinning power context bo.
      drm/i915: Permit pinning whilst the device is 'suspended'

Daniel Vetter (1):
      drm/i915: fix order of fence release wrt flushing

Eric Anholt (1):
      drm/i915: In the debugfs interface, unmap our address instead of the =
page's.

Jesse Barnes (3):
      drm/i915: only enable hotplug for detected outputs
      drm/i915: execbuf2 support
      drm/i915: remove render reclock support

Kristian H=C3=B8gsberg (3):
      drm/i915: Move PCI IDs into i915 driver
      drm/i915: Implement IS_* macros using static tables
      drm/i915: Track whether cursor needs physical address in intel_device=
_info

Matthew Garrett (1):
      drm/i915: Don't check for lid presence when detecting LVDS

Tobias Klauser (1):
      drm/i915: Storage class should be before const qualifier

Zhao Yakui (6):
      drm/i915: Add MALATA PC-81005 to ACPI LID quirk list
      drm/i915: Update LVDS connector status when receiving ACPI LID event
      drm/i915: Enable/disable the dithering for LVDS based on VBT setting
      drm/i915: Make the BPC in FDI rx/transcoder be consistent with that i=
n pipeconf on Ironlake
      drm/i915: Select the correct BPC for LVDS on Ironlake
      drm/i915: Add DP dpll limit on ironlake and use existing DPLL search =
function

Zhenyu Wang (3):
      drm/i915: implement new pm ops for i915
      drm/i915: Reload hangcheck timer too for Ironlake
      drm/i915: remove full registers dump debug

 drivers/gpu/drm/i915/i915_debugfs.c    |   31 +---
 drivers/gpu/drm/i915/i915_dma.c        |   26 +-
 drivers/gpu/drm/i915/i915_drv.c        |  174 +++++++++++++-
 drivers/gpu/drm/i915/i915_drv.h        |  123 +++++------
 drivers/gpu/drm/i915/i915_gem.c        |  249 +++++++++++++++-----
 drivers/gpu/drm/i915/i915_gem_tiling.c |   46 ++--
 drivers/gpu/drm/i915/i915_irq.c        |   32 ++-
 drivers/gpu/drm/i915/i915_reg.h        |   11 +-
 drivers/gpu/drm/i915/i915_suspend.c    |   12 -
 drivers/gpu/drm/i915/intel_crt.c       |    2 +
 drivers/gpu/drm/i915/intel_display.c   |  414 ++++++++++++++--------------=
----
 drivers/gpu/drm/i915/intel_dp.c        |    6 +
 drivers/gpu/drm/i915/intel_hdmi.c      |    5 +
 drivers/gpu/drm/i915/intel_lvds.c      |   83 ++-----
 drivers/gpu/drm/i915/intel_sdvo.c      |    3 +
 drivers/gpu/drm/i915/intel_tv.c        |    2 +
 include/drm/i915_drm.h                 |   54 ++++
 17 files changed, 736 insertions(+), 537 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktE06sACgkQHUdvYGzw6vdE4wCeNjDomu7/WJ+DXNShU74uxQWP
kYUAniwUbMSjr4d9cXK/o6P41RqWAR4E
=ScNp
-----END PGP SIGNATURE-----
--=-=-=--
