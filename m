Return-Path: <linux-kernel-owner+w=401wt.eu-S932667AbXBEPR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbXBEPR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 10:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXBEPR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 10:17:28 -0500
Received: from main.gmane.org ([80.91.229.2]:55320 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932667AbXBEPR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 10:17:27 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <kernel-stuff@comcast.net>
Subject: Re: v2.6.20-rt1, yum/rpm
Date: Mon, 5 Feb 2007 15:17:14 +0000 (UTC)
Message-ID: <loom.20070205T161518-353@post.gmane.org>
References: <20070205065636.GA1652@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.42.164.97 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.1) Gecko/20061208 Firefox/2.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo <at> elte.hu> writes:

> 
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
> usual place:
> 
>   http://redhat.com/~mingo/realtime-preempt/
> 
> more info about the -rt patchset can be found in the RT wiki:
> 
>   http://rt.wiki.kernel.org
> 

On FC6 with KVM userspace from trunk I get a ton of errors like this in dmesg -

=======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<f90ecc48>] .... vmx_vcpu_load+0x26/0xd2 [kvm_intel]
.....[<f90b0a1c>] ..   ( <= vcpu_load+0x38/0x3c [kvm])

BUG: sleeping function called from invalid context qemu(4314) at
arch/i386/mm/highmem.c:8
in_atomic():1 [00000001], irqs_disabled():0
 [<c010503c>] dump_trace+0x63/0x1e8
 [<c01051dd>] show_trace_log_lvl+0x1c/0x39
 [<c01055d4>] show_trace+0x12/0x14
 [<c01055ea>] dump_stack+0x14/0x16
 [<c0122b71>] __might_sleep+0x110/0x117
 [<c012161b>] kmap+0x3e/0x48
 [<f90b415e>] paging32_walk_addr+0x214/0x276 [kvm]
 [<f90b4f08>] paging32_page_fault+0x51/0x749 [kvm]
 [<f90ede01>] handle_exception+0xeb/0x1da [kvm_intel]
 [<f90edc8a>] kvm_vmx_return+0x169/0x1f5 [kvm_intel]
 [<f90b108a>] kvm_dev_ioctl+0x284/0x1148 [kvm]
 [<c0189db9>] do_ioctl+0x21/0x66
 [<c018a053>] vfs_ioctl+0x255/0x268
 [<c018a0ae>] sys_ioctl+0x48/0x62
 [<c0104009>] syscall_call+0x7/0xb
 [<009858b2>] 0x9858b2
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<f90ecc48>] .... vmx_vcpu_load+0x26/0xd2 [kvm_intel]
.....[<f90b0a1c>] ..   ( <= vcpu_load+0x38/0x3c [kvm])

BUG: sleeping function called from invalid context qemu(4314) at
arch/i386/mm/highmem.c:8
in_atomic():1 [00000001], irqs_disabled():0
 [<c010503c>] dump_trace+0x63/0x1e8
 [<c01051dd>] show_trace_log_lvl+0x1c/0x39
 [<c01055d4>] show_trace+0x12/0x14
 [<c01055ea>] dump_stack+0x14/0x16
 [<c0122b71>] __might_sleep+0x110/0x117
 [<c012161b>] kmap+0x3e/0x48
 [<f90b415e>] paging32_walk_addr+0x214/0x276 [kvm]
 [<f90b4f08>] paging32_page_fault+0x51/0x749 [kvm]
 [<f90ede01>] handle_exception+0xeb/0x1da [kvm_intel]
 [<f90edc8a>] kvm_vmx_return+0x169/0x1f5 [kvm_intel]
 [<f90b108a>] kvm_dev_ioctl+0x284/0x1148 [kvm]
 [<c0189db9>] do_ioctl+0x21/0x66
 [<c018a053>] vfs_ioctl+0x255/0x268
 [<c018a0ae>] sys_ioctl+0x48/0x62
 [<c0104009>] syscall_call+0x7/0xb
 [<009858b2>] 0x9858b2
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<f90ecc48>] .... vmx_vcpu_load+0x26/0xd2 [kvm_intel]
.....[<f90b0a1c>] ..   ( <= vcpu_load+0x38/0x3c [kvm])


