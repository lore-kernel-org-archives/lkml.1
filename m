Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0BSVqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:46:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52844 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0BSVqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:46:07 -0500
Date: Fri, 19 Feb 2010 21:45:50 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm regression final fixes
Message-ID: <alpine.DEB.2.00.1002192143130.22461@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

hope you get this before release, if not stable life, the main fix is a 
major regression on AGP/no-pat systems where pages ended up in uncached,

a further fix to the vgaarb fix, and a fix to make rv740 gpus just work 
for now (they have some tile/backend quirk that AMD haven't tracked down 
yet, so we'll do the proper fix in .34, this is a minimal workaround for 
now).

Dave.

The following changes since commit 6b15835282f9c6a023e2625455bfdb822bb9cc64:
  Dave Airlie (1):
        Merge branch 'for-airlied' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-linus

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Alex Deucher (3):
      drm/radeon/kms/rs600: add connector quirk
      drm/radeon/kms: fix shared ddc detection
      drm/radeon/rv740: fix backend setup

Francisco Jerez (1):
      drm/ttm: fix caching problem on non-PAT systems.

Jerome Glisse (1):
      drm/radeon/kms: free fence IB if it wasn't emited at IB free time

Kyle McMartin (1):
      vgaarb: fix "target=default" passing

 drivers/gpu/drm/radeon/r600_cp.c           |    9 ++++++---
 drivers/gpu/drm/radeon/radeon_atombios.c   |    9 +++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c |    5 ++---
 drivers/gpu/drm/radeon/radeon_ring.c       |    2 ++
 drivers/gpu/drm/radeon/rv770.c             |    9 ++++++---
 drivers/gpu/drm/ttm/ttm_tt.c               |   18 +++++++++++-------
 drivers/gpu/vga/vgaarb.c                   |    2 +-
 7 files changed, 37 insertions(+), 17 deletions(-)
