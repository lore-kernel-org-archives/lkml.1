Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZD3LSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZD3LSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZD3LSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:18:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZD3LS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:18:29 -0400
Date: Thu, 30 Apr 2009 13:18:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Sachin Sant <sachinp@in.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090430111825.GC6900@wotan.suse.de>
References: <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com> <20090429113604.GE3398@wotan.suse.de> <49F87FAB.9050408@in.ibm.com> <20090430041146.GB23746@wotan.suse.de> <49F938E4.2030703@in.ibm.com> <20090430064127.GF23746@wotan.suse.de> <49F973A0.8070106@in.ibm.com> <20090430103528.GA6900@wotan.suse.de> <1241087884.19252.5.camel@penberg-laptop> <20090430210004.05a61841.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430210004.05a61841.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 09:00:04PM +1000, Stephen Rothwell wrote:
> Hi Pekka, Nick,
> 
> On Thu, 30 Apr 2009 13:38:04 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >
> > Stephen, does this patch fix all the boot problems for you as well?
> 
> Unfortunately not, I am still getting this:
> 
> Memory: 1967708k/2097152k available (9836k kernel code, 129444k reserved, 1440k data, 8422k bss, 2092k init)
> Calibrating delay loop... 1021.95 BogoMIPS (lpj=2043904)
> Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> Mount-cache hash table entries: 256
> Unable to handle kernel paging request for data at address 0x00000008
> Faulting instruction address: 0xc00000000010ea18
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=128 NUMA pSeries
> Modules linked in:
> NIP: c00000000010ea18 LR: c00000000010e9e8 CTR: 0000000000000001
> REGS: c000000000b07690 TRAP: 0300   Not tainted  (2.6.30-rc3-autokern1)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 48000082  XER: 00000005
> DAR: 0000000000000008, DSISR: 0000000042000000
> TASK = c0000000009d55d0[0] 'swapper' THREAD: c000000000b04000 CPU: 0
> GPR00: c00000007e001030 c000000000b07910 c000000000b05588 c000000000b4a680 
> GPR04: c00000007e001000 c0000000009d5f18 0000000000000002 c0000000009d5f18 
> GPR08: 000000000000001a 0000000000000001 0000000000000000 0000000000000001 
> GPR12: 0000000088000084 c000000000b53280 0000000000000000 0000000003500000 
> GPR16: c0000000006c8f70 c0000000006c76e8 0000000000000000 00000000003d8800 
> GPR20: 0000000003cc7d90 c0000000007c7d90 0000000000000010 0000000000000000 
> GPR24: c000000000b656f0 f000000003347488 c000000000b4a680 f000000003347488 
> GPR28: c00000007e001180 c00000007e001000 c000000000a6f010 f0000000033474a8 
> NIP [c00000000010ea18] .__slab_alloc_page+0x380/0x3dc
> LR [c00000000010e9e8] .__slab_alloc_page+0x350/0x3dc
> Call Trace:
> [c000000000b07910] [c00000000010e9e8] .__slab_alloc_page+0x350/0x3dc (unreliable)
> [c000000000b079d0] [c00000000010f408] .__remote_slab_alloc+0x60/0x138
> [c000000000b07a80] [c000000000110d40] .__kmalloc_track_caller+0xb4/0x23c
> [c000000000b07b30] [c0000000000ec6e8] .kstrdup+0x4c/0x8c
> [c000000000b07bd0] [c000000000136f88] .alloc_vfsmnt+0xb0/0x178
> [c000000000b07c70] [c00000000011cb80] .vfs_kern_mount+0x40/0xf8
> [c000000000b07d10] [c0000000007ae460] .sysfs_init+0x90/0x108
> [c000000000b07db0] [c0000000007ad058] .mnt_init+0xbc/0x254
> [c000000000b07e50] [c0000000007aca00] .vfs_caches_init+0x150/0x184
> [c000000000b07ee0] [c000000000790a30] .start_kernel+0x418/0x484
> [c000000000b07f90] [c000000000008368] .start_here_common+0x1c/0x34
> Instruction dump:
> 60000000 e93d0040 e97d0028 381d0030 7fa4eb78 e95d0030 7f43d378 39290001 
> 396b0001 f93d0040 f97d0028 f95b0020 <fbea0008> fbfd0030 f81f0008 4bfffb59 
> ---[ end trace 31fd0ba7d8756001 ]---
> 
> This is back to what I got before Nick's first patch.
> 
> This partition has 2G of memory on node 1 (nothing in node 0) starting at
> address 0.  The kernel is using 64k pages.

OK thanks. So I think we have 2 problems. One with MAX_ORDER <= 9
that is fixed by the previous patch, and another which is probably
due to having no memory on node 0 which I will take another look
at now.

We can merge the previous patch now, though.
 

> Let me now if I can tell you anything else or try something.

Thanks,
Nick

