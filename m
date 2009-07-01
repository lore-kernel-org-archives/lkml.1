Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZGAHsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZGAHsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZGAHsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:48:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54130 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZGAHsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:48:24 -0400
Message-ID: <4A4B1522.1090000@redhat.com>
Date: Wed, 01 Jul 2009 10:49:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       KVM list <kvm@vger.kernel.org>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: pci_stub and kvm
References: <86802c440906302118oa181b2fm9599137bb2314129@mail.gmail.com>
In-Reply-To: <86802c440906302118oa181b2fm9599137bb2314129@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 07:18 AM, Yinghai Lu wrote:
> [ 1966.343286]
> [ 1966.343288] =======================================================
> [ 1966.356756] [ INFO: possible circular locking dependency detected ]
> [ 1966.356759] 2.6.31-rc1-tip-00978-g99123e5-dirty #438
> [ 1966.356761] -------------------------------------------------------
> [ 1966.356764] events/0/387 is trying to acquire lock:
> [ 1966.356766]  (&kvm->lock){+.+.+.}, at: [<ffffffff8100af27>]
> kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
> [ 1966.356786]
> [ 1966.356787] but task is already holding lock:
> [ 1966.356789]  (&match->interrupt_work){+.+...}, at:
> [<ffffffff810986e9>] worker_thread+0x175/0x2f6
> [ 1966.356797]
> [ 1966.356798] which lock already depends on the new lock.
> [ 1966.356799]
> [ 1966.356800]
> [ 1966.356801] the existing dependency chain (in reverse order) is:
> [ 1966.356803]
> [ 1966.356803] ->  #1 (&match->interrupt_work){+.+...}:
> [ 1966.356809]        [<ffffffff810b3bf6>] __lock_acquire+0x1396/0x1710
> [ 1966.356817]        [<ffffffff810b403c>] lock_acquire+0xcc/0x104
> [ 1966.356821]        [<ffffffff810994a8>] __cancel_work_timer+0x121/0x247
> [ 1966.356825]        [<ffffffff8109962c>] cancel_work_sync+0x23/0x39
> [ 1966.356828]        [<ffffffff8100b280>] kvm_deassign_irq+0xf1/0x183
> [ 1966.356832]        [<ffffffff8100db6c>] kvm_vm_ioctl+0x8c8/0xc1a
> [ 1966.356837]        [<ffffffff81156e56>] vfs_ioctl+0x3e/0xa3
> [ 1966.356846]        [<ffffffff8115741c>] do_vfs_ioctl+0x4be/0x511
> [ 1966.356850]        [<ffffffff811574c5>] sys_ioctl+0x56/0x8d
> [ 1966.356854]        [<ffffffff81034fdb>] system_call_fastpath+0x16/0x1b
> [ 1966.356860]        [<ffffffffffffffff>] 0xffffffffffffffff
> [ 1966.356869]
> [ 1966.356870] ->  #0 (&kvm->lock){+.+.+.}:
> [ 1966.356872]        [<ffffffff810b392b>] __lock_acquire+0x10cb/0x1710
> [ 1966.356875]        [<ffffffff810b403c>] lock_acquire+0xcc/0x104
> [ 1966.356878]        [<ffffffff81cde487>] mutex_lock_nested+0x75/0x2fa
> [ 1966.356886]        [<ffffffff8100af27>]
> kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
> [ 1966.356890]        [<ffffffff81098743>] worker_thread+0x1cf/0x2f6
> [ 1966.356892]        [<ffffffff8109e335>] kthread+0xa8/0xb0
> [ 1966.356899]        [<ffffffff8103609a>] child_rip+0xa/0x20
> [ 1966.356906]        [<ffffffffffffffff>] 0xffffffffffffffff
>    

This is already fixed in kvm.git.  I'm not sure about merging it to 
2.6.30 since the race is very rare and involves device assignment (which 
is not very mainstream), while the fix touches the core kvm parts.

-- 
error compiling committee.c: too many arguments to function

