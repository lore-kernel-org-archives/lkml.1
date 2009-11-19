Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbZKSBKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbZKSBKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 20:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbZKSBKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 20:10:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34103 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbZKSBK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 20:10:29 -0500
Date: Thu, 19 Nov 2009 01:10:31 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull][optional] drm
Message-ID: <alpine.DEB.2.00.0911190105060.20033@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1726905824-1258593031=:20033"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1726905824-1258593031=:20033
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Just let me know if you don't pull this and I can pick out the bits that 
definitely need to go in (probably just the first two non-radeon-kms 
fixes, and the s/r ones)

Non-radeon-kms changes:
EDID parser fix that we had in X but not in kernel
Xen page protections fix.
Fix for a race in the drm_mm (only affects radeon KMS so far)

radeon-kms changes:
suspend-resume fixes from F-12 for AGP and certain Thinkpads
tv load detect disable for troublesome chips
some connectior table quirks
support for external TMDS (otherwise black screen on boot)
support for dual-head RN50 server cards (otherwise black screen on boot)
VGA bad EDID fix

Dave.

 drivers/gpu/drm/drm_edid.c                      |    6 +
 drivers/gpu/drm/drm_gem.c                       |    2 +-
 drivers/gpu/drm/drm_mm.c                        |    9 +
 drivers/gpu/drm/radeon/atom.c                   |    1 +
 drivers/gpu/drm/radeon/atombios_crtc.c          |    7 +-
 drivers/gpu/drm/radeon/r100.c                   |   13 +-
 drivers/gpu/drm/radeon/r300.c                   |    6 +
 drivers/gpu/drm/radeon/r420.c                   |    3 +
 drivers/gpu/drm/radeon/radeon.h                 |    2 +
 drivers/gpu/drm/radeon/radeon_agp.c             |   12 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |   25 +-
 drivers/gpu/drm/radeon/radeon_combios.c         |  390 ++++++++++++++++++++---
 drivers/gpu/drm/radeon/radeon_connectors.c      |   69 ++++-
 drivers/gpu/drm/radeon/radeon_device.c          |    2 +
 drivers/gpu/drm/radeon/radeon_display.c         |   29 ++-
 drivers/gpu/drm/radeon/radeon_encoders.c        |   85 ++++--
 drivers/gpu/drm/radeon/radeon_fb.c              |    9 +-
 drivers/gpu/drm/radeon/radeon_gem.c             |   10 +-
 drivers/gpu/drm/radeon/radeon_i2c.c             |  109 +++++--
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |    5 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  113 ++++----
 drivers/gpu/drm/radeon/radeon_mode.h            |   75 ++++-
 drivers/gpu/drm/radeon/radeon_reg.h             |   40 ++-
 drivers/gpu/drm/radeon/rs400.c                  |    1 +
 drivers/gpu/drm/radeon/rv515.c                  |    9 +-
 25 files changed, 790 insertions(+), 242 deletions(-)

