Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZCLGje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZCLGje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 02:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZCLGj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 02:39:26 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57912 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZCLGjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 02:39:25 -0400
Date: Thu, 12 Mar 2009 06:39:21 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       bug-tar@gnu.org, Theodore Tso <tytso@mit.edu>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000006
Message-ID: <20090312063921.GB13401@silver.sucs.org>
References: <200903120133.39252.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903120133.39252.gene.heskett@verizon.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 01:33:39AM -0400, Gene Heskett wrote:
> 
> This is the 2nd or 3rd one of these I've seen.

OK let's try and clean things up a bit and see if that helps. I've tried
changing the subject to make it clearer what is inside your mail. "I
just got got another Oops" is what it says but alas you don't include
the actual oops in the mail so mentioning the BUG is probably better. It
might also help if you replied to your earlier emails so you made a
clearer thread.

I'm CC'ing Ted because there is a mention of ext3_readpages in the stack
trace but there was precious little to do with ext3 in your previous
mail ( http://marc.info/?l=linux-kernel&m=123679141316664&w=2 ) which
makes me suspcious. Is this machine being overclocked at all? Have you
tested its memory to make sure it's not going bad? I guess you could
also turn on SLAB debugging in the Kernel Hacking menu...

There is no way that the userspace tar program is to "blame" for this -
errors/behaviour in userspace programs (other than special ones like X)
_should_ be completely unable to generate kernel errors (it might act as
a trigger for a kernel bug but the fault lies in the kernel).

> This one may have a better set of clues as it occured about 1 second 
> after amanda started the backup run:
> ==============================

Can you teach your email program not to wrap log messages like the lines
below?  It would make life easier...

> Mar 12 01:15:01 coyote xinetd[2583]: START: amanda pid=8970 
> from=::ffff:192.168.71.3                                                     
> Mar 12 01:16:21 coyote kernel: [10353.910914] BUG: unable to handle kernel 
> NULL pointer dereference at 00000006                          
> Mar 12 01:16:21 coyote kernel: [10353.910921] IP: [<c046520b>] 
> get_page_from_freelist+0x24b/0x4c0                                        
> Mar 12 01:16:21 coyote kernel: [10353.910929] *pdpt = 0000000000b38001 *pde = 
> 0000000000000000                                           
> Mar 12 01:16:21 coyote kernel: [10353.910934] Oops: 0000 [#1] PREEMPT SMP                                                                
> Mar 12 01:16:21 coyote kernel: [10353.910937] last sysfs file: 
> /sys/devices/pci0000:00/0000:00:09.0/irq                                  
> Mar 12 01:16:21 coyote kernel: [10353.910940] Modules linked in: nls_utf8 cifs 
> radeon drm nfsd lockd nfs_acl auth_rpcgss rfcomm 
> exportfs sco bridge stp llc bnep l2cap autofs4 sunrpc ipv6 or51132 cx88_dvb 
> snd_emu10k1_synth videobuf_dvb snd_emux_synth 
> dvb_core snd_seq_virmidi snd_seq_midi_emul tuner_simple tuner_types 
> snd_emu10k1 tda9887 snd_rawmidi tda8290 snd_ac97_codec 
> ac97_bus snd_seq_dummy snd_seq_oss tuner snd_seq_midi_event snd_seq 
> snd_pcm_oss cx8800 cx8802 cx88xx snd_mixer_oss snd_pcm 
> snd_seq_device ir_common v4l2_common videodev i2c_algo_bit snd_timer 
> snd_page_alloc tveeprom v4l1_compat snd_util_mem btcx_risc 
> snd_hwdep ftdi_sio videobuf_dma_sg usb_storage snd forcedethfirewire_ohci 
> floppy videobuf_core btusb firewire_core usbserial 
> sr_mod usblp bluetooth cdrom sg soundcore i2c_nforce2 pcspkr crc_itu_t joydev 
> i2c_core evdev button ahci pata_jmicron pata_amd 
> ata_generic pata_acpi sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd 
> ohci_hcd ehci_hcd [last unloaded: 
> scsi_wait_scan]
> Mar 12 01:16:21 coyote kernel: [10353.910986]
> Mar 12 01:16:21 coyote kernel: [10353.910989] Pid: 9222, comm: tar Not tainted 
> (2.6.29-rc7 #4) System Product Name
> Mar 12 01:16:21 coyote kernel: [10353.910992] EIP: 0060:[<c046520b>] EFLAGS: 
> 00210202 CPU: 2
> Mar 12 01:16:21 coyote kernel: [10353.910995] EIP is at 
> get_page_from_freelist+0x24b/0x4c0
> Mar 12 01:16:21 coyote kernel: [10353.910997] EAX: ffffffff EBX: 80004000 ECX: 
> 00000001 EDX: 00000002
> Mar 12 01:16:21 coyote kernel: [10353.910999] ESI: c28fc260 EDI: 00000000 EBP: 
> c0b35d5c ESP: c0b35cfc
> Mar 12 01:16:21 coyote kernel: [10353.911001]  DS: 007b ES: 007b FS: 00d8 GS: 
> 0033 SS: 0068
> Mar 12 01:16:21 coyote kernel: [10353.911004] Process tar (pid: 9222, 
> ti=c0b35000 task=f2817520 task.ti=c0b35000)
> Mar 12 01:16:21 coyote kernel: [10353.911005] Stack:
> Mar 12 01:16:21 coyote kernel: [10353.911006]  00000002 00000044 00000000 
> 00000000 00000000 c0744b80 c06d6480 00000002
> Mar 12 01:16:21 coyote kernel: [10353.911011]  00000000 00000000 001201d2 
> 00000002 00200246 00000001 c06d6900 00000100
> Mar 12 01:16:21 coyote kernel: [10353.911015]  00000000 c0b35dac c06d7484 
> c06d6480 c06d6480 c06d6480 f2817520 00002f66
> Mar 12 01:16:21 coyote kernel: [10353.911020] Call Trace:
> Mar 12 01:16:21 coyote kernel: [10353.911022]  [<c04655fe>] ? 
> __alloc_pages_internal+0xae/0x430
> Mar 12 01:16:21 coyote kernel: [10353.911028]  [<f82b5c60>] ? 
> ext3_readpages+0x0/0x20 [ext3]
> Mar 12 01:16:21 coyote kernel: [10353.911040]  [<c04676b4>] ? 
> __do_page_cache_readahead+0xe4/0x1e0
> Mar 12 01:16:21 coyote kernel: [10353.911044]  [<c0467a9b>] ? 
> ondemand_readahead+0x15b/0x180
> Mar 12 01:16:21 coyote kernel: [10353.911047]  [<c0467b38>] ? 
> page_cache_async_readahead+0x78/0x90
> Mar 12 01:16:21 coyote kernel: [10353.911050]  [<c0461434>] ? 
> generic_file_aio_read+0x314/0x670
> Mar 12 01:16:21 coyote kernel: [10353.911058]  [<c048a011>] ? 
> do_sync_read+0xd1/0x110
> Mar 12 01:16:21 coyote kernel: [10353.911061]  [<c04133a3>] ? 
> lapic_next_event+0x13/0x20
> Mar 12 01:16:21 coyote kernel: [10353.911065]  [<c043c3c0>] ? 
> autoremove_wake_function+0x0/0x50
> Mar 12 01:16:21 coyote kernel: [10353.911069]  [<c0447c4b>] ? 
> tick_program_event+0x2b/0x40
> Mar 12 01:16:21 coyote kernel: [10353.911072]  [<c0440086>] ? 
> hrtimer_interrupt+0xd6/0x220
> Mar 12 01:16:21 coyote kernel: [10353.911075]  [<c048aac9>] ? 
> vfs_read+0x99/0x140
> Mar 12 01:16:21 coyote kernel: [10353.911077]  [<c0458e20>] ? 
> audit_syscall_exit+0x1e0/0x3e0
> Mar 12 01:16:21 coyote kernel: [10353.911081]  [<c0489f40>] ? 
> do_sync_read+0x0/0x110
> Mar 12 01:16:21 coyote kernel: [10353.911083]  [<c048ac2d>] ? 
> sys_read+0x3d/0x70
> Mar 12 01:16:21 coyote kernel: [10353.911085]  [<c040336d>] ? 
> sysenter_do_call+0x12/0x21
> Mar 12 01:16:21 coyote kernel: [10353.911088] Code: ff 75 d0 9d 89 e0 25 00 f0 
> ff ff 83 68 14 01 f6 40 08 08 0f 85 30 02 00 00 
> 8b 1e 89 f2 8b 46 08 8b 7e 10 f6 c7 40 74 03 8b 56 0c <8b> 4a 04 31 d2 85 ff 
> 0f 95 c2 83 c0 01 09 c2 31 c0 85 c9 0f 95
> Mar 12 01:16:21 coyote kernel: [10353.911112] EIP: [<c046520b>] 
> get_page_from_freelist+0x24b/0x4c0 SS:ESP 0068:c0b35cfc
> Mar 12 01:16:21 coyote kernel: [10353.911117] ---[ end trace 8d9559cb0f5d9d82 
> ]---
> ========================
> 
> And it was accompanied by some sort of an alert mechanism in F10 that said 
> 'KDE Write Daemon' in a series of 22 stacked vertically boxes, and duplicated 
> many but not all, of the above messages.  They weren't clipboardable. :(

Sounds like you've found a bug of a different sort there : ) Might be
handy to let the author of that app know...

-- 
Sitsofe | http://sits@sucs.org/~sits/
