Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYFTFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYFTFrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 01:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYFTFrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 01:47:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48612 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYFTFrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 01:47:14 -0400
Date: Fri, 20 Jun 2008 06:47:11 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm patches for 2.6.26-final
In-Reply-To: <alpine.DEB.0.82.0806200402030.12492@skynet.skynet.ie>
Message-ID: <alpine.DEB.0.82.0806200645470.12492@skynet.skynet.ie>
References: <alpine.DEB.0.82.0806200402030.12492@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Please pull the 'drm-patches' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches
> 
> Okay a bit larger than I like sending outside merge window, but Fedora has 
> been carrying most of this for a while. This add new chipset support for 
> Intel Gen4 chips, and also 3D support for AMD r500 chipsets along with 
> bugfixes and some code from AMD to fix some reverse engineered setups, 
> along with offically blessed microcode all the card variations from r100 
> to r500.

I forgot to cc lkml,

The oops fixed in the ioctl handler, fixed the oops but had a side effect 
on some driver ioctls. Looks like I have to audit the driver ioctls by 
hand.

So I've pushed the fix for that as well.
commit 858a3685bcf3ac199128e4aa85eaae2fb9d191b5
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jun 20 15:42:38 2008 +1000

    drm: only trust core drm ioctls - driver ioctls are a mess.
    
    So driver ioctls need a full auditing before we can make this change.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

