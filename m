Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZKJXOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZKJXOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758634AbZKJXOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:14:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54966 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630AbZKJXOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:14:32 -0500
Date: Tue, 10 Nov 2009 23:14:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm radeon kms.
Message-ID: <alpine.DEB.2.00.0911102313310.29664@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-989508576-1257894875=:29664"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-989508576-1257894875=:29664
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

So this branch is the branch I've been working and testing on, however
I sent you a pull previously with 3 patches cherry picked out of this as
they were more urgent. It merges cleanly but the diffstat comes out different.

If you want let me know and I can pull this tree into yours and send that,
but since this is what I've been actually running I went with this.

Or if you don't want to pull this tree at this point let me know, there
is one fix in here that stabilise r600 kms a lot, which I can send separate
if required.

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This is nearly all radeon KMS updates and bugfixes, it brings the code
into line with what is shipping in the F12 release.

There are a couple of minor core kms bug fixes, but they are obvious one
liners.

Dave.

 drivers/gpu/drm/drm_crtc_helper.c               |    1 +
 drivers/gpu/drm/drm_edid.c                      |   15 +
 drivers/gpu/drm/drm_fb_helper.c                 |   44 ++-
 drivers/gpu/drm/radeon/Makefile                 |    2 +-
 drivers/gpu/drm/radeon/atombios.h               |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c          |  357 ++++++++++++-----------
 drivers/gpu/drm/radeon/r100.c                   |   42 ++-
 drivers/gpu/drm/radeon/r300.c                   |    2 +-
 drivers/gpu/drm/radeon/r420.c                   |    2 +
 drivers/gpu/drm/radeon/r500_reg.h               |    9 +
 drivers/gpu/drm/radeon/r520.c                   |    2 +
 drivers/gpu/drm/radeon/r600.c                   |  108 ++++----
 drivers/gpu/drm/radeon/r600_blit.c              |   58 +++--
 drivers/gpu/drm/radeon/r600_blit_kms.c          |    5 +-
 drivers/gpu/drm/radeon/r600_cs.c                |   18 ++
 drivers/gpu/drm/radeon/r600d.h                  |   14 +
 drivers/gpu/drm/radeon/radeon.h                 |   11 +
 drivers/gpu/drm/radeon/radeon_asic.h            |   23 ++
 drivers/gpu/drm/radeon/radeon_atombios.c        |  282 ++++++++++++++----
 drivers/gpu/drm/radeon/radeon_benchmark.c       |    4 +-
 drivers/gpu/drm/radeon/radeon_bios.c            |    3 -
 drivers/gpu/drm/radeon/radeon_clocks.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_combios.c         |  287 +++++++++++++------
 drivers/gpu/drm/radeon/radeon_connectors.c      |  199 ++++++++++---
 drivers/gpu/drm/radeon/radeon_cursor.c          |   10 +-
 drivers/gpu/drm/radeon/radeon_device.c          |   29 +-
 drivers/gpu/drm/radeon/radeon_display.c         |   28 +--
 drivers/gpu/drm/radeon/radeon_encoders.c        |  125 ++++-----
 drivers/gpu/drm/radeon/radeon_gart.c            |   20 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |    9 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |   40 ++--
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   27 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |   34 ++-
 drivers/gpu/drm/radeon/radeon_pm.c              |   65 ++++
 drivers/gpu/drm/radeon/radeon_reg.h             |    6 +
 drivers/gpu/drm/radeon/radeon_test.c            |    6 +-
 drivers/gpu/drm/radeon/radeon_ttm.c             |    6 +
 drivers/gpu/drm/radeon/rs400.c                  |    2 +
 drivers/gpu/drm/radeon/rs600.c                  |   20 ++-
 drivers/gpu/drm/radeon/rs690.c                  |    2 +
 drivers/gpu/drm/radeon/rv515.c                  |    4 +
 drivers/gpu/drm/radeon/rv770.c                  |   59 +++-
 drivers/gpu/drm/radeon/rv770d.h                 |    5 +
 drivers/gpu/drm/ttm/ttm_tt.c                    |    1 +
 44 files changed, 1338 insertions(+), 652 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/radeon_pm.c

