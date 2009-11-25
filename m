Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbZKYWke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbZKYWke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759245AbZKYWkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:40:33 -0500
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:48675 "EHLO
	anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZKYWkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:40:33 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 17:40:32 EST
From: Eric Anholt <anholt@gaiman.anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [git pull] drm-intel fixes for 2.6.32rc6 (late)
Date: Wed, 25 Nov 2009 14:30:28 -0800
Message-ID: <87pr76s0e3.fsf@gaiman.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a6fc8d0f8c3ee3d42417e8315fc8c8fae1d3213:
  Linus Torvalds (1):
        Merge branch 'bugfix' of git://git.kernel.org/.../jeremy/xen

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

OK, this is the pull I've had mostly queued up since 2.6.32rc6.  You'll
appreciate the discipline in not rebasing, I guess?  I've actually just
been slack.

It's the Ironlake fixes edition.  Most importantly, you can get
through more than a few minutes of rendering before hanging the driver,
thanks to the IRQ fix.  Other than fixing up unreleased hardware,
there's a fix for a warning from people dumping out /sys, one for people
accidentally trying to build broken kernels, and one for people not
getting their VGA displays turned on with G33 and newer.  All of those
are nice and small.

(in other news, I've got a new mail configuration entirely under my
control, so hopefully no more absurd delays for reasons other than me
being slack.)

Chris Wilson (2):
      drm/i915: Avoid potential sleep whilst holding spinlock
      drm/i915: Select CONFIG_SHMEM

Zhenyu Wang (5):
      drm/i915: Fix and cleanup DPLL calculation for Ironlake
      drm/i915: HDMI hardware workaround for Ironlake
      drm/i915: Add more registers save/restore for Ironlake suspend
      agp/intel: new host bridge support
      drm/i915: Fix CRT hotplug detect by checking really no channels attached

Zou, Nanhai (1):
      drm/i915: Fix IRQ stall issue on Ironlake

 drivers/char/agp/intel-agp.c         |    8 ++++++-
 drivers/gpu/drm/Kconfig              |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c  |    4 +-
 drivers/gpu/drm/i915/i915_drv.h      |   12 +++++++++++
 drivers/gpu/drm/i915/i915_irq.c      |   10 ++++++++-
 drivers/gpu/drm/i915/i915_suspend.c  |   36 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_crt.c     |    4 +-
 drivers/gpu/drm/i915/intel_display.c |   15 +++++--------
 drivers/gpu/drm/i915/intel_hdmi.c    |   26 ++++++++++++++++++++---
 9 files changed, 96 insertions(+), 20 deletions(-)
