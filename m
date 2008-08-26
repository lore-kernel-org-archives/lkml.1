Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYHZD6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYHZD6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 23:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYHZD6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 23:58:05 -0400
Received: from ozlabs.org ([203.10.76.45]:49029 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbYHZD6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 23:58:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18611.32544.855676.804034@cargo.ozlabs.ibm.com>
Date: Tue, 26 Aug 2008 13:57:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get some more bug-fixes and defconfig updates for powerpc.  Almost
all of the lines changed are in the defconfigs.  The rest of the
changes are fixes for various regressions, build failures, and a
possible oops, plus two commits that fix memory leaks and race
conditions in code that is only used on embedded systems with
Freescale processors.


Thanks,
Paul.

 arch/powerpc/boot/dts/mpc8641_hpcn.dts            |    2 
 arch/powerpc/boot/dts/tqm8548-bigflash.dts        |    8 
 arch/powerpc/boot/dts/tqm8548.dts                 |    3 
 arch/powerpc/boot/wrapper                         |    2 
 arch/powerpc/configs/83xx/asp8347_defconfig       |  312 ++++++++++++-----
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |  188 ++++++++--
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |  188 ++++++++--
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |  172 +++++++--
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |  176 +++++++---
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |  175 +++++++--
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |  172 +++++++--
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |  168 +++++++--
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |  172 +++++++--
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |  183 +++++++---
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |  351 +++++++++++++++++--
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |  340 ++++++++++++++++--
 arch/powerpc/configs/83xx/sbc834x_defconfig       |  239 +++++++++++--
 arch/powerpc/configs/85xx/ksi8560_defconfig       |   95 ++++-
 arch/powerpc/configs/85xx/mpc8536_ds_defconfig    |  167 +++++----
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |   71 +++-
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig    |  178 ++++++----
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |   98 ++++-
 arch/powerpc/configs/85xx/mpc8568mds_defconfig    |  121 +++++--
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig    |  177 ++++++----
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |   85 +++--
 arch/powerpc/configs/85xx/sbc8548_defconfig       |   63 ++-
 arch/powerpc/configs/85xx/sbc8560_defconfig       |   69 +++-
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |  163 ++++++---
 arch/powerpc/configs/85xx/tqm8540_defconfig       |  112 ++++--
 arch/powerpc/configs/85xx/tqm8541_defconfig       |  139 ++++++--
 arch/powerpc/configs/85xx/tqm8548_defconfig       |  129 +++++--
 arch/powerpc/configs/85xx/tqm8555_defconfig       |  139 ++++++--
 arch/powerpc/configs/85xx/tqm8560_defconfig       |  139 ++++++--
 arch/powerpc/configs/adder875_defconfig           |   55 ++-
 arch/powerpc/configs/c2k_defconfig                |  245 ++++++-------
 arch/powerpc/configs/chrp32_defconfig             |  141 +++++---
 arch/powerpc/configs/ep8248e_defconfig            |  198 +++++++++--
 arch/powerpc/configs/ep88xc_defconfig             |   57 ++-
 arch/powerpc/configs/g5_defconfig                 |  227 +++++++-----
 arch/powerpc/configs/iseries_defconfig            |   87 +++--
 arch/powerpc/configs/linkstation_defconfig        |  133 +++++--
 arch/powerpc/configs/maple_defconfig              |  381 ++++++++++++++-------
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |   72 +++-
 arch/powerpc/configs/mpc8272_ads_defconfig        |  132 +++++--
 arch/powerpc/configs/mpc83xx_defconfig            |  389 +++++++++++++++++++--
 arch/powerpc/configs/mpc85xx_defconfig            |  207 +++++++----
 arch/powerpc/configs/mpc8610_hpcd_defconfig       |  165 +++++----
 arch/powerpc/configs/mpc8641_hpcn_defconfig       |  215 +++++++-----
 arch/powerpc/configs/mpc866_ads_defconfig         |   61 ++-
 arch/powerpc/configs/mpc885_ads_defconfig         |   57 ++-
 arch/powerpc/configs/pmac32_defconfig             |  241 +++++++------
 arch/powerpc/configs/ppc64_defconfig              |  237 +++++++------
 arch/powerpc/configs/ppc6xx_defconfig             |  144 ++++----
 arch/powerpc/configs/pq2fads_defconfig            |  147 ++++++--
 arch/powerpc/configs/prpmc2800_defconfig          |  125 +++++--
 arch/powerpc/configs/ps3_defconfig                |  153 +++++++-
 arch/powerpc/configs/pseries_defconfig            |  172 +++++++--
 arch/powerpc/configs/sbc8641d_defconfig           |  173 +++++++--
 arch/powerpc/configs/storcenter_defconfig         |  113 ++++--
 arch/powerpc/platforms/ps3/htab.c                 |  269 +++++----------
 arch/powerpc/platforms/ps3/setup.c                |    1 
 arch/powerpc/platforms/ps3/spu.c                  |   18 +
 arch/powerpc/platforms/pseries/setup.c            |    1 
 arch/powerpc/sysdev/cpm_common.c                  |   37 +-
 arch/powerpc/sysdev/qe_lib/ucc_fast.c             |    4 
 arch/powerpc/sysdev/qe_lib/ucc_slow.c             |    8 
 drivers/oprofile/cpu_buffer.c                     |    4 
 drivers/oprofile/event_buffer.c                   |    2 
 68 files changed, 6659 insertions(+), 2808 deletions(-)
 rename arch/powerpc/configs/{asp8347_defconfig => 83xx/asp8347_defconfig} (87%)
 rename arch/powerpc/configs/{mpc8536_ds_defconfig => 85xx/mpc8536_ds_defconfig} (95%)

commit 9bdbb9633281b58ff483ede723f8c4a6344cab2f
Author: Paul Mackerras <paulus@samba.org>
Date:   Tue Aug 26 13:31:55 2008 +1000

    powerpc: Update defconfigs for most non-embedded platforms
    
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit d617a40227705eb0d7b7692bbb974d077f0219a9
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Aug 21 11:16:26 2008 +1000

    powerpc: Export CMO_PageSize
    
    This fixes an error building powerpc allmodconfig:
    
    ERROR: "CMO_PageSize" [arch/powerpc/platforms/pseries/cmm.ko] undefined!
    
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit b47027795a22fe61f93de6010c120f26273fc693
Author: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Date:   Thu Aug 21 06:18:56 2008 +1000

    powerpc/ps3: Fix ioremap of spu shadow regs
    
    Fix the ioremap of the spu shadow regs on the PS3.
    
    The current PS3 hypervisor requires the spu shadow regs to be
    mapped with the PTE page protection bits set as read-only (PP=3).
    This implementation uses the low level __ioremap() to bypass the
    page protection settings inforced by ioremap_flags() to get the
    needed PTE bits set for the shadow regs.
    
    This fixes a runtime failure on the PS3 introduced by the powerpc
    ioremap_prot rework of commit a1f242ff460e4b50a045fa237c3c56cce9eabf83
    ("powerpc ioremap_prot").
    
    Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
    CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 9cfeb74e93cf3549b7fa67ffe407192da625c777
Author: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Date:   Thu Aug 21 06:18:51 2008 +1000

    powerpc/ps3: Rework htab code to remove ioremap
    
    Rework the PS3 MMU hash table code to remove the need to ioremap the
    hash table by using the HV calls lv1_insert_htab_entry() and
    lv1_read_htab_entries().
    
    This fixes a runtime failure on the PS3 introduced by the powerpc
    ioremap_prot rework of commit a1f242ff460e4b50a045fa237c3c56cce9eabf83
    ("powerpc ioremap_prot").
    
    Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
    CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 98fded0728d6d65b78a7fe7d205e947ee81bb9b5
Author: Geoff Levand <geoffrey.levand@am.sony.com>
Date:   Thu Aug 21 06:18:43 2008 +1000

    powerpc/ps3: Update ps3_defconfig
    
    Update ps3_defconfig.
    
    Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit f4156d1cd1dc260cca767a6c0636625f05446799
Author: Carl Love <cel@us.ibm.com>
Date:   Mon Aug 11 17:25:43 2008 +1000

    powerpc/cell/oprofile: Avoid double vfree of profile buffer
    
    If an error occurs on opcontrol start, the event and per cpu buffers
    are released.  If later opcontrol shutdown is called then the free
    function will be called again to free buffers that no longer
    exist.  This results in a kernel oops.  The following changes
    prevent the call to delete buffers that don't exist.
    
    Signed-off-by: Carl Love <carll@us.ibm.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Robert Richter <robert.richter@amd.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 2bb2e1db906e6e139636271d2cf46466d9e84005
Author: Kumar Gala <galak@kernel.crashing.org>
Date:   Thu Aug 21 07:11:30 2008 -0500

    powerpc: Update defconfigs for FSL PPC boards
    
    Since we are updated defconfigs I went ahead and moved the
    asp8347_defconfig under 83xx/ and the mpc8536_ds_defconfig under
    85xx/ as that is where they should have been to start with.
    
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

commit 8dd217b27e32081121c31d927e7c70f6dbf6f5c6
Author: Scott Wood <scottwood@freescale.com>
Date:   Thu Jul 31 19:10:22 2008 +0300

    powerpc: Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target
    
    This patch fixes the following build error with mpc866_ads_defconfig:
    
    <--  snip  -->
    
    ...
      WRAP    arch/powerpc/boot/cuImage.mpc866ads
    powerpc64-linux-ld: arch/powerpc/boot/cuboot-mpc866ads.o: No such file: No such file or directory
    make[2]: *** [arch/powerpc/boot/cuImage.mpc866ads] Error 1
    
    <--  snip  -->
    
    Reported-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Scott Wood <scottwood@freescale.com>
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

commit 639d64456e20cbfc866b18dc03cf9f9babc9c7cd
Author: Laurent Pinchart <laurentp@cse-semaphore.com>
Date:   Tue Aug 19 14:20:23 2008 +0200

    cpm2: Fix race condition in CPM2 GPIO library.
    
    The CPM2 GPIO library code uses the non thread-safe clrbits32/setbits32
    macros. This patch protects them with a spinlock.
    
    Signed-off-by: Laurent Pinchart <laurentp@cse-semaphore.com>
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

commit 61a4e9e91dd3916ef91aa4899b7271bba0248677
Author: Timur Tabi <timur@freescale.com>
Date:   Wed Aug 20 10:29:09 2008 -0500

    powerpc: fix memory leaks in QE library
    
    Fix two memory leaks in the Freescale QE library: add a missing kfree() in
    ucc_fast_init() and ucc_slow_init() if the ioremap() fails, and update
    ucc_fast_free() and ucc_slow_free() to call iounmap() if necessary.
    
    Based on a patch from Tony Breeds <tony@bakeyournoodle.com>.
    
    Signed-off-by: Timur Tabi <timur@freescale.com>
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

commit d27a736c7a62c3451e389aa8e0dfc64dab119b9b
Author: Wolfgang Grandegger <wg@grandegger.com>
Date:   Sun Aug 17 10:51:25 2008 +0200

    powerpc/85xx: TQM8548: DTS file fixes and cleanup
    
    Due to the missing compatible property for the SOC, the MPC I2C buses are
    not found any more. This patch fixes this issue. Furthermore it corrects
    the name of the SOC node and adds the missing I2C node for the RTC.
    
    Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

commit ba1616d921429ffe7480e8835e85f95ff041add8
Author: Kumar Gala <galak@kernel.crashing.org>
Date:   Thu Jul 31 17:06:31 2008 -0500

    powerpc: Fix whitespace merge in mpc8641 hpcn device tree
    
    When we coverted the .dts to v1 we lost a space between the irq
    and its polarity/sense information.  This causes a bit of chaos
    as the reset of the blob is off by one cell.
    
    This was noticed by booting and getting errors w/ATA due to
    lock of interrupts.
    
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
