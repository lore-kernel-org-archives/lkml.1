Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbYLIFqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbYLIFqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 00:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYLIFqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 00:46:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38918 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYLIFqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 00:46:33 -0500
Date: Tue, 9 Dec 2008 05:46:30 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes for 2.6.28 final
Message-ID: <alpine.DEB.2.00.0812090545510.27607@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Radeon had an oops due to the vblank rework reported on-list,
and Intel have two fixes one to use MSI on the 965GM and one to avoid
corrupt rendering.

Dave.

 drivers/gpu/drm/i915/i915_dma.c     |    5 +++--
 drivers/gpu/drm/i915/i915_gem.c     |    2 ++
 drivers/gpu/drm/radeon/radeon_drv.h |    1 -
 drivers/gpu/drm/radeon/radeon_irq.c |    8 ++++----
 4 files changed, 9 insertions(+), 7 deletions(-)

commit b60678a75d44fa9d5969f79781bd856ad5858609
Author: Keith Packard <keithp@keithp.com>
Date:   Mon Dec 8 11:12:28 2008 -0800

    drm/i915: Disable the GM965 MSI errata workaround.
    
    Since applying the fix suggested by the errata (disabling MSI), we've had
    issues with interrupts being stuck on despite IIR being 0 on GM965 hardware.
    Most reporters of the issue have confirmed that turning MSI back on fixes
    things, and given the difficulties experienced in getting reliable MSI working
    on Linux, it's believable that the errata was about software issues and not
    actual hardware issues.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 15c35334c9b7a11f66ddf7fea9367884e1f5414f
Author: Owain Ainsworth <zerooa@googlemail.com>
Date:   Sat Dec 6 20:42:20 2008 -0800

    drm/i915: Don't return error in evict_everything when we get to the end.
    
    Returning -ENOMEM errored all the way out of execbuf, so the rendering never
    occurred.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fae7043c65d65f3e5b34bac4431c6ccc49190c41
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 9 15:30:50 2008 +1000

    drm/radeon: don't actually enable the IRQ regs until irq is enabled
    
    vblank can try and enable the IRQ registers before we've set the interrupt
    handler up.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
