Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXBKOBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXBKOBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 09:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932858AbXBKOBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 09:01:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:29803 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbXBKOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 09:01:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JUwSRe7KY/sjaxyvaKVtAA7/D2LyjJhFDmpvCgWS5T3BFOqa8zPjftbG2+4lsks88kI9r+bX6Vak4ygExnptHnrpt+2WSUHc0VKKTOiXta32f8qZ3qjItIBmVAxH74K92+lk/mFdG6OWnq57uS8vMLSM3g1B04TkMQPdlYyNGGc=
Message-ID: <4af2d03a0702110601g36b4780fuec82be8290d6a397@mail.gmail.com>
Date: Sun, 11 Feb 2007 15:01:00 +0100
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: KVM oops: killing interrupt handler
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
In-Reply-To: <45CEDB95.2020705@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45CE20E5.8000107@gmail.com> <45CEDB95.2020705@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Avi Kivity <avi@qumranet.com> wrote:
> Jiri Slaby wrote:
> > Hi!
> >
> > My schoolmate got this while using kvm-12 on 2.6.20-rc6:
> > http://www.fi.muni.cz/~xslaby/sklad/kvm-intel-panic/a/
> >
> > Unfortunately it's only shots taken by camera. If we are able to
> > reproduce it in 2.6.20, we'll grab netconsole output.
> >
>
> What guest? what host?  How to reproduce?

