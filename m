Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbYFXPde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbYFXPde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYFXPdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:33:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbYFXPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:33:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Support arch/$ARCH/include in kbuild
Date: Tue, 24 Jun 2008 17:32:57 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080621220703.GA12279@uranus.ravnborg.org> <20080622220508.GA8957@uranus.ravnborg.org>
In-Reply-To: <20080622220508.GA8957@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241732.58449.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0dA94bRQU+3EwxLgqGuu+Zy2Wopjfg27vFtp
 0eLHNLfIJYoHZEn59fhIlMDtBjm8iwRRHpshBcMP27bvgscNdk
 8xYQBWDAYBffBl3kUTxgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Sam Ravnborg wrote:

> Any comments are welcome!
> Patches will follow as reply to this one, but they
> are only sent to kbuild and lkml.

I think you need to fix up all instances of #include <asm-$ARCH/$FILE>,

grep ^#[:ws:]*include.*[\"\<]asm-[^g].*/ `git-ls-files`

Documentation/lguest/lguest.c:#include "asm-x86/bootparam.h"
arch/ia64/ia32/audit.c:#include <asm-x86/unistd_32.h>
arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/processor.h>
arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/ptrace.h>
arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/siginfo.h>
arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/sigcontext.h>
arch/ia64/kernel/asm-offsets.c:#include <asm-ia64/mca.h>
arch/ia64/kernel/jprobes.S:#include <asm-ia64/break.h>
arch/mips/mips-boards/generic/amon.c:#include <asm-mips/addrspace.h>
arch/mips/mips-boards/generic/amon.c:#include <asm-mips/mips-boards/launch.h>
arch/mips/mips-boards/generic/amon.c:#include <asm-mips/mipsmtregs.h>
arch/powerpc/platforms/86xx/mpc86xx_smp.c:#include <asm-powerpc/mpic.h>
arch/sparc64/kernel/compat_audit.c:#include <asm-sparc/unistd.h>
arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
drivers/char/agp/parisc-agp.c:#include <asm-parisc/parisc-device.h>
drivers/char/agp/parisc-agp.c:#include <asm-parisc/ropes.h>
drivers/infiniband/hw/ehca/ehca_reqs.c:#include <asm-powerpc/system.h>
drivers/s390/net/qeth_core_main.c:#include <asm-s390/ebcdic.h>
drivers/s390/net/qeth_core_main.c:#include <asm-s390/io.h>
include/asm-arm/arch-omap/board.h:#include <asm-arm/arch-omap/board-nokia.h>
include/asm-blackfin/gpio.h:#include <asm-blackfin/mach-bf548/gpio.h>
include/asm-m68knommu: lots of #include <asm-m68k/*>
include/asm-parisc/ropes.h:#include <asm-parisc/parisc-device.h>
include/asm-powerpc/irqflags.h:#include <asm-powerpc/hw_irq.h>
include/asm-sparc64: lots of #include <asm-sparc/*>

most of these are obvious, the interesting ones being sparc64, m68knommu
and arch/um as well as arch/ia64/ia32/audit.c.

The best idea I have for sparc64 and m68knommu would be to use
"gcc -Iarch/sparc64/include -Iarch/sparc/include" and then remove the
respective files from sparc64. On m68knommu, this works as well, except
for the pci.h and setup.h files that include the m68k one and then
do some more.

	Arnd <><
