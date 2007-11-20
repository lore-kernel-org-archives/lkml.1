Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbXKTUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbXKTUmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763507AbXKTUmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:42:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763497AbXKTUmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:42:23 -0500
Date: Tue, 20 Nov 2007 12:35:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       kamalesh@linux.vnet.ibm.com, Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz -- powerpc panic
Message-Id: <20071120123559.d970db9e.akpm@linux-foundation.org>
In-Reply-To: <20071120144659.GC12066@shadowen.org>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<20071120144659.GC12066@shadowen.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 14:46:59 +0000
Andy Whitcroft <apw@shadowen.org> wrote:

> I have one powerpc machine which managed to compile this snapshot!  It
> paniced on boot as below, might be nfs so copied them.  General results
> are popping out on TKO.
> 
> -apw
> 
> Freeing initrd memory: 1224k freed
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> Unable to handle kernel paging request for data at address 0x00000050
> Faulting instruction address: 0xc000000000113b64
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=32 NUMA pSeries
> Modules linked in:
> NIP: c000000000113b64 LR: c000000000113b44 CTR: 0000000000000000
> REGS: C00000077E0679D0 TRAP: 0300   Not tainted  (2.6.24-rc3-mm1-autokern1)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24004044  XER: 20000000
> DAR: 0000000000000050, DSISR: 0000000040000000
> TASK = C00000077E062000[1] 'swapper' THREAD: C00000077E064000 CPU: 0
> GPR00: 0000000000000000 c00000077e067c50 c0000000006c5650 0000000000000001 
> GPR04: c00000077e625bdc 0000000000000005 c000000000501ad4 c000000000731d18 
> GPR08: 0000000000000000 0000000000000000 c00000077e625b40 0000000000000001 
> GPR12: 0000000024004044 c0000000005fd000 0000000000000000 0000000000000000 
> GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> GPR20: 4000000003a00000 0000000004300000 0000000003fb94a8 0000000000132000 
> GPR24: 0000000003fb9718 0000000000000000 c0000000005b6e70 0000000000000000 
> GPR28: 0000000000000005 c00000077e625b40 c000000000652e48 c00000077e625c50 
> NIP [c000000000113b64] .remove_proc_entry+0xac/0x234
> LR [c000000000113b44] .remove_proc_entry+0x8c/0x234
> Call Trace:
> [c00000077e067c50] [c000000000113b44] .remove_proc_entry+0x8c/0x234 (unreliable)
> [c00000077e067d10] [c00000000048bf28] .cache_unregister+0x108/0x1b4
> [c00000077e067d90] [c0000000001ca988] .nfsd_export_shutdown+0x50/0xa4
> [c00000077e067e10] [c0000000005a712c] .init_nfsd+0x108/0x13c
> [c00000077e067ea0] [c000000000582438] .kernel_init+0x224/0x3fc
> [c00000077e067f90] [c000000000026204] .kernel_thread+0x4c/0x68
> Instruction dump:
> e8bf0000 e8810090 7f83e378 4bfffd25 2f830000 419e0018 ebbf0000 e81d0050 
> f81f0000 38000000 f81d0050 e93f0000 <e8090050> 3be90050 2fa00000 409effc4 
> Kernel panic - not syncing: Attempted to kill init!

Various people have been mucking with procfs core:

proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-simplify-function-prototypes.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-remove-useless-checks-in-proc_register.patch
proc-detect-duplicate-names-on-registration.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-simplify-remove_proc_entry-wrt-locking.patch
proc-simplify-remove_proc_entry-wrt-locking-checkpatch-fixes.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch

And I had to skip a couple of patches due to conflicts.

I'll see if it happens on any of my test machines.
