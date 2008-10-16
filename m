Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYJPHAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYJPHAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYJPHAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:00:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51873 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbYJPHAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:00:00 -0400
Date: Thu, 16 Oct 2008 07:59:57 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp patches for 2.6.28-rc1.
Message-ID: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-next

This just contains some suspend/resume fixes for the SiS, Intel memory 
sizing fix for new hw, and support for more memory types on the nvidia 
AGP.

Dave.

 drivers/char/agp/amd-k7-agp.c |   38 ++++++++++++++++++++++++++++++++------
 drivers/char/agp/intel-agp.c  |   18 ++++++++++--------
 drivers/char/agp/nvidia-agp.c |   22 ++++++++++++++++++----
 3 files changed, 60 insertions(+), 18 deletions(-)

commit a64d2b37c2259e169759c1701ac565f0a11dc0ea
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Wed Sep 10 14:13:33 2008 +0200

    agp/nvidia: Support agp user-memory on nvidia agp.
    
    This adds user memory support required for TTM to the nvidia AGP driver.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2a32c3c894bcd3b3f8cc7e23f5ecbebca4a9f8e8
Author: Stuart Bennett <stuart@freedesktop.org>
Date:   Tue Aug 12 15:19:18 2008 +0100

    agp/amd-k7: Suspend support for AMD K7 GART driver
    
    Reinitialize bridge registers after suspend, but avoid repeating the ioremap
    
    Tested and works on AMD761
    
    Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 44d494417278e49f5b42bd3ded1801b6d2254db8
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Oct 14 17:18:45 2008 -0700

    agp/intel: Reduce extraneous PCI posting reads during init
    
    Instead of doing a posting read after each GTT entry update, do a single one
    at the end of the writes. This should reduce boot time a tiny amount by
    avoiding a lot of extra uncached reads.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 82e14a6215cbc9804ecc35281e973c6c8ce22fe7
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Oct 14 11:28:58 2008 -0700

    agp: Fix stolen memory counting on G4X.
    
    On the GM45, the amount of stolen memory mapped to the GTT was underestimated,
    even though we had 508KB more available since the GTT doesn't take from
    stolen memory. On the non-GM45 G4X, we overestimated how much stolen was
    mapped to the GTT by 4KB, resulting in GPU page faults when that page was
    accessed.
    
    This update requires a corresponding update to xf86-video-intel to work
    correctly.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
