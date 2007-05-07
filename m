Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXEGFEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXEGFEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 01:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXEGFEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 01:04:49 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:57063 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbXEGFEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 01:04:48 -0400
From: CIJOML <cijoml@volny.cz>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, marcel@holtmann.de,
       bluez-users@lists.sourceforge.net
Subject: Re: OOPS when swsusp/resume when connected to the internet via BT and GPRS
Date: Mon, 7 May 2007 07:04:29 +0200
User-Agent: KMail/1.9.5
References: <200705070005.33834.cijoml@volny.cz> <6bffcb0e0705061534l4cdd2496w8e2e2a0606f17f2e@mail.gmail.com>
In-Reply-To: <6bffcb0e0705061534l4cdd2496w8e2e2a0606f17f2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705070704.30361.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

my kernel is tainted with madwifi opensource driver :). Only binary part is 
ath_hal module, which doesn't have anythink to do with this part of kernel.
Ath_hal is doing RF part of card to protect others tune/transmit in other 
frequency than 2.5/5.8GHz (Wifi 802.11a/b/g).

My kernel is 100% opensource :)

And BTW this happens also with madwifi kernel modules unloaded.

Best regards

Michal


Dne pondělí 07 květen 2007 00:34 jste napsal(a):
> Hi Michal,
>
> On 07/05/07, CIJOML <cijoml@volny.cz> wrote:
> > Hi all,
> >
> > today I experienced OOPS when connected via BT/GPRS to the internet, then
> > swsup and resumed with dongle in HID proxy mode. Please see details in
> > dmesg log:
> >
> > Restarting tasks ... <6>usb 3-1: USB disconnect, address 3
> > done.
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 00000008
> >  printing eip:
> > c018db5d
> > *pde = 00000000
> > Oops: 0000 [#1]
> > PREEMPT
> > Modules linked in: ppp_deflate zlib_deflate bsd_comp ppp_async
> > ppp_generic slhc usbhid nls_iso8859_1 nls_cp437 vfat fat sg
> > sr_mod sd_mod usb_storage bnep rfcomm hidp l2cap lp fuse eeprom hci_usb
> > bluetooth 8250_pci 8250 serial_core snd_intel8x0 sn
> > d_intel8x0m snd_ac97_codec wlan_scan_sta ac97_bus ath_rate_sample
> > nsc_ircc snd_pcm ide_cd ath_pci wlan ath_hal(P) 8139too m
> > ii snd_timer snd irda ehci_hcd psmouse pcspkr i2c_i801 iTCO_wdt
> > iTCO_vendor_support rtc cdrom parport_pc parport snd_page_a
> > lloc uhci_hcd crc_ccitt
> > CPU:    0
> > EIP:    0060:[<c018db5d>]    Tainted: P       VLI
>
> You are using tainted kernel.
>
> "    When you are using a binary driver, the kernel is "tainted",
> which means that the source
> of possible problems may be unrelated to the kernel code (see
> https://secure-support.
> novell.com/KanisaPlatform/Publishing/250/3582750_f.SAL_Public.html for more
> de- tails). You can check whether or not the kernel was tainted when the
> problem occured by
> looking at the corresponding error message. If can you see something
> similar to the following
> line:
> EIP:      0060:[<c046c7c3>]         Tainted: P      VLI
> (the word Tainted is crucial here), the kernel was tainted and most
> probably the kernel
> developers will not be able to help you. In that case you should try
> to reproduce the problem
> without the binary driver loaded. Moreover, if the problem does not
> occur without it, you
> should send a bug report to the creators of the binary driver and ask
> them to ﬁx it."
>
> -- Linux Kernel Tester's Guide
>
> > EFLAGS: 00010282   (2.6.21 #3)
> > EIP is at sysfs_move_dir+0x3e/0x117
> > eax: 00000000   ebx: efd7df40   ecx: f79a1e7c   edx: c1b88940
> > esi: c1b91e28   edi: 00000000   ebp: c1b88940   esp: f79a1e50
> > ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > Process pppd (pid: 6550, ti=f79a0000 task=f29d6ab0 task.ti=f79a0000)
> > Stack: c03475a4 f7f86e68 00000000 fffffff4 efd7df40 f7f86e68 fffffff4
> > c1b88940 c01d27ec f12a5240 c0347596 efd7df40 f12a5240 f12a5240 00000000
> > 00000000 f7f86e00 00000000 c1b88940 c023c984 f7f86e68 f7f36640 ef67b000
> > 00000000 Call Trace:
> >  [<c01d27ec>] kobject_move+0xaf/0xfa
> >  [<c023c984>] device_move+0x49/0xd7
> >  [<fcb54bb3>] rfcomm_tty_close+0x23/0x7a [rfcomm]
> >  [<c021957a>] release_dev+0x1df/0x5e7
> >  [<c01b8eb9>] inode_has_perm+0x66/0x6e
> >  [<c0166469>] __posix_lock_file_conf+0x44e/0x48b
> >  [<c01b8f4a>] file_has_perm+0x89/0x91
> >  [<c0219991>] tty_release+0xf/0x18
> >  [<c015a3c7>] __fput+0x96/0x15e
> >  [<c0157fba>] filp_close+0x51/0x58
> >  [<c0158f65>] sys_close+0x75/0xbf
> >  [<c0103cd8>] syscall_call+0x7/0xb
> >  =======================
> > Code: 40 30 eb 0b a1 a0 79 42 c0 8b 40 14 8b 40 38 89 44 24 08 85 d2 74
> > 05 8b 72 30 eb 0b a1 a0 79 42 c0 8b 40 14 8b 70 38
> > 8b 7c 24 08 <8b> 47 08 31 ff 3b 46 08 0f 84 c1 00 00 00 8b 54 24 08 8b 42
> > 08 EIP: [<c018db5d>] sysfs_move_dir+0x3e/0x117 SS:ESP 0068:f79a1e50
> >
> > Thanks for fixing this issue
> >
> > Michal
>
> Regards,
> Michal
