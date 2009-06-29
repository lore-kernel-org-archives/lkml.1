Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZF2KbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZF2KbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZF2KbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:31:02 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39646 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZF2KbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=EnWc+X1RUDxMRLFvPghnu+rgguhTdB9gDBzuoq8ZAcUpfFp56+uNg/+fRNxaEj9shA
         X+9enUJoPPH/O1NXl79J585Moq0yGVQOeC7lzSTs8FiNd2VAMRTwHKGAgbtHnKrQzak8
         8ufAQYaP8e2eSjGSgwjGC7Kj2b9KKeFyIe/34=
MIME-Version: 1.0
In-Reply-To: <20090629091508.GA6308@cr0.nay.redhat.com>
References: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com> 
	<2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com> 
	<a5d9929e0906290153g305427c6j37f96db060cb4738@mail.gmail.com> 
	<20090629091508.GA6308@cr0.nay.redhat.com>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Mon, 29 Jun 2009 11:30:41 +0100
Message-ID: <a5d9929e0906290330s704d5848nb36ce2d37dc9124b@mail.gmail.com>
Subject: Re: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
To: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

The system seemed to happily ignore all the sysctl.conf changes and
all echo VALUE >  /proc/sys/kernel/max_lock_depth

So i dug a little on the source and changed

include/linux/sched.h

# define MAX_LOCK_DEPTH 48UL

to

# define MAX_LOCK_DEPTH 96UL

and im getting no more errors. Of course, now its probably radioactive
and about to blow up, but at least it's not complaining anymore :).

Thank you for your time and help,
Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal


On Mon, Jun 29, 2009 at 10:15 AM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
> On Mon, Jun 29, 2009 at 09:53:41AM +0100, Joao Correia wrote:
>>Hello
>>
>>Well, it doesnt complain about MAX_STACK_TRACE_ENTRIES anymore, but
>>now it gives me:
>>
>>BUG: MAX_LOCK_DEPTH too low!
>>turning off the locking correctness validator.
>>Pid: 1672, comm: qemu-kvm Not tainted 2.6.30-wl #2
>>Call Trace:
>> [<c07da76f>] ? printk+0x22/0x3b
>> [<c0463de9>] __lock_acquire+0xa77/0xb05
>> [<c0463f2e>] lock_acquire+0xb7/0xeb
>> [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
>> [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
>> [<c07dd476>] _spin_lock_nest_lock+0x30/0x71
>> [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
>> [<c04be96c>] mm_take_all_locks+0xb3/0xf1
>> [<c04cc741>] do_mmu_notifier_register+0x9f/0x14e
>> [<c04cc83d>] mmu_notifier_register+0x1e/0x31
>> [<f9e461b8>] kvm_dev_ioctl+0xfd/0x25d [kvm]
>> [<f9e460bb>] ? kvm_dev_ioctl+0x0/0x25d [kvm]
>> [<c04e4df6>] vfs_ioctl+0x29/0x91
>> [<c04e52f4>] do_vfs_ioctl+0x496/0x4e3
>> [<c07dfb82>] ? do_page_fault+0x229/0x26a
>> [<c0408e41>] ? sched_clock+0x9/0xd
>> [<c0461218>] ? lock_release_holdtime+0x39/0x143
>> [<c07dfb82>] ? do_page_fault+0x229/0x26a
>> [<c04e5396>] sys_ioctl+0x55/0x86
>> [<c04037f3>] sysenter_do_call+0x12/0x38
>>
>>which looks like its younger brother :-). (Also appears on other
>>programs, not just qemu-kvm)
>
> Hmmm.. also known. :)
>
>>
>>Should i increase its value too? Am i not just masking something else
>>by doing this?
>
> Just try to modify your sysctl.conf file, on Fedora it should be
> /etc/sysctl.conf, try to double the value of
> /proc/sys/kernel/max_lock_depth.
>
> If this doesn't work, try to increase the value of 'max_lock_depth'
> in the kernel source. :)
>
> I think Peter will have a patch to fix this.
>
>
