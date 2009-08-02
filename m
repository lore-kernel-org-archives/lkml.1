Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZHBJex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZHBJex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 05:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZHBJex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 05:34:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51241 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZHBJev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 05:34:51 -0400
Message-ID: <4A755EB3.9080502@redhat.com>
Date: Sun, 02 Aug 2009 12:38:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
CC: KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Problems with CONFIG_KVM_GUEST?
References: <20090801212616.GD734@mit.edu>
In-Reply-To: <20090801212616.GD734@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding ccs)

On 08/02/2009 12:26 AM, Theodore Tso wrote:
> Using the XFS QA regression test suites to test ext4, I reliably get
> lock-ups and OOPS's with I run a kernel using KVM with
> CONFIG_KVM_GUEST configured.  This is with 2.6.31-rc3 and 2.6.31-rc4.
>
> The problems disappear if I turn off CONFIG_KVM_GUEST; the XFS tests
> run without problem to completion once I turn this configuration
> option off.  That's what I'll do for now, but if someone could look
> into this, I'd appreciate it.
>
> The KVM command-line which I am using is:
>
> /usr/local/bin/qemu-system-x86_64 /kbuild/root_fs.img -net nic,model=ne2k_pci -net tap \
> 	-hdb /dev/closure/test-4k -hdc /dev/closure/scratch \
> 	-hdd /dev/closure/test-1k -serial telnet::4444,server -smp 2 -m 512 \
> 	--kernel /kbuild/ext4/arch/x86/boot/bzImage \
> 	--append "root=0800 console=ttyS0,115200 console=tty0"
>
> ... and here's a typical soft lockup report
>
> [ 2666.103359] BUG: soft lockup - CPU#1 stuck for 61s! [sh:21485]
> [ 2666.103359] Modules linked in:
> [ 2666.112563] irq event stamp: 183767754
> [ 2666.112563] hardirqs last  enabled at (183767753): [<c011ce56>] restore_all_notrace+0x0/0x18
> [ 2666.112563] hardirqs last disabled at (183767754): [<c011d774>] apic_timer_interrupt+0x28/0x34
> [ 2666.112563] softirqs last  enabled at (183758120): [<c01515c8>] __do_softirq+0x162/0x16a
> [ 2666.112563] softirqs last disabled at (183758115): [<c011ed17>] do_softirq+0x68/0xc1
> [ 2666.112563]
> [ 2666.112563] Pid: 21485, comm: sh Not tainted (2.6.31-rc3 #270)
> [ 2666.112563] EIP: 0060:[<c01bb04f>] EFLAGS: 00010282 CPU: 1
> [ 2666.112563] EIP is at handle_mm_fault+0x102/0x82e
> [ 2666.112563] EAX: d5028110 EBX: 00000000 ECX: 00000110 EDX: d5028110
> [ 2666.112563] ESI: 00000007 EDI: c11a6000 EBP: d51d7f2c ESP: d51d7ed8
> [ 2666.112563]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 2666.112563] CR0: 8005003b CR2: d5028110 CR3: 1f93d000 CR4: 000006f0
> [ 2666.112563] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [ 2666.112563] DR6: ffff0ff0 DR7: 00000400
> [ 2666.112563] Call Trace:
> [ 2666.112563]  [<c0161f7e>] ? down_read_trylock+0x39/0x43
> [ 2666.112563]  [<c0625252>] do_page_fault+0x307/0x31d
> [ 2666.112563]  [<c0624f4b>] ? do_page_fault+0x0/0x31d
> [ 2666.112563]  [<c06235bb>] error_code+0x6b/0x70
> [ 2666.112563]  [<c0624f4b>] ? do_page_fault+0x0/0x31d
> [ 2666.112563]  [<c0345ca5>] ? __put_user_4+0x11/0x18
> [ 2666.112563]  [<c014610a>] ? schedule_tail+0x4f/0x52
> [ 2666.112563]  [<c011cc46>] ret_from_fork+0x6/0x1c
> 							
>    

Is this a PAE mode guest?

-- 
error compiling committee.c: too many arguments to function

