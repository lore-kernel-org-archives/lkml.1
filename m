Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYA3Sfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYA3Sfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYA3Sfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:35:43 -0500
Received: from lixom.net ([66.141.50.11]:60617 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYA3Sfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:35:42 -0500
Date: Wed, 30 Jan 2008 12:35:49 -0600
From: Olof Johansson <olof@lixom.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>, sparclinux@vger.kernel.org,
       linux-ia64@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Message-ID: <20080130183549.GA19395@lixom.net>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130180623.GA24881@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:06:23PM +0100, Ingo Molnar wrote:
> 
> * Luck, Tony <tony.luck@intel.com> wrote:
> 
> > > thanks! Sorry about that: we cross-built on ARM but not on SMP 
> > > non-x86 platforms so this dependency/breakage went unnoticed.
> > 
> > Yes ... all ia64 builds (UP and SMP) are broken at the moment. Please 
> > Cc: me with the fixup patch.
> 
> Could you check the patch below? With this applied to latest -git, ia64 
> buils fine for me in a cross-compiling environment. (but i dont know 
> whether it boots ...)

powerpc (pasemi_defconfig) is broken in new ways from the original
breakage by this patch:

  CHK     include/linux/utsrelease.h
In file included from include/asm/pgtable-ppc64.h:10,
                 from include/asm/pgtable.h:13,
                 from include/linux/mm.h:39,
                 from include/linux/mman.h:14,
                 from arch/powerpc/kernel/asm-offsets.c:22:
include/asm/tlbflush.h: In function 'arch_enter_lazy_mmu_mode':
include/asm/tlbflush.h:112: error: '__my_cpu_offset' undeclared (first
use in this function)
include/asm/tlbflush.h:112: error: (Each undeclared identifier is
reported only once
include/asm/tlbflush.h:112: error: for each function it appears in.)
include/asm/tlbflush.h: In function 'arch_leave_lazy_mmu_mode':
include/asm/tlbflush.h:119: error: '__my_cpu_offset' undeclared (first
use in this function)
In file included from include/linux/mm.h:535,
                 from include/linux/mman.h:14,
                 from arch/powerpc/kernel/asm-offsets.c:22:
include/linux/vmstat.h: In function '__count_vm_event':
include/linux/vmstat.h:62: error: '__my_cpu_offset' undeclared (first
use in this function)
include/linux/vmstat.h: In function 'count_vm_event':
include/linux/vmstat.h:67: error: '__my_cpu_offset' undeclared (first
use in this function)
include/linux/vmstat.h: In function '__count_vm_events':
include/linux/vmstat.h:73: error: '__my_cpu_offset' undeclared (first
use in this function)
include/linux/vmstat.h: In function 'count_vm_events':
include/linux/vmstat.h:78: error: '__my_cpu_offset' undeclared (first
use in this function)
make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1



-Olof
