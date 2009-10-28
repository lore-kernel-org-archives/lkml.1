Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbZJ1Bc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbZJ1Bc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbZJ1Bcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:32:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46543 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113AbZJ1Bcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:32:55 -0400
Date: Wed, 28 Oct 2009 01:32:57 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0910280130330.19088@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This is just 3 fast track fixes, one for the colormap issues with 1.7 and
2.9.0 intel driver (note final 1.7 + 2.9.1 is fine, and 1.6 is fine with 
any Intel). The other is a mode validation fix, and the last one at least
lets davem load the kms radeon driver.

I have some radeon KMS fixes queued but will leave them until tomorrow 
just in case.

Dave.

 drivers/gpu/drm/drm_edid.c             |   15 +++++++++++
 drivers/gpu/drm/drm_fb_helper.c        |   42 ++++++++++++++++++++++----------
 drivers/gpu/drm/radeon/radeon_device.c |    7 ++---
 3 files changed, 47 insertions(+), 17 deletions(-)

commit 77de0846aed9d7a1b0ea65090620900d66fb5cfb
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Oct 23 18:49:03 2009 +1000

    drm/kms: fix kms/fbdev colormap support properly.
    
    This sets the fbcon to use TRUECOLOR by default, it then
    only modifies the pseudo palette for fbcon, and only touches
    the real palette when in 8-bit pseudo color mode.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fcb45611448098a36b893bda71e72bd39730a3dd
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Oct 14 09:11:25 2009 +0800

    drm: Add the basic check for the detailed timing in EDID
    
    Sometimes we will get the incorrect display modeline when parsing the detailed
    timing in EDID. For example:
       >hsync/vsync width is zero
       >sync is beyond the blank.
    
    So add the basic check for the detailed timing in EDID to avoid the incorrect
    display modeline.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 93239ea158368016a017200cb133e1057fb3ef89
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Oct 28 11:09:58 2009 +1000

    drm/radeon/kms: ignore vga arbiter return.
    
    Since we register all radeon devices, and the arbiter only cares about
    VGA class ones, we will fail to startup on display controller class devices.
    We don't gain anything by using the return value here.
    
    this helps kms on sparc64 get started.
    
    Reported-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
