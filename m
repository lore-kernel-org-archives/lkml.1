Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbYIRQg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbYIRQg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYIRQgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:36:51 -0400
Received: from ozlabs.org ([203.10.76.45]:56098 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYIRQgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:36:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18642.33679.149733.537374@cargo.ozlabs.ibm.com>
Date: Thu, 18 Sep 2008 09:36:31 -0700
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

The main thing there is a patch from James Bottomley which fixes the
build failure on 64-bit powerpc with CONFIG_MODULES=n.

There are two other small commits that fix boot problems for embedded
boards: one that ensures that we build the right type of image for the
Holly evaluation board, and one that fixes some interrupt numbers on
Freescale MPC8610-based systems.

Thanks,
Paul.

 arch/powerpc/boot/Makefile             |    2 +-
 arch/powerpc/boot/dts/mpc8610_hpcd.dts |    8 ++++----
 arch/powerpc/include/asm/elf.h         |    7 +++++++
 arch/powerpc/include/asm/sections.h    |   12 +++++++++++-
 arch/powerpc/kernel/module_64.c        |   19 -------------------
 5 files changed, 23 insertions(+), 25 deletions(-)

commit 2d291e902791e1c8d72bc223b6f063bbb27a1280
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Tue Sep 9 14:04:18 2008 +0000

    Fix compile failure with non modular builds
    
    Commit deac93df26b20cf8438339b5935b5f5643bc30c9 ("lib: Correct printk
    %pF to work on all architectures") broke the non modular builds by
    moving an essential function into modules.c.  Fix this by moving it
    out again and into asm/sections.h as an inline.  To do this, the
    definition of struct ppc64_opd_entry has been lifted out of modules.c
    and put in asm/elf.h where it belongs.
    
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 32dde0f975e430f00f03f80f7dbab585d8b45eab
Author: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date:   Tue Sep 9 04:00:28 2008 +0000

    powerpc: Holly board needs dtbImage target
    
    One of the changes in the bootwrapper makefile introduced the dtbImage
    targets for boards that need a simple zImage with a DTB embedded in
    them (595be948cce574ff2d5dde5d0426a636a4363c70, "[POWERPC]
    bootwrapper: Build multiple cuImages").  When this was done, it broke
    booting on the Holly board as the zImage.holly wrapper did not get the
    DTB embedded properly.
    
    This changes the target for the Holly board to a dtbImage so that the
    wrapper includes the vmlinux, wrapper bits, and DTB.
    
    Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 612f9d338a6060f814ef35b7108b43407a5df423
Author: Timur Tabi <timur@freescale.com>
Date:   Tue Sep 9 14:43:39 2008 -0500

    powerpc: Fix interrupt values for DMA2 in MPC8610 HPCD device tree
    
    For Freescale 8xxx devices that use an MPIC, the interrupt numbers in
    the device tree must be 16 greater than the values documented in the
    reference manual.  In these chips, the MPIC is wired to use the first
    16 numbers for external interrupts, but the documentation numbers
    internal interrupts from 0.
    
    In the MPC8610 HPCD device tree, the interrupt properties for the DMA
    channels for DMA2 were not the adjusted values.  This fixes that.
    
    Signed-off-by: Timur Tabi <timur@freescale.com>
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
