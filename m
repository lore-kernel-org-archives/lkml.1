Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0BRFWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 00:22:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43550 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab0BRFWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 00:22:10 -0500
Date: Thu, 18 Feb 2010 05:21:50 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1002180517050.9593@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

one edid fix from X.org parser,
some more drm regression fixes, one 33 second pause at boot bug solved,
two nouveau issues, one vmwgfx staging fix to use proper mechanism to do
framebuffer handover,

For 2.6.34 we've lined up a command stream checker for r600, however
it already found two issues and we've backported the patches from Jerome 
to solve some r600 lockups we've been seeing a lot off in the field but 
funnily not on any of my or Jerome's systems.

Dave.


The following changes since commit e803e8b2628f3e9a42f45c5b7bb1f9821b08352c:
  Dave Airlie (1):
        drm/radeon/kms: make sure retry count increases.

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Adam Jackson (1):
      drm/edid: Fix interlaced detailed timings to be frame size, not field.

Ben Skeggs (1):
      drm/nouveau: use mutex for vbios lock

Dave Airlie (2):
      drm/radeon/kms: use udelay for short delays
      Merge branch 'for-airlied' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-linus

Francisco Jerez (1):
      drm/nouveau: Force TV encoder DPMS reinit after resume.

Jerome Glisse (2):
      drm/radeon/kms: fix indirect buffer management V2
      drm/radeon/kms: fix bo's fence association

Thomas Hellstrom (1):
      drm/vmwgfx: Use fb handover mechanism instead of stealth mode.

 drivers/gpu/drm/drm_edid.c             |   47 ++++++++++++++-
 drivers/gpu/drm/nouveau/nouveau_bios.c |    7 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h |    2 +-
 drivers/gpu/drm/nouveau/nv17_tv.c      |    2 +
 drivers/gpu/drm/radeon/atom.c          |    2 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c |    3 -
 drivers/gpu/drm/radeon/radeon.h        |    9 ++-
 drivers/gpu/drm/radeon/radeon_cs.c     |   10 +--
 drivers/gpu/drm/radeon/radeon_object.c |   36 +++++------
 drivers/gpu/drm/radeon/radeon_object.h |    4 +-
 drivers/gpu/drm/radeon/radeon_ring.c   |  105 ++++++++++++--------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    |   49 +++++----------
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c     |    3 +
 13 files changed, 137 insertions(+), 142 deletions(-)
