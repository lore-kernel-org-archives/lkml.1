Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbYBTA6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbYBTA6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761041AbYBTA5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:57:53 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38184 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYBTA5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:57:52 -0500
Date: Wed, 20 Feb 2008 00:57:49 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp patches for 2.6.25-rc3
Message-ID: <alpine.DEB.0.82.0802200055570.23529@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

This contains a patch from Arjan to avoid ioremap stupidities in agp, and 
adds a warning to catch any others. It also contains an update for the SiS 
chipset driver.

Dave.

 arch/x86/mm/ioremap.c         |    2 +
 drivers/char/agp/amd-k7-agp.c |    9 +++++++
 drivers/char/agp/ati-agp.c    |   16 ++-----------
 drivers/char/agp/generic.c    |    9 +++++++
 drivers/char/agp/sis-agp.c    |   47 +++++++++++++++++++++++++++++++++++++++-
 drivers/char/agp/sworks-agp.c |   18 ++++-----------
 6 files changed, 73 insertions(+), 28 deletions(-)

commit 44a207fc66c13c82f627178f9f858b8f3e76028f
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Feb 20 10:37:08 2008 +1000

    agp: fix missing casts that produced a warning.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2e374748c73f34e018a1c13a86a96a15fc55a65a
Author: Chaoyu Chen <chaoyu_chen@sis.com>
Date:   Wed Feb 20 10:18:46 2008 +1000

    agp: add support for 662/671 to agp driver
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fcea424d31868a78366ad5ee0cb3cc2a4cbe689b
Author: Arjan van dev Ven <arjan@linux.intel.com>
Date:   Wed Feb 6 05:16:00 2008 +0100

    fix historic ioremap() abuse in AGP
    
    Several AGP drivers right now use ioremap_nocache() on kernel ram in order
    to turn a page of regular memory uncached.
    
    There are two problems with this:
    
        1) This is a total nightmare for the ioremap() implementation to keep
           various mappings of the same page coherent.
    
        2) It's a total nightmare for the AGP code since it adds a ton of
           complexity in terms of keeping track of 2 different pointers to
           the same thing, in terms of error handling etc etc.
    
    This patch fixes this by making the AGP drivers use the new
    set_memory_XX APIs instead.
    
    Note: amd-k7-agp.c is built on Alpha too, and generic.c is built
    on ia64 as well, which do not yet have the set_memory_*() APIs,
    so for them some we have a few ugly #ifdefs - hopefully they'll
    be fixed soon.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 16469a0ea0f6b7562eac98ebb8a7c41ce902d0b1
Author: Stuart Bennett <sb476@cam.ac.uk>
Date:   Tue Jan 8 13:14:07 2008 +0000

    agp/sis: Suspend support for SiS AGP
    
    Tested on M650 chipset
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b7d0640f9229a9426ba9223796329c4f0cc4acb9
Author: Stuart Bennett <sb476@cam.ac.uk>
Date:   Tue Jan 8 13:13:28 2008 +0000

    agp/sis: Clear bit 2 from aperture size byte as well
    
    SiS M650 has aperture size byte 0x44
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