It's intel core 2 duo emulating 32-bit wxp. It happened after
suspend/resume (he doesn't know if qemu was actually running) of the
machine.

Dmesg (not with the oops):
http://www.fi.muni.cz/~xpapiez/kvm-intel-panic/dmesg.txt
.config:
http://www.fi.muni.cz/~xpapiez/kvm-intel-panic/config-2.6.20-rc6.txt

I don't know if this is related, but qemu-system-x86 ends up in D state:
root     28740  0.0  0.0      0     0 ?        D    14:31   0:00
[qemu-system-x86]
root     28858  0.0  0.0      0     0 ?        D    14:33   0:00
[qemu-system-x86]

qemu-system-x D 0000000000000002     0 28740  28738                     (L-TLB)
 ffff810037455918 0000000000000046 0000000000000000 ffffffff8022d12c
 0000000000000001 0000000080620536 0000000000000001 0000000000000001
 0000000100000001 ffff81001133f8a0 ffff81003ff8e080 0000039ff2320d9f
Call Trace:
 [<ffffffff8022d12c>] try_to_wake_up+0x44c/0x470
 [<ffffffff802486a9>] autoremove_wake_function+0x9/0x30
 [<ffffffff80475ab9>] __mutex_lock_slowpath+0x69/0xb0
 [<ffffffff80475926>] mutex_lock+0x16/0x20
 [<ffffffff886d1c8c>] :kvm:vcpu_load+0x2c/0x70
 [<ffffffff886d1ce3>] :kvm:kvm_free_vcpu+0x13/0x40
 [<ffffffff886d1dd8>] :kvm:kvm_dev_release+0x18/0x60
 [<ffffffff80280785>] __fput+0xc5/0x1c0
 [<ffffffff8027d811>] filp_close+0x71/0x90
 [<ffffffff80234f57>] put_files_struct+0x87/0x110
 [<ffffffff802362d3>] do_exit+0x263/0x850
 [<ffffffff8036845c>] do_unblank_screen+0x7c/0x130
 [<ffffffff8020b720>] kernel_math_error+0x0/0xb0
 [<ffffffff8020c11d>] do_invalid_op+0xad/0xc0
 [<ffffffff886e2418>] :kvm_intel:vmcs_clear+0x38/0x60
 [<ffffffff80474bbb>] thread_return+0x0/0xf5
 [<ffffffff80476dbd>] error_exit+0x0/0x84
 [<ffffffff886e2418>] :kvm_intel:vmcs_clear+0x38/0x60
 [<ffffffff886e3a21>] :kvm_intel:alloc_vmcs_cpu+0x61/0x80
 [<ffffffff886e4b85>] :kvm_intel:vmx_create_vcpu+0x65/0xb0
 [<ffffffff886d271a>] :kvm:kvm_dev_ioctl+0x1aa/0x1250
 [<ffffffff8026252c>] get_page_from_freelist+0x2cc/0x370
 [<ffffffff80262633>] __alloc_pages+0x63/0x2f0
 [<ffffffff8025fff8>] filemap_nopage+0x198/0x350
 [<ffffffff8026b21d>] __handle_mm_fault+0x5ed/0xad0
 [<ffffffff8031ce81>] __up_read+0x21/0xb0
 [<ffffffff80220b8f>] do_page_fault+0x49f/0x870
 [<ffffffff802700e1>] do_mmap_pgoff+0x671/0x800
 [<ffffffff8028be9f>] do_ioctl+0x2f/0xa0
 [<ffffffff8028c1b2>] vfs_ioctl+0x2a2/0x2e0
 [<ffffffff8028c239>] sys_ioctl+0x49/0x80
 [<ffffffff80476dbd>] error_exit+0x0/0x84
 [<ffffffff80209cfe>] system_call+0x7e/0x83

qemu-system-x D 0000000000000001     0 28858  28856                     (L-TLB)
 ffff810017eb5918 0000000000000046 0000000000000000 ffffffff8022d12c
 0000000000000001 0000000080620536 0000000000000001 0000000000000001
 0000000100000001 ffff81003fb50e80 ffff81003ff8e080 000003b72f95dec6
Call Trace:
 [<ffffffff8022d12c>] try_to_wake_up+0x44c/0x470
 [<ffffffff802486a9>] autoremove_wake_function+0x9/0x30
 [<ffffffff80475ab9>] __mutex_lock_slowpath+0x69/0xb0
 [<ffffffff80475926>] mutex_lock+0x16/0x20
 [<ffffffff886d1c8c>] :kvm:vcpu_load+0x2c/0x70
 [<ffffffff886d1ce3>] :kvm:kvm_free_vcpu+0x13/0x40
 [<ffffffff886d1dd8>] :kvm:kvm_dev_release+0x18/0x60
 [<ffffffff80280785>] __fput+0xc5/0x1c0
 [<ffffffff8027d811>] filp_close+0x71/0x90
 [<ffffffff80234f57>] put_files_struct+0x87/0x110
 [<ffffffff802362d3>] do_exit+0x263/0x850
 [<ffffffff8036845c>] do_unblank_screen+0x7c/0x130
 [<ffffffff8020b720>] kernel_math_error+0x0/0xb0
 [<ffffffff8020c11d>] do_invalid_op+0xad/0xc0
 [<ffffffff886e2418>] :kvm_intel:vmcs_clear+0x38/0x60
 [<ffffffff80474bbb>] thread_return+0x0/0xf5
 [<ffffffff80476dbd>] error_exit+0x0/0x84
 [<ffffffff886e2418>] :kvm_intel:vmcs_clear+0x38/0x60
 [<ffffffff886e3a21>] :kvm_intel:alloc_vmcs_cpu+0x61/0x80
 [<ffffffff886e4b85>] :kvm_intel:vmx_create_vcpu+0x65/0xb0
 [<ffffffff886d271a>] :kvm:kvm_dev_ioctl+0x1aa/0x1250
 [<ffffffff8026252c>] get_page_from_freelist+0x2cc/0x370
 [<ffffffff80262633>] __alloc_pages+0x63/0x2f0
 [<ffffffff8025fff8>] filemap_nopage+0x198/0x350
 [<ffffffff8026b21d>] __handle_mm_fault+0x5ed/0xad0
 [<ffffffff8031ce81>] __up_read+0x21/0xb0
 [<ffffffff80220b8f>] do_page_fault+0x49f/0x870
 [<ffffffff802700e1>] do_mmap_pgoff+0x671/0x800
 [<ffffffff8028be9f>] do_ioctl+0x2f/0xa0
 [<ffffffff8028c1b2>] vfs_ioctl+0x2a2/0x2e0
 [<ffffffff8028c239>] sys_ioctl+0x49/0x80
 [<ffffffff80476dbd>] error_exit+0x0/0x84
 [<ffffffff80209cfe>] system_call+0x7e/0x83

After killing X and trying reboot, oops is here again:
http://www.fi.muni.cz/~xslaby/sklad/kvm-intel-panic/a/kernel-panic-11.2.2007.jpg.png

Now I'm going to compile 2.6.20 and try to reproduce there.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
