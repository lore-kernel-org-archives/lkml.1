Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZC0X0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZC0X0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZC0X0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:26:33 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:33369 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZC0X0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:26:32 -0400
Subject: 
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.sf.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Jbs8OdKKXmc6ZkjqR3+F"
Date: Fri, 27 Mar 2009 16:26:28 -0700
Message-Id: <1238196389.625.430.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Jbs8OdKKXmc6ZkjqR3+F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit be0ea69674ed95e1e98cb3687a241badc756d228=
:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../penberg/slab-2=
.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

There's only one outside-of-i915 commit here (debugfs), and it's a
prereq for the i915 changes.  airlied said he'd pulled my version into
his tree, so we should be OK with it going in through my tree since he
hasn't send a pull request out.

Short summary: Fixing lock order reversals finally.  Piles of KMS fixes
as usual.  Support for an unreleased chipset.  And a bunch of
infrastructure for debugging info we're going to be adding in this
kernel so that just maybe we can get a better handle on these "I use my
machine for a few days and then the GPU falls over" bugs.

Ben Gamari (3):
      drm: Convert proc files to seq_file and introduce debugfs
      drm/i915: Convert i915 proc files to seq_file and move to debugfs.
      drm/i915: Consolidate gem object list dumping

Chris Wilson (2):
      drm/i915: Display fence register state in debugfs i915_gem_fence_regs=
 node.
      drm/i915: Check for dev->primary->master before dereference.

Eric Anholt (8):
      drm/i915: Change DCC tiling detection case to cover only mobile parts=
.
      drm/i915: Fix lock order reversal in GTT pwrite path.
      drm/i915: Make GEM object's page lists refcounted instead of get/free=
.
      drm/i915: Fix lock order reversal in shmem pwrite path.
      drm/i915: Fix lock order reversal in shmem pread path.
      drm/i915: Fix lock order reversal with cliprects and cmdbuf in non-DR=
I2 paths.
      drm/i915: Fix lock order reversal in GEM relocation entry copying.
      drm/i915: Add information on pinning and fencing to the i915 list deb=
ug.

Kristian H=C3=B8gsberg (1):
      drm/i915: Read the right SDVO register when detecting SVDO/HDMI.

Li Peng (1):
      drm/i915: Fix LVDS dither setting

Ma Ling (2):
      drm/i915: Use documented PLL timing limits for G4X platform
      drm/i915: Use a different PLL timing search function on G4X.

Owain G. Ainsworth (1):
      i915/drm: Remove two redundant agp_chipset_flushes

Shaohua Li (1):
      agp/intel: Add support for new intel chipset.

Zhao Yakui (2):
      drm/i915: Sync mode_valid/mode_set with intel video driver
      drm/i915: Sync crt hotplug detection with intel video driver

Zhenyu Wang (4):
      drm/i915: TV modes' parameters sync up with 2D driver
      drm/i915: Fix TV get_modes to return modes count
      drm/i915: TV mode_set sync up with 2D driver
      drm/i915: TV detection fix

 drivers/char/agp/intel-agp.c            |   21 +-
 drivers/gpu/drm/Makefile                |    3 +-
 drivers/gpu/drm/drm_debugfs.c           |  235 ++++++++
 drivers/gpu/drm/drm_drv.c               |   12 +-
 drivers/gpu/drm/drm_info.c              |  328 +++++++++++
 drivers/gpu/drm/drm_proc.c              |  721 ++++---------------------
 drivers/gpu/drm/drm_stub.c              |   15 +-
 drivers/gpu/drm/i915/Makefile           |    2 +-
 drivers/gpu/drm/i915/i915_dma.c         |  116 +++--
 drivers/gpu/drm/i915/i915_drv.c         |    6 +-
 drivers/gpu/drm/i915/i915_drv.h         |   21 +-
 drivers/gpu/drm/i915/i915_gem.c         |  898 +++++++++++++++++++++++++--=
----
 drivers/gpu/drm/i915/i915_gem_debugfs.c |  257 +++++++++
 drivers/gpu/drm/i915/i915_gem_proc.c    |  334 ------------
 drivers/gpu/drm/i915/i915_gem_tiling.c  |   31 +-
 drivers/gpu/drm/i915/i915_reg.h         |   22 +-
 drivers/gpu/drm/i915/intel_bios.h       |   12 +-
 drivers/gpu/drm/i915/intel_crt.c        |   66 ++-
 drivers/gpu/drm/i915/intel_display.c    |  406 +++++++++++++-
 drivers/gpu/drm/i915/intel_lvds.c       |    2 +-
 drivers/gpu/drm/i915/intel_tv.c         |  148 +++---
 include/drm/drmP.h                      |   77 +++-
 include/drm/drm_pciids.h                |    2 +
 23 files changed, 2431 insertions(+), 1304 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_debugfs.c
 create mode 100644 drivers/gpu/drm/drm_info.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_debugfs.c
 delete mode 100644 drivers/gpu/drm/i915/i915_gem_proc.c

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-Jbs8OdKKXmc6ZkjqR3+F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknNYKQACgkQHUdvYGzw6vcSZwCfb81SQhL8hhs2avWcHZPY+ecr
c+QAn09Bpbt7c/MKeUVbewPb3lBIS9Ip
=dc9v
-----END PGP SIGNATURE-----

--=-Jbs8OdKKXmc6ZkjqR3+F--

