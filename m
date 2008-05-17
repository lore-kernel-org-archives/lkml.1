Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYEQCw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYEQCw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 22:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYEQCwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 22:52:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35009 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbYEQCwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 22:52:07 -0400
Date: Sat, 17 May 2008 03:52:01 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git][resend] drm tree - please pull
Message-ID: <alpine.DEB.0.82.0805170350530.20773@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

It reverts the vblank rework which appears to be causing some issues and 
fixes some other minor bugs.

Dave.

 drivers/char/drm/drm.h        |   17 --
 drivers/char/drm/drmP.h       |   91 ++-----
 drivers/char/drm/drm_fops.c   |    7 +-
 drivers/char/drm/drm_irq.c    |  381 ++++----------------------
 drivers/char/drm/drm_lock.c   |   35 +--
 drivers/char/drm/i915_dma.c   |  160 +++--------
 drivers/char/drm/i915_drm.h   |   45 +---
 drivers/char/drm/i915_drv.c   |   23 +-
 drivers/char/drm/i915_drv.h   |  115 ++-------
 drivers/char/drm/i915_irq.c   |  597 +++++++++++------------------------------
 drivers/char/drm/mga_drv.c    |    7 +-
 drivers/char/drm/mga_drv.h    |    6 +-
 drivers/char/drm/mga_irq.c    |   69 ++----
 drivers/char/drm/r128_drv.c   |    7 +-
 drivers/char/drm/r128_drv.h   |    9 +-
 drivers/char/drm/r128_irq.c   |   55 ++---
 drivers/char/drm/radeon_drv.c |    8 +-
 drivers/char/drm/radeon_drv.h |   19 +-
 drivers/char/drm/radeon_irq.c |  171 ++++++------
 drivers/char/drm/via_drv.c    |    6 +-
 drivers/char/drm/via_drv.h    |    7 +-
 drivers/char/drm/via_irq.c    |   81 +++----
 22 files changed, 513 insertions(+), 1403 deletions(-)

commit e948e99400b28af152414f15f8c8023ff2430b79
Author: Keith Packard <keithp@keithp.com>
Date:   Wed May 7 12:27:53 2008 +1000

    drm/i915: save and restore dsparb and d_state registers.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a59e122a67b88925944d3bbf33d15229cf0fc3de
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed May 7 12:25:46 2008 +1000

    drm/i915: fix off by one in VGA save/restore of AR & CR regs.
    
    turns out it's important to save/restore AR14 in particular.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f116cc561eae0a426b8fa6b3e22e80ba0bcf7aee
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Wed May 7 12:22:39 2008 +1000

    drm: disable tasklets not IRQs when taking the drm lock spinlock
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit af6061af0d9f84a4665f88186dc1ff9e4fb78330
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed May 7 12:15:39 2008 +1000

    Revert "drm/vbl rework: rework how the drm deals with vblank."
    
    This reverts commit ac741ab71bb39e6977694ac0cc26678d8673cda4.
    
    Okay this looks like wasn't as fully baked as I'd led myself to believe.
    
    Revert for now for further baking.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