commit 44c83571e8e164840e91f3cc9fdd928889ac169b
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Wed Aug 5 00:19:51 2009 +0200

    drm/radeon: Give userspace more accurate information about available memory.
    
    This patch varies from the original and just removes memory for kernel
    pinned objects.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bc5096a4771453929537605e564b32c534c869bf
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Nov 18 13:39:34 2009 +1000

    drm/radeon/kms: pick 8bpp console when 32MB or less VRAM
    
    making the pinned console smaller gives X a bit more room to play with.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d8c8292199eaccc4163229d6e8409e139adc45dc
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Oct 13 14:10:37 2009 +1000

    drm/radeon/kms: add support for encoder cloning.
    
    The RN50 really needs this since its a single crtc card,
    however other gpus may benefit from it as well.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 85691e025889ceaa9a6f6cf5dbf706d7b0acfd05
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Nov 17 14:08:55 2009 -0800

    drm/radeon/kms: fix oops when set_base is call with no FB
    
    Just do nothing if crct_set_base() is called with no FB.
    
    The oops happens when the user switches between X & vt or in some case
    when changing mode.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c7e3bff327d8f5291046ff7ff0f4568dee1f0292
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Tue Nov 17 14:08:54 2009 -0800

    drm: make sure page protections are updated after changing vm_flags
    
    Some architectures compute ->vm_page_prot depending on ->vm_flags, so we
    need to update the protections after adjusting the flags.
    
    AFAIK this only affects running X under Xen; without this patch you get
    lots of coloured blobs on the screen, or maybe a complete lockup.  Or
    anything really.
    
    But that still depends on lots of out-of-tree stuff, so I don't think
    there are any consequences for anyone else.  But it is wrong in principle.
    
    Reported-by: Jan Beulich <JBeulich@novell.com>
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 173f90fad0e5e86d978eb26c54aac424152ab386
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Nov 12 14:13:53 2009 +0100

    drm/radeon/kms: Report vga connector is connected according to ddc_probe
    
    On broken EDID we were reporting vga connector to be disconnected
    even if ddc probe did found a monitor. This patch report that the
    connector is connected on such case. This allow drm to add a fail
    safe mode (800x600 at the time of this patch) thus user can boot
    and later add a mode which match its monitor capabilities.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6bd98847e937a8cff40117d58ceb569972ebbe59
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Nov 13 20:56:58 2009 +0100

    drm: mm always protect change to unused_nodes with unused_lock spinlock
    
    unused_nodes modification needs to be protected by unused_lock spinlock.
    Here is an example of an usage where there is no such protection without
    this patch.
    
      Process 1: 1-drm_mm_pre_get(this function modify unused_nodes list)
                 2-spin_lock(spinlock protecting mm struct)
                 3-drm_mm_put_block(this function might modify unused_nodes
                   list but doesn't protect modification with unused_lock)
                 4-spin_unlock(spinlock protecting mm struct)
      Process2:  1-drm_mm_pre_get(this function modify unused_nodes list)
    At this point Process1 & Process2 might both be doing modification to
    unused_nodes list. This patch add unused_lock protection into
    drm_mm_put_block to avoid such issue.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bc157e049472dcf1ada607243b5eff8f1dceab86
Author: Alex Deucher <alex@hp.localdomain>
Date:   Mon Nov 16 18:33:51 2009 -0500

    drm/radeon/kms: add quirk for MSI S270
    
    doesn't have a tv-out port
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d767b62cc37cbaa7f52812bea8731929807d1eb3
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 17 15:44:01 2009 -0500

    drm/radeon/kms: deal with connectors sourced to the same encoder
    
    Some systems have multiple connectors connected to the same encoder;
    e.g., DVI and HDMI connected to the same encoder with the same ddc
    line. Since we expose connectors as xrandr outputs, randr treats them
    separately which results in it trying to source the same encoder to
    different crtcs. If we have an HDMI and DVI-D port on the same encoder,
    pick the one to be considered connected based on the edid (HDMI if edid
    indicates HDMI, DVI otherwise).
    
    Should fix fdo bug 25150
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a8269ba0032372b1c069f9316cad7f47f7d23bf3
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 17 17:12:10 2009 -0500

    drm/radeon/kms: add quirk for Acer laptop
    
    DVI-I port is actually DVI-D
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 984d1f3cd3308d176d6d14588836a87c94b340da
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Nov 13 20:56:35 2009 +0100

    drm/radeon/kms: Disable TV load detect on RS400,RC410,RS480
    
    RS400,RC410,RS480 chipset seems to report a lot of false positive
    with load detect on TV output. We haven't yet found a way to make
    load detect reliable on those chipset, thus just disable it for TV
    output. Would avoid user to experience phantom screen because X
    believe there is a monitor connected to the TV output.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3c55c4aa03f7469b5ec8601eab5aa98124cf1ec4
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 12 14:55:14 2009 -0500

    drm/radeon/kms: rework scaler handling
    
    Keep requested scaler type in radeon_encoder
    and the actual scaler type used in radeon_crtc.
    This prevents us from enabling the scaler when it's
    not required (i.e., the requested mode is the native
    mode).  Also, always set the adjusted mode equal
    to the native mode for lvds.
    
    Should fix:
    https://bugzilla.redhat.com/show_bug.cgi?id=522271
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Acked-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5a9dbb7e627064ebd810630edada7ac2ade1c3b5
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 12 14:01:36 2009 -0500

    drm/radeon/kms: fix typo in legacy internal tmds mode fixup
    
    Call to set active device was missing.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fba0a16eb5c55ae3bb9cf1306a84b83451389612
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Nov 12 15:53:44 2009 +1000

    drm/radeon/kms: read back register before writing in IIO.
    
    This fixes RH bugzilla #527874.
    
    On resume the atom posting wasn't working, however vbe posting was
    going fine, after 2 weeks over irc, and 8 hrs with the hardware,
    I tracked it down to the memory device table and it access the MC
    registers via IIO, it appears the rv515 atom iio table might not
    be fully functional, so adding a readback before doing a write
    either provides enough delay to make things resume correctly.
    
    Thanks to Peng Huang at Red Hat for coming to Brisbane.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8ccb5075a99434f88b4445723970f1402e13c26c
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Nov 12 09:37:39 2009 +1000

    drm/radeon/kms: fix handling of d1/d2 vga
    
    An rv515 laptop I got wouldn't startup with a montior plugged in,
    found the proper bug hopefully with us not turning off D2VGA
    here when we should.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f56939739f01659f4e489eb8f9cf7c26e5c71d80
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Nov 5 10:12:54 2009 -0800

    drm: work around EDIDs with bad htotal/vtotal values
    
    We did this on the userspace side, but we need a similar fix for the
    kernel.
    
    Fixes LP #460664.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8dbfab707488893e17e4f5911c225ee4e6497348
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 5 15:39:10 2009 +1000

    drm/radeon/kms: resume AGP by calling init.
    
    AGP resume was broken since we moved to the new init path,
    because we never re-enabled AGP on these systems at resume time.
    
    This patch just calls the AGP resume call which just does the reinit
    at resume time like the old path did.
    
    Since AGP is pretty much gpu independant I did it outside
    the gpu specific code.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d0140258ef0afa76c4ec1b4fb75ede6b9b836e5e
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 5 15:36:53 2009 +1000

    drm/radeon/kms: AGP systems need PCI bus mastering enabled
    
    We might not hit this yet, but when if we do any sort of writeback
    we really need to enable PCI bus mastering on these systems from
    what I can see.
    
    This enables PCI BM on all radeons that require it.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 27d920edca6b49a269aa3d3e2b059e8500285aef
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 10 21:25:07 2009 -0500

    drm/radeon/kms: add support for external tmds on legacy boards
    
    This enables initialization of external tmds chips on pre-atom
    and mac systems.  Macs are untested.  Also, some macs have single
    link tmds chips while others have dual link tmds chips.  We need
    to figure out which ones have which.
    
    This gets external TMDS working on my RS485 and RV380.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cc51b7e7f3c1f3244e6261cef1f08a2e19bfdced
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 10 15:59:44 2009 -0500

    drm/radeon/kms: clean up i2c
    
    - Change reg/mask names to match what we use internally
    and in the bios
    - Clarify how i2c over gpio on radeon actually works
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b4b4b6aa09fced89b29178d16d6e28868cb0ed1c
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 5 18:27:30 2009 -0500

    drm/radeon/kms: dont't pass a radeon_connector to radeon_i2c_do_lock()
    
    We need this for supporting things other than ddc on i2c.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-1726905824-1258593031=:20033--