commit eeba57518c01cf462d87bbfc59049139da47adcb
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sat Nov 7 16:27:32 2009 +0100

    drm/kms: Init the CRTC info fields for modes forced from the command line.
    
    Fixes fdo bug 24710.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a39533b4ddad388b64a20bcabd17ac125fd4ba65
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Nov 9 16:41:21 2009 -0500

    drm/radeon/r600: CS parser updates
    
    Add some additional regs that require relocs.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7433874e31f7f2e6e942b12012790565731d0f4a
Author: Rafa³ Mi³ecki <zajec5@gmail.com>
Date:   Tue Nov 3 00:53:02 2009 +0100

    drm/radeon/kms: add debugfs for power management for AtomBIOS devices
    
    Signed-off-by: Rafa³ Mi³ecki <zajec5@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a3fa6320ce964f799388b152a1b0f6e2c3b32a7f
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 5 11:57:07 2009 -0500

    drm/radeon/kms: initial mode validation support
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f95a9f0b05d22cffc46fbd2d065b260f8405e43f
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 5 02:21:06 2009 -0500

    drm/radeon/kms/atom/dce3: call transmitter init on mode set
    
    Generally this is done at post, but might not always be done
    with softboot or for connectors on docking stations.
    
    Could probably be done once when the driver loads/resumes
    rather than on each mode set.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b75fad0682caacb16012582deecbd7d19bc2f68e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 5 13:16:01 2009 -0500

    drm/radeon/kms: store detailed connector info
    
    This will be useful for mode validation and certain
    atom tables.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4170a6c1bc106d7fcf94f5842224ac4dac61006b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 5 01:16:23 2009 -0500

    drm/radeon/kms/atom/dce3: fix up usPixelClock calculation for Transmitter tables
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ee59f2b462b0a7d2eb57ae59340d016589fa8e42
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 5 13:11:46 2009 -0500

    drm/radeon/kms/r600: fix rs880 support v2
    
    Lots of cases were wrong or missing.
    
    v2: rebased against drm-next
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e29649db3bd5620499bf9bdcd63c5cf12edbd26e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 3 10:04:01 2009 -0500

    drm/radeon/kms/r700: fix some typos in chip init
    
    Noticed by Andre on IRC.
    
    Also fix up some minor whitespace issues.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6fa8d66af83710b3610bd3b2581f051074f2b416
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 3 16:10:36 2009 -0500

    drm/radeon/kms: remove some misleading debugging output
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4d357abb895ec51f1cbdebb1fbbf4d4576900a2e
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Nov 3 14:54:36 2009 +1000

    drm/radeon/kms: stop putting VRAM at 0 in MC space on r600s.
    
    The Lenovo W500 laptop hangs inside an SMI on brightness changes,
    I thought it just needed the VGA disable but it turned out to require
    slightly more work, setting the MC locations up just like the IGP
    chip requirements seems to make it all happy again and I can boot
    and play with brightness.
    
    We should probably just do this for all chips and give up the VRAM
    at 0x0 idea, it never seems to buy us anything but pain.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8a9832e89ff1bc7a039c8f966f07101570be3d5e
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Nov 3 13:23:15 2009 +1000

    drm/radeon/kms: disable D1VGA and D2VGA if enabled
    
    Once kms is enabled we don't need these, and it causes a problem
    with the Lenovo W500 ACPI brightness implementation, it hangs
    in a loop inside an SMI.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d6f28938d9426d12eea1578949f1d73d24ad37ec
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Nov 2 16:01:27 2009 -0500

    drm/radeon/kms: Don't RMW CP_RB_CNTL
    
    Immediate readback seems faulty on some chips.  I
    suspect it takes a while to get through the fifo
    to the actual register backbone.  There's no need
    to read it back, so, just write the driver's copy
    of the register's value directly.
    
    Should fix bug 24535 and possibly 24218
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit df67bed92fa86ef926da8b62a6da68722388ff72
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Oct 30 13:31:26 2009 +1000

    drm/radeon/kms: fix coherency issues on AGP cards.
    
    When we are evicting from VRAM->RAM we allocate the ttm object,
    but we don't set the caching policy on it before blitting into it.
    This means on AGP we end up blitting into cached pages, and
    the CPU later flushes out on top of them. This was mostly seen as
    font corruption.
    
    The other question is why we don't evict VRAM->GTT in a lot of cases,
    this would save us some cache transitions since a lot of objects
    that are evicted from VRAM will probably end up being pulled back in
    a few operations later, and evicting them to system memory involves
    2 unnecessary cache transitions.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ea1495a6274c9542a168337536f8ce74d1173f23
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Oct 27 11:57:53 2009 +1100

    drm/radeon/kms: fix rc410 suspend/resume.
    
    This fixes suspend/resume on my rc410 motherboard, it restores
    the memory controller setup before posting the GPU, since it seems
    to need the MC_FB_LOCATION setup correctly.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fc7f7119d2ed97fff1aaddad6bf7d61ed446cf37
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Oct 28 01:46:54 2009 -0400

    drm/radeon/kms: add quirk for hp dc5750
    
    Doesn't have a tv-out port
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d11aa88b33b071d55181a7a482b9e7494888c10e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Oct 28 00:51:20 2009 -0400

    drm/radeon/kms/atom: fix potential oops in spread spectrum code
    
    Make sure we have an LVDS encoder before casting enc_priv.
    
    [airlied: also fix two missing cpu_to_le16 casts we noticed on irc]
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a2d49ae7df5b96fba3c63710df61412587fc6a24
Author: James Simmons <jsimmons@infradead.org>
Date:   Tue Oct 27 21:09:24 2009 +0000

    drm/kms: typo fix
    
    I believe this is a typo.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 61c4b24b3e3bb83bfe29f24fe566281b4f722237
