Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZBCOkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZBCOkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZBCOkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:40:02 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:2738 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZBCOkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rFLZ+cPCH3ZKmzp2xixX6X/wOY+fpGrGNOyDm90DhCc+4omRbzr2wJ6OyPijgyILUc
         1ZlR8GaTwIz6UeUAMxKDOuxUc9yfo5ADP8LmJbWounSW7s/ZUyZMyu8hcMcPHCC2Rwyj
         uTVLo+YAea4LG4G6qopxC4Hx4MFk7z4aoUDqg=
Subject: Re: [kernel] Question about 2.6.28 kernel
From: Alex <eosyop@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0902022110290.4084@bogon.housecafe.de>
References: <1233594684.3018.12.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0902022110290.4084@bogon.housecafe.de>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 15:22:08 +0100
Message-Id: <1233670928.28905.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 21:12 +0100, Christian Kujau wrote:
> On Mon, 2 Feb 2009, Alex wrote:
> > kernel 2.6.28. Based on a simple rootkit, which can be executed on the
> > 2.6.23, i got an "oops.. unable to handle kernel paging request at
> > 0x...", when i run it on a new kernel. Can anyone help me finding what
> > protection was added to prevent writings on kernel memory ? 
> 
> You could either post the Oops in full and discuss it right here on this 
> list or follow the Documentation/SecurityBugs document if this turns out
> to be security related.
> 

Thanks for reply. Here is the post, it appears when i try to write into
kernel memory.  :

BUG: unable to handle kernel paging request at c0403cb8
IP: [<f86af074>] set_idt_handler+0xe/0x22 [module]
*pde = 00911067 *pte = 00403161 
Oops: 0003 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-4/dev
Modules linked in: module(+) aes_i586 aes_generic arc4 ecb rt73usb
rt2x00usb rt2x00lib rfkill mac80211 cfg80211 ext2 udf bridge stp bnep
rfcomm l2cap bluetooth tun sunrpc cpufreq_ondemand acpi_cpufreq
dm_mirror dm_region_hash dm_log dm_multipath dm_mod ipv6 snd_hda_intel
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss sr_mod cdrom snd_mixer_oss snd_pcm uvcvideo snd_timer
snd_page_alloc snd_hwdep compat_ioctl32 firewire_ohci firewire_core
video snd videodev i2c_i801 ata_piix battery output v4l1_compat ac sky2
crc_itu_t wmi serio_raw pata_acpi i2c_core soundcore joydev iTCO_wdt
ata_generic iTCO_vendor_support sg ahci libata sd_mod scsi_mod ext3 jbd
mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]

Pid: 3887, comm: insmod Not tainted (2.6.28 #2) HP Pavilion dv2700
Notebook PC
EIP: 0060:[<f86af074>] EFLAGS: 00210246 CPU: 0
EIP is at set_idt_handler+0xe/0x22 [module]
EAX: c0403cbd EBX: c0403c88 ECX: c0781b04 EDX: 017d0000
ESI: f86af155 EDI: 00000000 EBP: f63d2fa0 ESP: f63d2e2c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process insmod (pid: 3887, ti=f63d2000 task=f481be80 task.ti=f63d2000)
Stack:
 f86af1b3 f86af2f0 c04371ea f86af2e3 c0652b00 f86af2d1 c0403b64 f86af2c0
 f86af900 c0401130 00200286 c047f11d 00000044 f6201660 00000001 f63d2e7c
 c047f11d f63e6368 f63e6340 f86af900 f63d2e84 c047f16e f63d2fa0 c044d34f
Call Trace:
 [<f86af1b3>] ? init_module+0x5e/0x6f [module]
 [<c04371ea>] ? sys_kill+0x0/0x12b
 [<c0403b64>] ? ia32_sysenter_target+0x0/0x7
 [<c0401130>] ? _stext+0x48/0x119
 [<c047f11d>] ? __vunmap+0x86/0x8e
 [<c047f11d>] ? __vunmap+0x86/0x8e
 [<c047f16e>] ? vfree+0x25/0x27
 [<c044d34f>] ? load_module+0x1449/0x1616
 [<c043d875>] ? autoremove_wake_function+0x0/0x33
 [<c064d3a5>] ? _spin_lock+0x15/0x18
 [<c04a093c>] ? mntput_no_expire+0x18/0x10e
 [<c049c81c>] ? dput+0xe9/0x13e
 [<c044d5a3>] ? sys_init_module+0x87/0x17a
 [<c0403bdf>] ? sysenter_do_call+0x12/0x2f
Code: 6b f8 8b 50 03 83 c0 07 a3 90 0a 6b f8 eb 01 40 80 38 fa 75 fa a3
8c 0a 6b f8 89 d0 c3 eb 01 40 80 38 0f 75 fa 80 78 01 83 75 f4 <c6> 40
fb 68 eb 01 40 80 78 fc 0f 75 f9 80 78 fd 82 75 f3 c3 eb 
EIP: [<f86af074>] set_idt_handler+0xe/0x22 [module] SS:ESP 0068:f63d2e2c
---[ end trace d8513bd2111b2d4e ]---


Thanks in advance for any hints.

Alex


> Christian.

