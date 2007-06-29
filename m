Return-Path: <linux-kernel-owner+w=401wt.eu-S1764844AbXF2GM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764844AbXF2GM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 02:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbXF2GMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 02:12:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:12420 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXF2GMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 02:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kLJEA9BpBAg2DwDRh7hwU+R9QhzKiVLd9ZA6VUxJK67yOPnT99VmE4W2l9syi6R3k0TZtTBtY1TQpsY1WMK2z55DaLVqRJllSMzCf/gwz7b4AVAmnKDVY7+fIFcssleqrsVFB9OUrB53ko71oxTRBqy5KKjwVYaUjUVtGiUsTb4=
Message-ID: <a781481a0706282312r5354d06di3e166d9b2e8bd63e@mail.gmail.com>
Date: Fri, 29 Jun 2007 11:42:47 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Clemens Schwaighofer" <cs@tequila.co.jp>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <46847397.70503@tequila.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464A4F56.6080108@tequila.co.jp> <46847397.70503@tequila.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

[ Cc:'ing Andrew, original thread at http://lkml.org/lkml/2007/5/15/354 ]

On 6/29/07, Clemens Schwaighofer <cs@tequila.co.jp> wrote:
> On 05/16/2007 09:24 AM, Clemens Schwaighofer wrote:
> > Hi,
>
> I had my system running up for about one month without any issues, and
> then it happened again, same kernel oops, panic, end.
>
> So I have upgraded to 2.6.22-rc4-mm2 in hope it might fix it, but I just
> got another oops (uptime 4d) [see attached file]

You "upgraded" from -stable series kernels (2.6.19.2 / 2.6.20.6 /
2.6.21.1) to a -mm kernel, which is anything but :-)

On the one hand, I really like that we're getting testers for -mm
kernels, but on the other hand, my good and honest side would
recommend you to install stable kernels (2.6.x.y versions) on
production systems, if you really care about uptimes.

> my config hasn't changed in any way to the previous kernels.

This doesn't look like the same oops you were getting persistently
with 2.6.21.1 ... you could try upgrading to 2.6.22-rc6 (without -mm)
too, if the oops in 2.6.21.1 was occurring too frequently in your setup;
possibly it has been resolved in the 22-rc series.

Satyam

