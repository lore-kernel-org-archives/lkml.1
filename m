Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbYDXJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbYDXJmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbYDXJlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:41:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41694 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbYDXJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:41:29 -0400
Date: Thu, 24 Apr 2008 10:40:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Hemminger <shemminger@vyatta.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: ARM fixes
Message-ID: <20080424094033.GA32485@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I repeatedly promised many times over the course of the last few days,
it's Thursday, and here's the fix for the broken ARM merge on Monday which
everyone has noticed.  It also includes fixes for the other broken patches
which were included in that merge.

You can get this in several ways:

1. plain old diff

  http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/arm:fixes.diff

2. mbox archive

  http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/arm:fixes.mbox

3. git tree

  http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/linux-2.6-arm.git fixes

 or:

  master.kernel.org:/home/rmk/linux-2.6-arm.git fixes

Please note: this is a temporary branch which only includes these specific
changes; the tree contains much more than just this.  This branch will have
a lifetime of one week from today (by which time it should be merged in
Linus' tree.)

Linus - if you wish, please merge this using the master.kernel.org address.
If not, it'll come along with the next ARM merge request sometime this
coming weekend.

Stephen - if you wish, merge the 'devel' branch from the above tree.  Note,
however, that the 'devel' branch is merely the result of merging a set of
sub-branches (eg, one for PXA, one for RTC work, etc) and as a result the
'devel' branch is regularly torn down and re-merged.  It also contains
experimental and unreviewed changes - and in that regard the contents of it
are likely to change.  The branch itself only exists to give folk like
Andrew a means to get hold of all the sub-branches without having to tell
him when sub-branches get created and destroyed.  It also exists to be
able to generate a single patch for people not using git.


Changes included there-in:

 arch/arm/mach-lh7a40x/arch-kev7a400.c |    5 ++---
 arch/arm/mm/Kconfig                   |    6 ++++++
 arch/arm/mm/proc-arm1020.S            |    2 +-
 arch/arm/mm/proc-arm1020e.S           |    2 +-
 arch/arm/mm/proc-arm1022.S            |    2 +-
 arch/arm/mm/proc-arm1026.S            |    2 +-
 arch/arm/mm/proc-arm6_7.S             |    4 ++--
 arch/arm/mm/proc-arm720.S             |    2 +-
 arch/arm/mm/proc-arm740.S             |    1 +
 arch/arm/mm/proc-arm7tdmi.S           |    1 +
 arch/arm/mm/proc-arm920.S             |    2 +-
 arch/arm/mm/proc-arm922.S             |    2 +-
 arch/arm/mm/proc-arm925.S             |    2 +-
 arch/arm/mm/proc-arm926.S             |    2 +-
 arch/arm/mm/proc-arm940.S             |    1 +
 arch/arm/mm/proc-arm946.S             |    1 +
 arch/arm/mm/proc-arm9tdmi.S           |    1 +
 arch/arm/mm/proc-feroceon.S           |    2 +-
 arch/arm/mm/proc-sa110.S              |    2 +-
 arch/arm/mm/proc-sa1100.S             |    2 +-
 arch/arm/mm/proc-v6.S                 |    2 +-
 arch/arm/mm/proc-v7.S                 |    2 +-
 arch/arm/mm/proc-xsc3.S               |    1 +
 arch/arm/mm/proc-xscale.S             |    2 +-
 drivers/mfd/htc-pasic3.c              |    3 ---
 drivers/pcmcia/Kconfig                |    2 +-
 26 files changed, 32 insertions(+), 24 deletions(-)

From: Catalin Marinas: Mon Apr 21 18:42:04 BST 2008

	[ARM] fix 48d7927bdf071d05cf5d15b816cf06b0937cb84f

	The proc-*.S files have the _prefetch_abort pointer placed at the end
	of the processor structure but the cpu-multi32.h defines it in the
	second position. The patch also fixes the support for XSC3 and the
	MMU-less CPUs (740, 7tdmi, 940, 946 and 9tdmi).

	Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
	Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

From: Philipp Zabel: Sun Apr 20 17:42:16 BST 2008

	[ARM] 5010/1: htc-pasic3: remove unused defines and includes

	Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
	Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

From: Russell King: Mon Apr 21 09:50:25 BST 2008

	[ARM] pxa: fix 0e623941bec7e80c97b076d346327b31ae17d84a

	Place the dependency against the correct config symbol.

	Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

From: Russell King: Sun Apr 20 16:40:47 BST 2008

	[ARM] fix lh7a40x/kev7a400 build

	arch/arm/mach-lh7a40x/arch-kev7a400.c: In function `kev7a400_cpld_handler':
	arch/arm/mach-lh7a40x/arch-kev7a400.c:80: error: structure has no member named `handle'

	Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>



-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
