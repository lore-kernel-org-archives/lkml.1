Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZF2Q1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZF2Q1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZF2Q1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:27:11 -0400
Received: from mail.open.by ([193.232.92.17]:64499 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbZF2Q1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:27:11 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8864 [Jun 29 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Info: {UDS BL}
X-SpamTest-Method: probable
X-SpamTest-Rate: 65
X-SpamTest-SPF: softfail
X-SpamTest-Status: Probable Spam
X-SpamTest-Status-Extended: probable_spam
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Mon, 29 Jun 2009 19:28:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090629162853.GB3461@localdomain.by>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
 <6JJ2m5kyucK.A.D2D.VJASKB@chimera>
 <20090629154119.2c61f234@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629154119.2c61f234@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/29/09 15:41), Alan Cox wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Yes although getting people seeing to test with might_sleep() checks in
> the tty layer demonstrate the tty layer isn't calling into ppp with irqs
> disabled when it shouldn't so I'm at a loss as to whether this is a
> network bug, a scheduler bug or something else.
> 
> The schedule error in __tasklet_schedule() is itself rather peicular.
> 

Hello Alan, Rafael,

BUG is still here...

kernel: [ 7331.719518] BUG: scheduling while atomic: pptpgw/4161/0x10000500
kernel: [ 7331.719526] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr soundcore psmouse serio_raw snd_page_alloc i2c_i801 rng_core evdev
asus_laptop usbhid hid sg sd_mod sr_mod cdrom ata_generic pata_acpi uhci_hcd ata_piix sdhci_pci sdhci ricoh_mmc mmc_core led_class ide_pci_generic ehci_hcd r8169 mii usbcore
kernel: [ 7331.719627] 
kernel: [ 7331.719636] Pid: 4161, comm: pptpgw Not tainted (2.6.31-rc1-dbgnv-git4 #32) F3JC                
kernel: [ 7331.719644] EIP: 0060:[<c13ffcd6>] EFLAGS: 00200246 CPU: 0
kernel: [ 7331.719657] EIP is at _spin_unlock_irqrestore+0x16/0x30
kernel: [ 7331.719664] EAX: c1690300 EBX: 00200246 ECX: 00000000 EDX: 00200246
kernel: [ 7331.719671] ESI: dcf68398 EDI: 0000003a EBP: dcf61e94 ESP: dcf61e90
kernel: [ 7331.719677]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [ 7331.719684] CR0: 8005003b CR2: b6f77000 CR3: 1b4c3000 CR4: 000006d0
kernel: [ 7331.719690] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [ 7331.719696] DR6: ffff0ff0 DR7: 00000400
kernel: [ 7331.719701] Call Trace:
kernel: [ 7331.719714]  [<c12d002b>] tty_ldisc_deref+0x5b/0x90
kernel: [ 7331.719724]  [<c12d16f5>] pty_write+0x85/0x90
kernel: [ 7331.719734]  [<c12cbde3>] n_tty_write+0x303/0x410
kernel: [ 7331.719745]  [<c103d8f0>] ? default_wake_function+0x0/0x40
kernel: [ 7331.719754]  [<c12c8fc3>] tty_write+0x173/0x250
kernel: [ 7331.719763]  [<c10ebcaf>] ? rw_verify_area+0x6f/0xf0
kernel: [ 7331.719772]  [<c12cbae0>] ? n_tty_write+0x0/0x410
kernel: [ 7331.719781]  [<c10ec89e>] vfs_write+0xbe/0x1c0
kernel: [ 7331.719790]  [<c12c8e50>] ? tty_write+0x0/0x250
kernel: [ 7331.719798]  [<c10ecaa8>] sys_write+0x58/0xa0
kernel: [ 7331.719808]  [<c100324b>] sysenter_do_call+0x12/0x22

	Sergey
