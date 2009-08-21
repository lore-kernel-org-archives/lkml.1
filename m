Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbZHUA5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbZHUA5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZHUA5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:57:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54381 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZHUA5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:57:20 -0400
Date: Fri, 21 Aug 2009 01:57:23 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@list.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.0908210155390.18106@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

One bad use of sysfs devices could cause possible oops on all KMS,
along with a patch to report some more card specific info for certain 
rv530s, and a couple of radeon-kms specific patches.

Dave.

 drivers/gpu/drm/drm_sysfs.c           |   51 ++++++++++++++++++--------------
 drivers/gpu/drm/radeon/r100.c         |   10 ++++++
 drivers/gpu/drm/radeon/r300.c         |    4 ++-
 drivers/gpu/drm/radeon/r420.c         |   13 ++++++++-
 drivers/gpu/drm/radeon/r520.c         |    1 -
 drivers/gpu/drm/radeon/radeon.h       |    1 +
 drivers/gpu/drm/radeon/radeon_cp.c    |    9 ++++++
 drivers/gpu/drm/radeon/radeon_drv.h   |    5 ++-
 drivers/gpu/drm/radeon/radeon_gem.c   |    2 +-
 drivers/gpu/drm/radeon/radeon_kms.c   |    4 ++
 drivers/gpu/drm/radeon/radeon_reg.h   |    3 ++
 drivers/gpu/drm/radeon/radeon_state.c |    3 ++
 include/drm/radeon_drm.h              |    4 ++
 13 files changed, 83 insertions(+), 27 deletions(-)

commit ddd5a5b91e3f25d2e216225ea2216a72ca9477fc
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Aug 19 19:11:39 2009 -0400

    drm/radeon: add GET_PARAM/INFO support for Z pipes
    
    Needed for occlusion queries on rv530 chips.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 17782d99502851dc7e48114ee9c5a6d6741cba18
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Aug 21 10:07:54 2009 +1000

    drm/radeon/kms: add r100/r200 OQ support.
    
    This adds the relocation necessary for OQ support on the r100/r200
    chipsets.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 08e4d534743f4e9af3602aebbc1cca9372762028
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Thu Aug 20 19:02:31 2009 +1000

    drm: Fix sysfs device confusion.
    
    The drm sysfs class suspend / resume methods could not distinguish
    between different device types wich could lead to illegal type casts.
    
    Use struct device_type and make sure the class suspend / resume callbacks
    are aware of those. There is no per device-type suspend / resume. Only
    new-style PM.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e3b2415e281a97ade36d88404094a90cfea838c0
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Aug 21 09:47:45 2009 +1000

    drm/radeon/kms: implement the bo busy ioctl properly.
    
    The previous patch assumes the ioctl already existed, when
    it actually didn't.
    
    It also didn't return the correct error code.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
