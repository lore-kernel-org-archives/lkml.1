Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0BWGDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:03:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35132 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab0BWGDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:03:05 -0500
Date: Tue, 23 Feb 2010 06:02:49 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm staging driver fixes.
Message-ID: <alpine.DEB.2.00.1002230600460.29129@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just nouveau/vmwgfx changes, the nouveau ones fix nouveau to work
on a range of IGP chipsets, mostly seen as ION or in Apple laptops,
Without these changes there is a chance of memory corruption on the low 
pages since the GPU tables are setup different to every other nvidia in
history.

Dave.

The following changes since commit 635f1a31292087a2e99568bf4451c10ee287adaa:
  Dave Airlie (1):
        drm/radeon: bump the UMS driver version number to indicate rv740 fix

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Ben Skeggs (5):
      drm/nv50: make nv50_mem_vm_{bind,unbind} operate only on vram
      drm/nv50: more efficient clearing of gpu page table entries
      drm/nv50: improve vram page table construction
      drm/nv50: fix instmem binding on IGPs to point at stolen system memory
      drm/nv50: fix vram ptes on IGPs to point at stolen system memory

Dave Airlie (1):
      Merge remote branch 'nouveau/for-airlied' of ../drm-nouveau-next into drm-linus

Francisco Jerez (1):
      drm/nouveau: Fix up pre-nv17 analog load detection.

Thomas Hellstrom (1):
      drm/vmwgfx: Fix queries if no dma buffer thrashing is occuring.

 drivers/gpu/drm/nouveau/nouveau_drv.h   |    1 +
 drivers/gpu/drm/nouveau/nouveau_mem.c   |  113 ++++++++++++++++++++-----------
 drivers/gpu/drm/nouveau/nv04_dac.c      |    6 ++-
 drivers/gpu/drm/nouveau/nv50_instmem.c  |   58 +++++++++++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |  108 +++++++++++++++++++++++++-----
 5 files changed, 210 insertions(+), 76 deletions(-)
