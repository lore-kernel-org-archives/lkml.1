Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYFZS4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYFZS4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYFZS4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:56:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58168 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYFZS4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:56:00 -0400
Date: Thu, 26 Jun 2008 20:56:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Support arch/$ARCH/include in kbuild
Message-ID: <20080626185645.GA13699@uranus.ravnborg.org>
References: <20080621220703.GA12279@uranus.ravnborg.org> <20080622220508.GA8957@uranus.ravnborg.org> <200806241732.58449.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806241732.58449.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 05:32:57PM +0200, Arnd Bergmann wrote:
> On Monday 23 June 2008, Sam Ravnborg wrote:
> 
> > Any comments are welcome!
> > Patches will follow as reply to this one, but they
> > are only sent to kbuild and lkml.
> 
> I think you need to fix up all instances of #include <asm-$ARCH/$FILE>,
> 
> grep ^#[:ws:]*include.*[\"\<]asm-[^g].*/ `git-ls-files`
> 
> Documentation/lguest/lguest.c:#include "asm-x86/bootparam.h"
> arch/ia64/ia32/audit.c:#include <asm-x86/unistd_32.h>
> arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/processor.h>
> arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/ptrace.h>
> arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/siginfo.h>
> arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/sigcontext.h>
> arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/mca.h>
> arch/ia64/kernel/jprobes.S:#include <asm-ia64/break.h>
> arch/mips/mips-boards/generic/amon.c:#include <asm-mips/addrspace.h>
> arch/mips/mips-boards/generic/amon.c:#include <asm-mips/mips-boards/launch.h>
> arch/mips/mips-boards/generic/amon.c:#include <asm-mips/mipsmtregs.h>
> arch/powerpc/platforms/86xx/mpc86xx_smp.c:#include <asm-powerpc/mpic.h>
> arch/sparc64/kernel/compat_audit.c:#include <asm-sparc/unistd.h>
> arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
> arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
> drivers/char/agp/parisc-agp.c:#include <asm-parisc/parisc-device.h>
> drivers/char/agp/parisc-agp.c:#include <asm-parisc/ropes.h>
> drivers/infiniband/hw/ehca/ehca_reqs.c:#include <asm-powerpc/system.h>
> drivers/s390/net/qeth_core_main.c:#include <asm-s390/ebcdic.h>
> drivers/s390/net/qeth_core_main.c:#include <asm-s390/io.h>
> include/asm-arm/arch-omap/board.h:#include <asm-arm/arch-omap/board-nokia.h>
> include/asm-blackfin/gpio.h:#include <asm-blackfin/mach-bf548/gpio.h>
> include/asm-m68knommu: lots of #include <asm-m68k/*>
> include/asm-parisc/ropes.h:#include <asm-parisc/parisc-device.h>
> include/asm-powerpc/irqflags.h:#include <asm-powerpc/hw_irq.h>
> include/asm-sparc64: lots of #include <asm-sparc/*>
> 
> most of these are obvious, the interesting ones being sparc64, m68knommu
> and arch/um as well as arch/ia64/ia32/audit.c.
> 
> The best idea I have for sparc64 and m68knommu would be to use
> "gcc -Iarch/sparc64/include -Iarch/sparc/include" and then remove the
> respective files from sparc64. On m68knommu, this works as well, except
> for the pci.h and setup.h files that include the m68k one and then
> do some more.

For sparc64 I have taken a bit more drastic approach and I am
merging the header files of sparc and sparc64.

My goal is to get sparc converted to use arch/sparc/include/asm
for 2.6.27.

	Sam
