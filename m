Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZF2JNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZF2JNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZF2JNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:13:05 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:43343 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZF2JND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IEsdFaevLcnKMpGkAnQg6nqJ1ZGI5f7WxPQsyvqfdkz/Z1C71PxJvqnaDfC58DQBsm
         xOLCfexkwCHfC4d1GxybiNsybe98RQzQLDb1E8I3gjwmI9zfq8dAQKpJ2bZfbBf8GNPT
         p+N5snmd1FpuWgBzU5mPdkLhXpa987ZeVinS4=
Date: Mon, 29 Jun 2009 17:15:08 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
Message-ID: <20090629091508.GA6308@cr0.nay.redhat.com>
References: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com> <2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com> <a5d9929e0906290153g305427c6j37f96db060cb4738@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0906290153g305427c6j37f96db060cb4738@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 09:53:41AM +0100, Joao Correia wrote:
>Hello
>
>Well, it doesnt complain about MAX_STACK_TRACE_ENTRIES anymore, but
>now it gives me:
>
>BUG: MAX_LOCK_DEPTH too low!
>turning off the locking correctness validator.
>Pid: 1672, comm: qemu-kvm Not tainted 2.6.30-wl #2
>Call Trace:
> [<c07da76f>] ? printk+0x22/0x3b
> [<c0463de9>] __lock_acquire+0xa77/0xb05
> [<c0463f2e>] lock_acquire+0xb7/0xeb
> [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
> [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
> [<c07dd476>] _spin_lock_nest_lock+0x30/0x71
> [<c04be96c>] ? mm_take_all_locks+0xb3/0xf1
> [<c04be96c>] mm_take_all_locks+0xb3/0xf1
> [<c04cc741>] do_mmu_notifier_register+0x9f/0x14e
> [<c04cc83d>] mmu_notifier_register+0x1e/0x31
> [<f9e461b8>] kvm_dev_ioctl+0xfd/0x25d [kvm]
> [<f9e460bb>] ? kvm_dev_ioctl+0x0/0x25d [kvm]
> [<c04e4df6>] vfs_ioctl+0x29/0x91
> [<c04e52f4>] do_vfs_ioctl+0x496/0x4e3
> [<c07dfb82>] ? do_page_fault+0x229/0x26a
> [<c0408e41>] ? sched_clock+0x9/0xd
> [<c0461218>] ? lock_release_holdtime+0x39/0x143
> [<c07dfb82>] ? do_page_fault+0x229/0x26a
> [<c04e5396>] sys_ioctl+0x55/0x86
> [<c04037f3>] sysenter_do_call+0x12/0x38
>
>which looks like its younger brother :-). (Also appears on other
>programs, not just qemu-kvm)

Hmmm.. also known. :)

>
>Should i increase its value too? Am i not just masking something else
>by doing this?

Just try to modify your sysctl.conf file, on Fedora it should be
/etc/sysctl.conf, try to double the value of
/proc/sys/kernel/max_lock_depth.

If this doesn't work, try to increase the value of 'max_lock_depth'
in the kernel source. :)

I think Peter will have a patch to fix this.