Author: Mathias Fröhlich <Mathias.Froehlich@gmx.net>
Date:   Tue Oct 27 15:08:01 2009 -0400

    drm/radeon/kms/atom: Make card_info per device
    
    Make the struct card_info, which is a per struct radeon_device dataset, a
    struct member of the radeon device instead of a static per kernel module
    value. This should avoid potential problems with two radeon cards installed in
    one system.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d56ef9c8fd34ed29ffae27598a864b4a9a82521b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Oct 27 12:11:09 2009 -0400

    drm/radeon/kms/atom: Fix DVO support
    
    DVO in 12 bit mode (which seems to be the most common
    config) requires 2x ppll.
    
    Fixes fdo bug 21857.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8f552a66a40bcc6e903e91310f42fe140e0342c4
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Oct 27 11:16:09 2009 -0400

    drm/radeon/kms/atom: loosen pll min output limits
    
    Limiting the pll output range is a good thing generally as
    it limits the number of possible pll combinations for a given
    frequency presumably to the ones that work best on each card.
    That's why the limits are in the bios tables. However, certain
    duallink DVI monitors seem to like pll combinations that would
    be limited by this at least on pre-DCE 3.0 r6xx hardware.  This
    might need to be adjusted per family or per clock range in the
    future.
    
    See fdo bug 24727.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3e5cb98dfe87cc61d0a1119dd8aa2b1e4cfab424
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Oct 16 12:21:24 2009 -0400

    drm/radeon/kms: add support for msi
    
    Try to enable msi on chips that support it.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ebbe1cb936dfc96d809ccf4d64a9755f8ba0c0ff
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Oct 16 11:15:25 2009 -0400

    drm/radeon/kms/atom: add support for spread spectrum (v2)
    
    Spread spectrum is a periodic disturbance added
    to the feedback divider to change the pixel clock
    periodically to reduce interference.
    
    Only enabled on LVDS.
    
    v2: add support for r4xx and fix DCE 3
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c290dadf4cac25cc91529d84004795ab43fc0821
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 22 16:12:34 2009 -0400

    drm/radeon/kms/r7xx: add regs for 40 bit CUR/GRPH addresses
    
    The *_HIGH regs are reversed. The secondary ones are in the
    primary block and vice versa.
    
    We currently only use a 32 bit internal address, so these are
    0 for now.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 33fdb15c99aac20d238af487fa363d3e5c7ed197
Author: Robert Noland <rnoland@2hip.net>
Date:   Tue Oct 20 13:07:38 2009 -0500

    drm/radeon/r600: only assign vb after we know space is available.
    
    This patch only changes this is the swap path, where it doesn't loop.
    
    Signed-off-by: Robert Noland <rnoland@2hip.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c54b1820d69a1043acaf50d084852e628266e0e2
Author: Robert Noland <rnoland@2hip.net>
Date:   Tue Oct 20 08:11:36 2009 -0500

    drm/radeon/r600: Replace repeated calculations with variable.
    
    - Reduce the chance of error and avoid a bit of overhead.
      - Use switch to assign color and format
    
    Signed-off-by: Robert Noland <rnoland@2hip.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bc293e58cb4095f2ad43fe672ae269e31d1a18e2