[ Clemens' 2.6.22-rc4-mm2 oops below. ]


Jun 29 11:25:08 saturn kernel: [348308.690154] BUG: unable to handle
kernel NULL pointer dereference at virtual address 00000001
Jun 29 11:25:08 saturn kernel: [348308.690160]  printing eip:
Jun 29 11:25:08 saturn kernel: [348308.690162] c108887c
Jun 29 11:25:08 saturn kernel: [348308.690163] *pde = 00000000
Jun 29 11:25:08 saturn kernel: [348308.690166] Oops: 0000 [#2]
Jun 29 11:25:08 saturn kernel: [348308.690167] PREEMPT
Jun 29 11:25:08 saturn kernel: [348308.690169] Modules linked in:
eeprom pcspkr i2c_viapro k8temp hwmon i2c_core
Jun 29 11:25:08 saturn kernel: [348308.690177] CPU:    0
Jun 29 11:25:08 saturn kernel: [348308.690177] EIP:
0060:[__d_lookup+108/336]    Not tainted VLI
Jun 29 11:25:08 saturn kernel: [348308.690179] EFLAGS: 00010202
(2.6.22-rc4-mm2 #1)
Jun 29 11:25:08 saturn kernel: [348308.690185] EIP is at __d_lookup+0x6c/0x150
Jun 29 11:25:08 saturn kernel: [348308.690187] eax: 00000001   ebx:
00000001   ecx: 00000001   edx: 089c1579
Jun 29 11:25:08 saturn kernel: [348308.690190] esi: c6840ee8   edi:
c301d734   ebp: f786f080   esp: c6840e84
Jun 29 11:25:08 saturn kernel: [348308.690193] ds: 007b   es: 007b
fs: 0000  gs: 0033  ss: 0068
Jun 29 11:25:08 saturn kernel: [348308.690196] Process nfsd (pid:
30536, ti=c6840000 task=c62bce90 task.ti=c6840000)
Jun 29 11:25:08 saturn kernel: [348308.690198] Stack: c301d734
089c1579 c6840edb 00000002 c6840ee8 ffffffff 00000005 c6840edb
Jun 29 11:25:08 saturn kernel: [348308.690205]        0000f9ec
c6840ee8 c301d734 c471ba84 c1088976 c7bbb090 c7bbb090 00000000
Jun 29 11:25:08 saturn kernel: [348308.690211]        c10b49fc
c6840edb 0000000d c14914fb 00007793 332bce90 31313630 c5469900
Jun 29 11:25:08 saturn kernel: [348308.690217] Call Trace:
Jun 29 11:25:08 saturn kernel: [348308.690220]  [d_lookup+22/64]
d_lookup+0x16/0x40
Jun 29 11:25:08 saturn kernel: [348308.690224]
[proc_flush_task+76/496] proc_flush_task+0x4c/0x1f0
Jun 29 11:25:08 saturn kernel: [348308.690229]  [release_task+612/880]
release_task+0x264/0x370
Jun 29 11:25:08 saturn kernel: [348308.690234]  [do_wait+1850/3072]
do_wait+0x73a/0xc00
Jun 29 11:25:08 saturn kernel: [348308.690239]
[_spin_unlock_irq+38/64] _spin_unlock_irq+0x26/0x40
Jun 29 11:25:08 saturn kernel: [348308.690243]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Jun 29 11:25:08 saturn kernel: [348308.690247]  [sys_wait4+49/64]
sys_wait4+0x31/0x40
Jun 29 11:25:08 saturn kernel: [348308.690251]  [sys_waitpid+39/48]
sys_waitpid+0x27/0x30
Jun 29 11:25:08 saturn kernel: [348308.690255]  [syscall_call+7/11]
syscall_call+0x7/0xb
Jun 29 11:25:08 saturn kernel: [348308.690259]  =======================
Jun 29 11:25:08 saturn kernel: [348308.690260] INFO: lockdep is turned off.
Jun 29 11:25:08 saturn kernel: [348308.690262] Code: d3 e8 31 c3 23 1d
b4 d8 51 c1 b8 01 00 00 00 c1 e3 02 03 1d bc d8 51 c1 e8 e2 24 f9 ff
8b 1b 85 db 75 08 eb 44 85 c0 89 c3 74 3e <8b> 03 0f 18 00 90 8d 6b d8
8b 54 24 04 3b 55 34 75 e8 8b 34 24
Jun 29 11:25:08 saturn kernel: [348308.690289] EIP:
[__d_lookup+108/336] __d_lookup+0x6c/0x150 SS:ESP 0068:c6840e84
Jun 29 11:25:08 saturn kernel: [348308.690296] note: nfsd[30536]
exited with preempt_count 1
Jun 29 11:25:08 saturn kernel: [348308.690303] BUG: scheduling while
atomic: nfsd/0x10000002/30536
Jun 29 11:25:08 saturn kernel: [348308.690305] INFO: lockdep is turned off.
Jun 29 11:25:08 saturn kernel: [348308.690307]  [schedule+1490/1744]
schedule+0x5d2/0x6d0
Jun 29 11:25:08 saturn kernel: [348308.690311]
[vt_console_print+106/688] vt_console_print+0x6a/0x2b0
Jun 29 11:25:08 saturn kernel: [348308.690316]  [__cond_resched+18/48]
__cond_resched+0x12/0x30
Jun 29 11:25:08 saturn kernel: [348308.690319]  [cond_resched+42/64]
cond_resched+0x2a/0x40
Jun 29 11:25:08 saturn kernel: [348308.690322]  [unmap_vmas+1116/1184]
unmap_vmas+0x45c/0x4a0
Jun 29 11:25:08 saturn kernel: [348308.690327]  [exit_mmap+105/256]
exit_mmap+0x69/0x100
Jun 29 11:25:08 saturn kernel: [348308.690331]  [mmput+68/256] mmput+0x44/0x100
Jun 29 11:25:08 saturn kernel: [348308.690335]  [do_exit+301/2224]
do_exit+0x12d/0x8b0
Jun 29 11:25:08 saturn kernel: [348308.690339]  [__wake_up+56/80]
__wake_up+0x38/0x50
Jun 29 11:25:08 saturn kernel: [348308.690342]  [die+574/576] die+0x23e/0x240
Jun 29 11:25:08 saturn kernel: [348308.690346]
[do_page_fault+724/1520] do_page_fault+0x2d4/0x5f0
Jun 29 11:25:08 saturn kernel: [348308.690349]  [tcp_ack+2742/6960]
tcp_ack+0xab6/0x1b30
Jun 29 11:25:08 saturn kernel: [348308.690354]  [do_page_fault+0/1520]
do_page_fault+0x0/0x5f0
Jun 29 11:25:08 saturn kernel: [348308.690357]  [error_code+106/112]
error_code+0x6a/0x70
Jun 29 11:25:08 saturn kernel: [348308.690360]  [__d_lookup+108/336]
__d_lookup+0x6c/0x150
Jun 29 11:25:08 saturn kernel: [348308.690364]  [d_lookup+22/64]
d_lookup+0x16/0x40
Jun 29 11:25:08 saturn kernel: [348308.690367]
[proc_flush_task+76/496] proc_flush_task+0x4c/0x1f0
Jun 29 11:25:08 saturn kernel: [348308.690372]  [release_task+612/880]
release_task+0x264/0x370
Jun 29 11:25:08 saturn kernel: [348308.690376]  [do_wait+1850/3072]
do_wait+0x73a/0xc00
Jun 29 11:25:08 saturn kernel: [348308.690380]
[_spin_unlock_irq+38/64] _spin_unlock_irq+0x26/0x40
Jun 29 11:25:08 saturn kernel: [348308.690383]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Jun 29 11:25:08 saturn kernel: [348308.690387]  [sys_wait4+49/64]
sys_wait4+0x31/0x40
Jun 29 11:25:08 saturn kernel: [348308.690390]  [sys_waitpid+39/48]
sys_waitpid+0x27/0x30
Jun 29 11:25:08 saturn kernel: [348308.690394]  [syscall_call+7/11]
syscall_call+0x7/0xb
Jun 29 11:25:08 saturn kernel: [348308.690398]  =======================
Jun 29 11:25:08 saturn kernel: [348308.690472] BUG: scheduling while
atomic: nfsd/0x10000002/30536
Jun 29 11:25:08 saturn kernel: [348308.690474] INFO: lockdep is turned off.
Jun 29 11:25:08 saturn kernel: [348308.690476]  [schedule+1490/1744]
schedule+0x5d2/0x6d0
Jun 29 11:25:08 saturn kernel: [348308.690480]
[_atomic_dec_and_lock+22/96] _atomic_dec_and_lock+0x16/0x60
Jun 29 11:25:08 saturn kernel: [348308.690485]
[_atomic_dec_and_lock+49/96] _atomic_dec_and_lock+0x31/0x60
Jun 29 11:25:08 saturn kernel: [348308.690489]  [__cond_resched+18/48]
__cond_resched+0x12/0x30
Jun 29 11:25:08 saturn kernel: [348308.690492]  [cond_resched+42/64]
cond_resched+0x2a/0x40
Jun 29 11:25:08 saturn kernel: [348308.690495]
[put_files_struct+166/208] put_files_struct+0xa6/0xd0
Jun 29 11:25:08 saturn kernel: [348308.690499]  [do_exit+363/2224]
do_exit+0x16b/0x8b0
Jun 29 11:25:08 saturn kernel: [348308.690503]  [__wake_up+56/80]
__wake_up+0x38/0x50
Jun 29 11:25:08 saturn kernel: [348308.690506]  [die+574/576] die+0x23e/0x240
Jun 29 11:25:08 saturn kernel: [348308.690510]
[do_page_fault+724/1520] do_page_fault+0x2d4/0x5f0
Jun 29 11:25:08 saturn kernel: [348308.690513]  [tcp_ack+2742/6960]
tcp_ack+0xab6/0x1b30
Jun 29 11:25:08 saturn kernel: [348308.690517]  [do_page_fault+0/1520]
do_page_fault+0x0/0x5f0
Jun 29 11:25:08 saturn kernel: [348308.690520]  [error_code+106/112]
error_code+0x6a/0x70
Jun 29 11:25:08 saturn kernel: [348308.690524]  [__d_lookup+108/336]
__d_lookup+0x6c/0x150
Jun 29 11:25:08 saturn kernel: [348308.690528]  [d_lookup+22/64]
d_lookup+0x16/0x40
Jun 29 11:25:08 saturn kernel: [348308.690531]
[proc_flush_task+76/496] proc_flush_task+0x4c/0x1f0
Jun 29 11:25:08 saturn kernel: [348308.690535]  [release_task+612/880]
release_task+0x264/0x370
Jun 29 11:25:08 saturn kernel: [348308.690539]  [do_wait+1850/3072]
do_wait+0x73a/0xc00
Jun 29 11:25:08 saturn kernel: [348308.690543]
[_spin_unlock_irq+38/64] _spin_unlock_irq+0x26/0x40
Jun 29 11:25:08 saturn kernel: [348308.690547]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Jun 29 11:25:08 saturn kernel: [348308.690551]  [sys_wait4+49/64]
sys_wait4+0x31/0x40
Jun 29 11:25:08 saturn kernel: [348308.690554]  [sys_waitpid+39/48]
sys_waitpid+0x27/0x30
Jun 29 11:25:08 saturn kernel: [348308.690558]  [syscall_call+7/11]
syscall_call+0x7/0xb
Jun 29 11:25:08 saturn kernel: [348308.690561]  =======================
