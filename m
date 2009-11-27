Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZK0PD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZK0PD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZK0PD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:03:26 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38751 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbZK0PDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 10:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UwBbyOvhV1VzuGHrxN3G10PlZHMqSYfGJqNjIllffx1h39+SlqLg+kgBCgj0neexbE
         JVpMD6Zm3bGTPbzt/6I6HaMRuYh5D5PuCQzzpJkFP/c4Mxi61w3AvWm9v/+hvhux8gVo
         oiEwfvTZctdeauaBonCtjJ2SAmmxXhG27lWhA=
Message-ID: <4B0FEA3E.5050108@gmail.com>
Date: Fri, 27 Nov 2009 16:03:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm 2009-11-24-16-47
 uploaded]
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
In-Reply-To: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 01:47 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to

Hi, when executing qemu-kvm I often get following warning and a hard lockup.

WARNING: at kernel/smp.c:292 smp_call_function_single+0xbd/0x140()
Hardware name: To Be Filled By O.E.M.
Modules linked in: kvm_intel kvm fuse ath5k ath
Pid: 3265, comm: qemu-kvm Not tainted 2.6.32-rc8-mm1_64 #912
Call Trace:
 [<ffffffff81039678>] warn_slowpath_common+0x78/0xb0
 [<ffffffffa007fd50>] ? __vcpu_clear+0x0/0xd0 [kvm_intel]
 [<ffffffff810396bf>] warn_slowpath_null+0xf/0x20
 [<ffffffff8106410d>] smp_call_function_single+0xbd/0x140
 [<ffffffffa0080af6>] vmx_vcpu_load+0x46/0x170 [kvm_intel]
 [<ffffffffa004dd94>] kvm_arch_vcpu_load+0x24/0x60 [kvm]
 [<ffffffffa0047a8d>] kvm_sched_in+0xd/0x10 [kvm]
 [<ffffffff8102de37>] finish_task_switch+0x67/0xc0
 [<ffffffff814699f8>] schedule+0x2f8/0x9c0
 [<ffffffffa0063538>] ? kvm_apic_has_interrupt+0x48/0x90 [kvm]
 [<ffffffffa0062a58>] ? kvm_cpu_has_interrupt+0x58/0x70 [kvm]
 [<ffffffffa0047c9d>] kvm_vcpu_block+0x6d/0xb0 [kvm]
 [<ffffffff81050f60>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa0055a5a>] kvm_arch_vcpu_ioctl_run+0x3fa/0xb80 [kvm]
 [<ffffffffa0049955>] kvm_vcpu_ioctl+0x435/0x590 [kvm]
 [<ffffffff8102f4ce>] ? enqueue_entity+0x6e/0xe0
 [<ffffffff8102f5eb>] ? enqueue_task_fair+0x3b/0x80
 [<ffffffff8102f6c3>] ? task_new_fair+0x93/0x120
 [<ffffffff810cd848>] vfs_ioctl+0x38/0xd0
 [<ffffffff810cdd8a>] do_vfs_ioctl+0x8a/0x5a0
 [<ffffffff81062926>] ? sys_futex+0xc6/0x170
 [<ffffffff810ce2ea>] sys_ioctl+0x4a/0x80
 [<ffffffff81002eeb>] system_call_fastpath+0x16/0x1b
---[ end trace ced05997e63d4d13 ]---


It is a regression against 2009-11-13-19-59.

Any ideas?

thanks,
-- 
js
