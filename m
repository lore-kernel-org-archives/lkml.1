Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZHICbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZHICbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 22:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZHICbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 22:31:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39012 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZHICbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 22:31:14 -0400
Date: Sun, 9 Aug 2009 03:31:12 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] more drm-fixes for rc6
Message-ID: <alpine.DEB.2.00.0908090330040.18904@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

One real bug fix, and two quite stupid errors that people think are bugs, 
because we report them.

Dave.

 drivers/gpu/drm/drm_irq.c       |    2 +-
 drivers/gpu/drm/drm_modes.c     |    2 ++
 drivers/gpu/drm/i915/i915_irq.c |    4 ++--
 3 files changed, 5 insertions(+), 3 deletions(-)

commit 6cb504c29b1338925c83e4430e42a51eaa43781e
Author: Frans Pop <elendil@planet.nl>
Date:   Sun Aug 9 12:25:29 2009 +1000

    drm/i915: silence vblank warnings
    
    these errors are pretty pointless
    
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8d3457ec3198a569dd14dc9e3ae8b6163bcaa0b5
Author: Paul Rolland <rol@as2917.net>
Date:   Sun Aug 9 12:24:01 2009 +1000

    drm: silence pointless vblank warning.
    
    Some applications/hardware combinations are triggering the message "failed to
    acquire vblank counter" to be issued up to 20 times a second, which makes it
    both useless and dangerous, as this may hide other important messages.
    This changes makes it only appear when people are debugging.
    
    Signed-off-by: Paul Rolland <rol@as2917.net>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Lost-twice-by: Dave Airlie <airlied@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 38d5487db7f289be1d56ac7df704ee49ed3213b9
Author: Keith Packard <keithp@keithp.com>
Date:   Mon Jul 20 14:49:17 2009 -0700

    drm: When adding probed modes, preserve duplicate mode types
    
    The code which takes probed modes and adds them to a connector eliminates
    duplicate modes by comparing them using drm_mode_equal. That function
    doesn't consider the type bits, which means that any modes which differ only
    in the type field will be lost.
    
    One of the bits in the mode->type field is the DRM_MODE_TYPE_PREFERRED bit.
    If the mode with that bit is lost, then higher level code will not know
    which mode to select, causing a random mode to be used instead.
    
    This patch simply merges the two mode type bits together; that seems
    reasonable to me, but perhaps only a subset of the bits should be used? None
    of these can be user defined as they all come from looking at just the
    hardware.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
