Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYHaKZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYHaKZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYHaKYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:24:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:49789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbYHaKYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kDrvWDfOozKl5742e8GLsNrj71fGzIvJ9iWOUyfbMCWXYMMs2cDnm4bucHOqG7kykj
         8XSwkc4d33iRMbcPPrXYIq1Cfi3x7ncor0F+mHVvM+eusBP5/0prx28d1dhco8/QHOA9
         TA+8ORBJcAzd3k22Z3e5ykKxmCP/TJjsBmegs=
Date: Sun, 31 Aug 2008 12:22:59 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: xerces8 <xerces8@butn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: oops during reboot in device_shutdown()
Message-ID: <20080831102242.GA5514@joi>
References: <WorldClient-F200808302352.AA52330038@butn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <WorldClient-F200808302352.AA52330038@butn.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 11:52:33PM +0200, xerces8 wrote:
> Hi!
> 
> While running RIPLinux* 6.3, I got the below oops.
> 
> What I did was boot up riplinux from USB key, start X, the run "reboot -f" on VT2.
> 
> * - http://www.tux.org/pub/people/kent-robotti/looplinux/rip/
> 
> After the oops I run "reboot" again and got the same oops again.
> Note: I am not sure if I ran the 32 or 64 bit kernel.

They are from 32 bit kernel.
 
> For kernel config and (3 smallish) patches see:
> http://www.tux.org/pub/people/kent-robotti/looplinux/rip/docs/kernel.txt
> (or http://www.tux.org/pub/people/kent-robotti/looplinux/rip/docs/kernel64.txt)
> 
> 
> HW: Asus P5K-E WiFi maonboard, BIOS version 1013
> (Intel P35/ICH9R), CPU: Intel Core2 Q6600
> 
> The oops (both):
> 
> md: stopping all md devices.
> BUG: unable to handle kernel NULL pointer dereference at 00000004
> IP: [<c030b110>] device_shutdown+0x39/0x4c
> *pde = 00000000 
> Oops: 0000 [#1] 
> Modules linked in: snd_mixer_oss snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep snd
> soundcore rtl8187 eeprom_93cx6
> 
> Pid: 1982, comm: reboot Not tainted (2.6.26 #8)
> EIP: 0060:[<c030b110>] EFLAGS: 00010246 CPU: 0
> EIP is at device_shutdown+0x39/0x4c
> EAX: 00000000 EBX: ffffff90 ECX: 00000000 EDX: ffffff90
> ESI: 28121969 EDI: b7fb2ff4 EBP: f7d0c000 ESP: f7d0de98
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process reboot (pid: 1982, ti=f7d0c000 task=f3052740 task.ti=f7d0c000)
> Stack: 00000000 c011e1bd c011e2ad 01234567 c011e3ec f7d0df14 f7d0df3c 0000002b 
>        f28d552c c0149ba1 f28d55c8 c0150d11 ffffff9c ffffff9c 00000401 ffffff9c 
>        f28d552c c0949308 00000001 f30528a4 f3052768 c0111cc7 c0111bc9 f30d6ac8 
> Call Trace:
>  [<c011e1bd>] kernel_restart_prepare+0x20/0x25
>  [<c011e2ad>] kernel_restart+0x8/0x2e
>  [<c011e3ec>] sys_reboot+0x112/0x14f
>  [<c0149ba1>] put_filp+0x14/0x31
>  [<c0150d11>] __path_lookup_intent_open+0x6a/0x72
>  [<c0111cc7>] dequeue_entity+0xf/0x8d
>  [<c0111bc9>] __dequeue_entity+0x1f/0x71
>  [<c0111c2c>] set_next_entity+0x11/0x38
>  [<c065eb56>] schedule+0x22e/0x24a
>  [<c01241d1>] hrtimer_cancel+0xa/0x14
>  [<c065f085>] do_nanosleep+0x4e/0x7b
>  [<c01244ba>] hrtimer_nanosleep+0x50/0xab
>  [<c012412a>] hrtimer_wakeup+0x0/0x18
>  [<c0124556>] sys_nanosleep+0x41/0x51
>  [<c01036f2>] syscall_call+0x7/0xb
>  =======================
> Code: 74 eb 2b 8b 82 b4 00 00 00 85 c0 74 07 8b 48 20 85 c9 75 11 8b 82 b8 00 00 00 85 c0 74 0b 8b
> 48 18 85 c9 74 04 89 d0 ff d1 89 da <8b> 5b 74 83 eb 70 8d 42 70 3b 05 a4 bc 96 c0 75 c7 5b c3 55 89 
> EIP: [<c030b110>] device_shutdown+0x39/0x4c SS:ESP 0068:f7d0de98
> ---[ end trace e0383ca117e3155e ]---

Try to rmmod all modules and see whether reboot works, if it is try to
unload only half of them, etc... (And tell us which module blocks your reboot)

If it will be hard to reproduce or procedure above won't work, please
enable "Kernel debugging" (CONFIG_DEBUG_KERNEL), "Driver Core verbose
debug messages" (CONFIG_DEBUG_DRIVER) and copy messages from dmesg which
happen before oops.


Marcin
