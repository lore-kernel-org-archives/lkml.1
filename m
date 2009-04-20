Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbZDTAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbZDTAL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZDTALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:11:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33578 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZDTALs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:11:48 -0400
Date: Mon, 20 Apr 2009 01:11:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm + 1xagp fixes
Message-ID: <alpine.DEB.2.00.0904200110181.16738@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This only contains some minor fixes to the drm, along with a single AGP 
fix to clear pages before allocating them, as they may end up in 
userspace.

Dave.

 drivers/char/agp/generic.c    |    4 ++--
 drivers/gpu/drm/drm_stub.c    |   11 ++++++++++-
 drivers/gpu/drm/drm_sysfs.c   |    1 +
 drivers/gpu/drm/via/via_dma.c |   12 +++++++-----
 4 files changed, 20 insertions(+), 8 deletions(-)

commit 59de2bebabc5027f93df999d59cc65df591c3e6e
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Mon Apr 20 10:08:35 2009 +1000

    agp: zero pages before sending to userspace
    
    AGP pages might be mapped into userspace finally, so the pages should be
    set to zero before userspace can use it. Otherwise there is potential
    information leakage.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 07f1c7a7f6736d9ec2eba57d209c5f48888d841e
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Apr 20 09:32:50 2009 +1000

    drm: check for minor master before allowing drop master.
    
    When fast user switching a lot eventually we get to the point,
    where we were checking for the wrong thing in this function.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6b0084266c1d4917ad9259759a1e7bd623cb3888
Author: Jonas Bonn <jonas@southpole.se>
Date:   Thu Apr 16 09:00:02 2009 +0200

    drm: set/clear is_master when master changed
    
    The variable is_master is being used to track the drm_file that is currently
    master, so its value needs to be updated accordingly when the master is
    changed.
    
    Signed-off-by: Jonas Bonn <jonas@southpole.se>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 77d26dc9b9805f322f5a1f6e559b18ad66205bd9
Author: Ma Ling <ling.ma@intel.com>
Date:   Thu Apr 16 17:51:25 2009 +0800

    drm: clean dirty memory after device release
    
    In current code we register/unregister connector object by
    drm_sysfs_connector_add/remove function.
    
    However under some cases, we need to dynamically register or unregister device
    multiple times, so we have to go through register -> unregister ->register
    routine.
    
    Because after device_unregister function our memory is dirty, we need to do
    clean operation in order to re-register the device, otherwise the system
    will crash.  The patch intends to clean device after device release.
    
    Signed-off-by: Ma Ling <ling.ma@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d9c6f546469f33f9aa48ae5991c33da8cd535b37
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Thu Apr 16 22:57:46 2009 +0200

    drm: count reaches -1
    
    With a postfix decrement in the test count will reach -1 rather than 0,
    subsequent tests fail.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
