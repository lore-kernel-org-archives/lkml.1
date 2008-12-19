Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYLSFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYLSFuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYLSFuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:50:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55602 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYLSFuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:50:10 -0500
Date: Fri, 19 Dec 2008 05:50:08 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes tree for 2.6.28 final
Message-ID: <alpine.DEB.2.00.0812190548340.16959@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

One GEM fix + a patch to disable it on PAE for now, we need to do some 
invasive work to AGP + set_memory_array to make it work properly.

Dave.

 drivers/gpu/drm/i915/i915_dma.c |   10 +++++++++-
 drivers/gpu/drm/i915/i915_drv.h |    2 ++
 drivers/gpu/drm/i915/i915_gem.c |    9 ++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

commit ac5c4e76180a74c7f922f6fa71ace0cef45fa433
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 19 15:38:34 2008 +1000

    drm/i915: GEM on PAE has problems - disable it for now.
    
    On PAE systems, GEM allocates pages using shmem, and passes these
    pages to be bound into AGP, however the AGP interfaces + the x86
    set_memory interfaces all take unsigned long not dma_addr_t.
    
    The initial fix for this was a mess, so we need to do this correctly
    for 2.6.29.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c4de0a5d671e3af38dc3496538e391782aecc3a5
Author: Eric Anholt <eric@anholt.net>
Date:   Sun Dec 14 19:05:04 2008 -0800

    drm/i915: Don't return busy for buffers left on the flushing list.
    
    These buffers don't have active rendering still occurring to them, they just
    need either a flush to be emitted or a retire_requests to occur so that we
    notice they're done.  Return unbusy so that one of the two occurs.  The two
    expected consumers of this interface (OpenGL and libdrm_intel BO cache) both
    want this behavior.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Acked-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
