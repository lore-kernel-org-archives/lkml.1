Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZF3HTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZF3HTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZF3HSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:18:54 -0400
Received: from mail.open.by ([193.232.92.17]:57534 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZF3HSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:18:53 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8866 [Jun 30 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 30 Jun 2009 10:20:38 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090630072037.GA3276@localdomain.by>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
 <6JJ2m5kyucK.A.D2D.VJASKB@chimera>
 <20090629154119.2c61f234@lxorguk.ukuu.org.uk>
 <20090629162853.GB3461@localdomain.by>
 <20090629221509.1d307184@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629221509.1d307184@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/29/09 22:15), Arjan van de Ven wrote:
> > ...
> > Hello Alan, Rafael,
> > 
> > BUG is still here...
> 
> 
> can you enable CONFIG_DEBUG_INFO, and then run this through
> scripts/markup_oops.pl ? With a bit of luck it'll point to the exact
> code that's going wrong...
> 

Hello Arjan. Sure. I'll try.

btw, I've updated bug description:

kernel: [  984.626653] BUG: scheduling while atomic: pptpgw/3347/0x10000500
kernel: [  984.626661] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore pcspkr psmouse rng_core serio_raw i2c_i801 snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi ricoh_mmc sdhci_pci uhci_hcd sdhci mmc_core led_class ehci_hcd r8169 mii ata_piix ide_pci_generic usbcore
kernel: [  984.626763] 
kernel: [  984.626771] Pid: 3347, comm: pptpgw Not tainted (2.6.31-rc1-dbgnv-git5 #2) F3JC                
kernel: [  984.626780] EIP: 0060:[<c103a1fc>] EFLAGS: 00200246 CPU: 0
kernel: [  984.626794] EIP is at finish_task_switch+0x4c/0xc0
kernel: [  984.626800] EAX: 00000000 EBX: c1eaa380 ECX: 00000001 EDX: c1407ee0
kernel: [  984.626807] ESI: f5c72200 EDI: f72fc070 EBP: e4f87f20 ESP: e4f87f0c
kernel: [  984.626813]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [  984.626819] CR0: 8005003b CR2: b6f399ae CR3: 24f80000 CR4: 000006d0
kernel: [  984.626825] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [  984.626831] DR6: ffff0ff0 DR7: 00000400
kernel: [  984.626836] Call Trace:
kernel: [  984.626848]  [<c13fcfef>] schedule+0x41f/0xb20
kernel: [  984.626859]  [<c10ecdb8>] ? sys_read+0x58/0xa0
kernel: [  984.626869]  [<c10033a2>] work_resched+0x5/0x1a
kernel: [ 1051.216759] BUG: scheduling while atomic: pptpgw/3347/0x10000500
kernel: [ 1051.216768] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore pcspkr psmouse rng_core serio_raw i2c_i801 snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi ricoh_mmc sdhci_pci uhci_hcd sdhci mmc_core led_class ehci_hcd r8169 mii ata_piix ide_pci_generic usbcore
kernel: [ 1051.216869] 
kernel: [ 1051.216878] Pid: 3347, comm: pptpgw Not tainted (2.6.31-rc1-dbgnv-git5 #2) F3JC                
kernel: [ 1051.216886] EIP: 0060:[<c1049883>] EFLAGS: 00200246 CPU: 0
kernel: [ 1051.216901] EIP is at __tasklet_schedule+0x53/0x80
kernel: [ 1051.216907] EAX: 00000000 EBX: 00200246 ECX: 00000000 EDX: 00000000
kernel: [ 1051.216914] ESI: 00000000 EDI: e556dd10 EBP: e4f87e70 ESP: e4f87e68
kernel: [ 1051.216921]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [ 1051.216927] CR0: 8005003b CR2: b7085000 CR3: 24f80000 CR4: 000006d0
kernel: [ 1051.216934] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [ 1051.216939] DR6: ffff0ff0 DR7: 00000400
kernel: [ 1051.216945] Call Trace:
kernel: [ 1051.216960]  [<f80b376c>] ppp_asynctty_receive+0x3dc/0x510 [ppp_async]
kernel: [ 1051.216975]  [<c12d161d>] pty_write+0x7d/0x90
kernel: [ 1051.216985]  [<c12cbd13>] n_tty_write+0x303/0x410
kernel: [ 1051.216996]  [<c103d8f0>] ? default_wake_function+0x0/0x40
kernel: [ 1051.217005]  [<c12c8ef3>] tty_write+0x173/0x250
kernel: [ 1051.217015]  [<c10ebcaf>] ? rw_verify_area+0x6f/0xf0
kernel: [ 1051.217025]  [<c12cba10>] ? n_tty_write+0x0/0x410
kernel: [ 1051.217034]  [<c10ec89e>] vfs_write+0xbe/0x1c0
kernel: [ 1051.217043]  [<c12c8d80>] ? tty_write+0x0/0x250
kernel: [ 1051.217052]  [<c10ecaa8>] sys_write+0x58/0xa0
kernel: [ 1051.217062]  [<c100324b>] sysenter_do_call+0x12/0x22


	Sergey