Author: Mathias Fröhlich <Mathias.Froehlich@web.de>
Date:   Mon Oct 19 17:49:49 2009 -0400

    drm/radeon/kms/atom: get better min pixel clock info
    
    Where supported use ulMinPixelClockPLL_Output rather than
    usMinPixelClockPLL_Output for pll_out_min.  This seems to
    improve pll selection on some boards.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 790cfb34ad645be3bf69265cb05d824aeabcfa11
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 15 23:26:09 2009 -0400

    drm/radeon/kms: add quirk for acer 5102
    
    doesn't have a tv-out port
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5885b7a9f4d2a0405b7e42d44eab4ed2302a8239
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Oct 19 17:23:33 2009 -0400

    drm/radeon/kms: fix vram_width calculation on r6xx/r7xx
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ceb776bc87280eb8d13f38e4d7afae757e95af44
Author: Mathias Fröhlich <Mathias.Froehlich@web.de>
Date:   Mon Oct 19 12:50:41 2009 -0400

    drm/radeon/kms: fix cs parser tex bit 11 check
    
    The problem boils down to the order when the bit11
    of the texture size is or'ed to the original width.
    In the end each mipmap level has the same width or
    height because of that 11 bit is ored to the scaled
    down lod with and thus blows up the size again to the
    full size or more due to the power of two rounding
    afterwards.
    
    The attached patch changes this order so that the
    texture sizes are computed correct. Also the on error
    the yet missing inputs to the size computation are
    printed which helped me to find out where it really breaks.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c850cb782626fda78e5e9e5baf18a5bd806a225c
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Oct 23 18:49:03 2009 +1000

    drm/kms: fix kms/fbdev colormap support properly.
    
    This sets the fbcon to use TRUECOLOR by default, it then
    only modifies the pseudo palette for fbcon, and only touches
    the real palette when in 8-bit pseudo color mode.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d0c403e950d449c8c413a1fbf05dfec45ce03e55
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 15 23:38:32 2009 -0400

    drm/radeon/kms: fix support for original r100
    
    Original radeon didn't have a connector table in the
    bios.  Check for the CRT table and if we have one,
    add a VGA connector.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2d152c6ba81c8a7776103b517fa454b8da0419aa
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 15 23:08:05 2009 -0400

    drm/radeon/kms: fix legacy quirk handling
    
    Need to check the return type for the quirk function
    to decide whether we add the connectors and encoders.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f059d2ad69b056aeabad4460f706a3df2f77ce50
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