> 
> There is also an oops fixer reported in the drm ioctl handler.
> 
> Dave.
> 
>  drivers/char/drm/ati_pcigart.c      |    8 +-
>  drivers/char/drm/drm.h              |    2 +-
>  drivers/char/drm/drm_drv.c          |    2 +
>  drivers/char/drm/drm_pciids.h       |   17 +-
>  drivers/char/drm/i915_drv.h         |   11 +-
>  drivers/char/drm/r300_cmdbuf.c      |  117 ++-
>  drivers/char/drm/r300_reg.h         |  242 ++++-
>  drivers/char/drm/radeon_cp.c        | 1148 +++++-----------------
>  drivers/char/drm/radeon_drm.h       |    8 +
>  drivers/char/drm/radeon_drv.h       |  251 ++++--
>  drivers/char/drm/radeon_irq.c       |    2 +-
>  drivers/char/drm/radeon_microcode.h | 1844 +++++++++++++++++++++++++++++++++++
>  drivers/char/drm/radeon_state.c     |   17 +-
>  13 files changed, 2602 insertions(+), 1067 deletions(-)
>  create mode 100644 drivers/char/drm/radeon_microcode.h
> 
> commit d3adbc0c582b767ba1561ffa38313e905cc917ea
> Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
> Date:   Fri Jun 20 12:12:56 2008 +1000
> 
>     drm/i915: add support for Intel series 4 chipsets.
>     
>     Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 21efa2bac91b8d12064617c5a35492ec982544eb
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Thu Jun 19 13:01:58 2008 +1000
> 
>     drm/radeon: add hier-z registers for r300 and r500 chipsets
> 
> commit 5e35eff13f7dd0f5c1d82b3b4708b2f7a5f44113
> Author: Alex Deucher <alex@botchco.com>
> Date:   Thu Jun 19 12:39:23 2008 +1000
> 
>     drm/radeon: use DSTCACHE_CTLSTAT rather than RB2D_DSTCACHE_CTLSTAT
>     
>     According to the hw guys, you should use DSTCACHE_CTLSTAT to flush
>     the 2D dst cache rather than RB2D_DSTCACHE_CTLSTAT.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 5cfb6956073a9e42d44a26790b7800980634d037
> Author: Alex Deucher <alex@botchco.com>
> Date:   Thu Jun 19 12:38:29 2008 +1000
> 
>     drm/radeon: switch IGP gart to use radeon_write_agp_base()
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 7ecabc53a29bb31689fa1852a926e021179a64a6
> Author: Dennis Kasprzyk <onestone@opencompositing.org>
> Date:   Thu Jun 19 12:36:55 2008 +1000
> 
>     drm/radeon: Restore sw interrupt on resume
>     
>     Fixes performance drop after suspend/resume on some systems.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 70b13d510fc9d137e362b7db3ac5b14b50d78477
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Thu Jun 19 11:40:44 2008 +1000
> 
>     drm/r500: add support for AGP based cards.
>     
>     AGP registers weren't programmed properly for r500 cards.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 9156cf09f56150ed89f77eaa4c386a07789776a0
> Author: Roland Scheidegger <sroland@tungstengraphics.com>
> Date:   Thu Jun 19 11:36:04 2008 +1000
> 
>     drm/radeon: fix texture uploads with large 3d textures (bug 13980)
>     
>     Texture uploads could hit the blitter coordinate limit, adjust the texture
>     offset when uploading the pieces. Make sure to check the end address of the
>     upload too.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit c0beb2a723d69934a53f51a9d664c5b1dbbf634b
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Wed May 28 13:52:28 2008 +1000
> 
>     drm/radeon: add initial r500 support.
>     
>     This contains all the command buffer processing for the r500 cards.
>     It doesn't yet contain vblank support.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 5b92c4045eaa42441b7ec249a406e4110ea400d4
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed May 28 11:57:40 2008 +1000
> 
>     drm/radeon: init pipe setup in kernel code.
>     
>     This inits the card pipes in the kernel and lets userspace getparam
>     the correct setup.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit d396db321bcaec54345e7e9e87cea8482d6ae3a8
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed May 28 11:54:06 2008 +1000
> 
>     drm/radeon: fixup radeon_do_engine_reset
>     
>     Cleanup do engine reset for different chip families.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 259434acccbc823ee8bc00b2d2689ccccd25e1fd
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed May 28 11:51:12 2008 +1000
> 
>     drm/radeon: fix pixcache and purge/cache flushing registers
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit d7463eb41d88a39de2653fd41857c4ccddb8707b
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed May 28 11:46:36 2008 +1000
> 
>     drm/radeon: write AGP_BASE_2 on chips that support it.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 45e519052e8f583a709edd442a23f59581d3fe42
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed May 28 13:28:59 2008 +1000
> 
>     drm/radeon: merge IGP chip setup and fixup RS400 vs RS480 support
>     
>     We only support RS480 (AMD based IGP) at the moment not
>     RS400 (Intel based IGP) ones.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 2735977b12cb0f113aae24afff04747b6d0f5bf1
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed May 28 12:54:16 2008 +1000
> 
>     drm/radeon: IGP clean up register and magic numbers.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 3722bfc607d46275369865c02fe8694486d640b5
> Author: Dave Airlie <airlied@linux.ie>
> Date:   Wed May 28 11:28:27 2008 +1000
> 
>     drm/rs690: set base 2 to 0.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit fa0d71b967506031f7cb08ced6095d1c4f988594
> Author: Dave Airlie <airlied@linux.ie>
> Date:   Wed May 28 11:27:01 2008 +1000
> 
>     drm/rs690: set all of gart base address.
>     
>     Docs state bits 4-11 maps to bits 32-39 of the 40-bit range
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 9f18409ea3d778a171a9505c0a849d846f352bd0
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed May 28 11:21:25 2008 +1000
> 
>     radeon: add production microcode from AMD
>     
>     This adds production microcode for r100->r500 from AMD.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 7ec700fcaf4f01ae72956df74a9e0d08938fd26e
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Thu Jun 19 11:27:23 2008 +1000
> 
>     drm: pcigart use proper pci map interfaces.
>     
>     Switch to using more correct pci dma mapping interfaces.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit b554305905d9bc2184b424aa67712119d5c9fb99
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Fri Jun 13 15:06:31 2008 +1000
> 
>     drm: the sg alloc ioctl should write back the handle to userspace
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 41ee2ff404ec76194315aeed57ac973b010abe1d
> Author: Johannes Weiner <hannes@saeurebad.de>
> Date:   Fri Jun 13 15:04:40 2008 +1000
> 
>     drm: use drms ioctl cmd not what we get passed from userspace.
>     
>     This enforces us to use the drm ioctl types so read/write works correctly and not believe
>     what userspace tells us.
>     
>     It does this hopefully without breaking the drm api.
>     
>     Fixes bug from thread: BUG: unable to handle kernel NULL pointer dereference (drm_getunique)
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://sourceforge.net/services/buy/index.php
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 