commit a77f171843d466d4af0d527bcb2d314fafa8afd7
Author: Matt Turner <mattst88@gmail.com>
Date:   Wed Oct 14 00:34:41 2009 -0400

    drm/radeon/kms: use RADEON_GPU_PAGE_SIZE instead of 4096
    
    Signed-off-by: Matt Turner <mattst88@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dfdd646773941bb6b22c3898a26a109e57c872a2
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Oct 13 12:48:44 2009 -0400

    drm/radeon/kms: limit default tv modes to <= 1024x768
    
    fixes fdo bug 24496
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ceefedd8e8a80b743fa0b6d6b1992be7029a9efb
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Oct 13 23:57:47 2009 -0400

    drm/radeon/kms/atom: fix tv-out
    
    D1MODE_INTERLEAVE_EN was getting set in some cases
    in the encoder quirks function due to the changes in
    5a9bcacc0a56f0d9577494e834519480018a6cc3
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0294cf4f7f895ddcf284b1ce7cf27a2c9d7106f7
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 15 16:16:35 2009 -0400

    drm/radeon/kms: fix connector edid handling
    
    Based partly on a patch from
    Christian Koenig <deathsimple@vodafone.de>
    
    - fix several memory leaks in radeon_connector->edid handling
    - store edid in radeon_connector->edid in detect() or get_modes()
    - switch hdmi detect code to use radeon_connector->edid
    - add support for oem boards multiple connectors that share
    a ddc line.
    - short circuit lvds_detect() if have a stored edid
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1b4d7d75ccff38008ccd40f8e2d74e33a087caaa
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 15 01:33:35 2009 -0400

    drm/radeon/kms: fix internal tmds setup on legacy display engine
    
    - crtc 0 routing was wrong
    - need to clear various timing bits in FP_GEN_CNTL
    - need to set FP_H/V2_SYNC_STRT_WID regs for crtc 1
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8c2a6d730400e14bf28ccfa11b9bbf453db775ec
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Oct 14 02:00:42 2009 -0400

    drm/radeon/kms: move active_device setup into encoder fixup()
    
    radeon_encoder->active_device defines the active routing
    between the encoder and connector.  The encoder fixup and
    dpms functions need to know the active_device to function
    properly.  Setting active_device in the prepare hook was
    too late in some cases.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fb06ca8f8c61dfd7cbfa2092756577ff78a26dcd
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Oct 12 11:25:05 2009 -0400

    drm/radeon/kms: properly handle mode id with native mode changes
    
    drm modes are objects with indentifiers.  Make sure to preserve
    the mode id when copying mode params.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 39deb2d67515086f08a672e7574716ca0d3883a5
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Oct 12 14:21:19 2009 +1000

    drm/radeon/kms: fix use of index before proper initialisation.
    
    With the adjust table introduction, we need to fill out index
    before getting the table version.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ceeb50279b3d05eb7ea2b67e90acb2110d09325f
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Oct 12 13:54:10 2009 +1000

    drm/radeon: Revert "drm/r600: avoid assigning vb twice in blit code"
    
    This reverts commit 49c458e544ae14514209ed80ea6829ca1b18ddf0. It
    seems to have some side effects in the non-kms cases.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0549a061b545d232d12836f98c7c4965dd83f837
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Oct 9 18:41:19 2009 -0400

    drm/radeon/kms: also check for edid in lvds detect
    
    In case the system has bad native mode info but
    valid edid.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit de2103e452ec7f2db5db7c44279735688608381d
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Oct 9 15:14:30 2009 -0400

    drm/radeon/kms: use drm_mode directly for panel modes
    
    This reduces the number of mode format conversions needed
    and makes native panel mode support cleaner.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5a9bcacc0a56f0d9577494e834519480018a6cc3
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 8 15:09:31 2009 -0400

    drm/radeon/kms/atom: rework crtc modeset
    
    - clean up tv timing handling
    - unify SetCRTC_Timing and SetCRTC_UsingDTDTiming
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2606c88608122339cbd5c6b5c149a2eb74ccfe9e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 8 13:36:21 2009 -0400

    drm/radeon/kms/atom: add support for AdjustDisplayPll
    
    DCE3+ has an AdjustDisplayPll that will adjust the pixel
    clock accordingly based on the encoder/transmitter to
    handle special hw requirements.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5f9a0eb5af16906cd31fc3e02746aa3d61fd3aa9
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 8 13:08:29 2009 -0400

    drm/radeon/kms/atom: reorder crtc dpms
    
    Based on recommendation from bios docs.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2ffb842948ba64b03986f4064140a74c1780c44b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 8 13:02:19 2009 -0400

    drm/radeon/kms: make sure LVDS panel is valid in detect()
    
    If the panel data is bogus this can lead to problems
    later when the hardware trys to set the mode.  If the
    data is invalid, report LVDS as disconnected.
    
    Should fix fdo bug 24247.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b5fc901002db0519093ec723fd98969bc03cd629
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Thu Oct 8 10:44:10 2009 +0200

    drm/radeon/kms: Fix apparent typo in legacy CRTC memory bandwidth calculation.
    
    While investigating the cause of CRTC FIFO underruns, I noticed that when
    converting the memory bandwidth calculation from the userspace X driver code,
    an instance of '8.0' was apparently accidentally converted to '80'.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f30f37def4c72e5df8d949022b806e5a4e99bbcb
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Thu Oct 8 10:44:09 2009 +0200

    drm/radeon/kms: Update memory bandwidth requirements in mode_set_base hook.
    
    The hook may change the number of bytes per pixel being scanned out, which
    affects the CRTC memory bandwidth requirements. E.g. booting in 8bpp and then
    running X in 32bpp would result in the bandwidth requirements being
    underestimated for the latter and consequently in CRTC FIFO underruns causing
    visible artifacts with 3D intensive workloads.
    
    ATOM changes only compile-tested.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e33497aaaef5ec9998cf7b007b13d74bb41be74e
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Oct 12 13:32:38 2009 +1000

    drm/radeon/kms: don't refuse LUT because no framebuffer.
    
    The fb binding might be happening in a subsequent crtc setup call.
    
    gets rid of some lut issues.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-989508576-1257894875=:29664--
