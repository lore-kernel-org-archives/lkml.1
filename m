Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYHRLyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYHRLyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHRLxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 07:53:55 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54396 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062AbYHRLxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 07:53:54 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 07:53:53 EDT
Date: Mon, 18 Aug 2008 13:07:07 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: kernel BUG at block/cfq-iosched.c:1239
Message-ID: <20080818110707.GA33148@gandalf.sssup.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I hit the following:

Aug 16 22:40:59 helm kernel: ------------[ cut here ]------------
Aug 16 22:40:59 helm kernel: kernel BUG at block/cfq-iosched.c:1239!
Aug 16 22:40:59 helm kernel: invalid opcode: 0000 [1] PREEMPT SMP 
Aug 16 22:40:59 helm kernel: CPU 1 
Aug 16 22:40:59 helm kernel: Modules linked in: usb_storage tun i915 drm cpufreq_userspace kvm_intel kvm fan ipv6 acpi_cpufreq freq_table sbp2 loop arc4 ecb crypto_blkcipher snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq iwl3945 snd_timer snd_seq_device mac80211 snd cfg80211 ohci1394 soundcore sg ehci_hcd i2c_i801 dcdbas button thermal ieee1394 tg3 snd_page_alloc intel_agp sr_mod i2c_core ac processor battery libphy uhci_hcd evdev pcspkr psmouse cdrom
Aug 16 22:40:59 helm kernel: Pid: 12113, comm: dd Not tainted 2.6.27-rc1 #1
Aug 16 22:40:59 helm kernel: RIP: 0010:[<ffffffff8034a50d>]  [<ffffffff8034a50d>] cic_free_func+0x7d/0x90
Aug 16 22:40:59 helm kernel: RSP: 0018:ffff88006ce19e88  EFLAGS: 00010246
Aug 16 22:40:59 helm kernel: RAX: 0000000000000000 RBX: ffff88005c1f00a8 RCX: 0000000000000001
Aug 16 22:40:59 helm kernel: RDX: ffff8800010213c0 RSI: ffff88005c1f00a8 RDI: ffff88007dc85558
Aug 16 22:40:59 helm kernel: RBP: ffff88007dc85558 R08: 0000000000000000 R09: ffff8800011012c0
Aug 16 22:40:59 helm kernel: R10: 0000000000000002 R11: 0000000000000001 R12: ffff88007f141908
Aug 16 22:40:59 helm kernel: R13: 0000000002063000 R14: ffff88007f060000 R15: ffff88007f141908
Aug 16 22:40:59 helm kernel: FS:  0000000000000000(0000) GS:ffff88007f009480(0000) knlGS:0000000000000000
Aug 16 22:40:59 helm kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 16 22:40:59 helm kernel: CR2: 00007f65a36d3440 CR3: 0000000000201000 CR4: 00000000000026e0
Aug 16 22:40:59 helm kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 16 22:40:59 helm kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 16 22:40:59 helm kernel: Process dd (pid: 12113, threadinfo ffff88006ce18000, task ffff88007f141780)
Aug 16 22:40:59 helm kernel: Stack:  ffff88007f141780 ffff88005c1f0120 ffff88007dc85558 ffff88007f141908
Aug 16 22:40:59 helm kernel:  0000000002063000 ffffffff8034a54a ffff88007dc85558 ffff88007dc85558
Aug 16 22:40:59 helm kernel:  ffff88007f141780 ffffffff80342bb3 0000000000000011 ffffffff8023d725
Aug 16 22:40:59 helm kernel: Call Trace:
Aug 16 22:40:59 helm kernel:  [<ffffffff8034a54a>] ? cfq_free_io_context+0x2a/0x40
Aug 16 22:40:59 helm kernel:  [<ffffffff80342bb3>] ? put_io_context+0x63/0x90
Aug 16 22:40:59 helm kernel:  [<ffffffff8023d725>] ? do_exit+0x6c5/0x930
Aug 16 22:40:59 helm kernel:  [<ffffffff8023d9c3>] ? do_group_exit+0x33/0xa0
Aug 16 22:40:59 helm kernel:  [<ffffffff8020c4cb>] ? system_call_fastpath+0x16/0x1b
Aug 16 22:40:59 helm kernel: 
Aug 16 22:40:59 helm kernel: 
Aug 16 22:40:59 helm kernel: Code: 83 80 00 00 00 00 02 20 00 e8 e0 50 18 00 48 83 c4 08 48 8d bb 98 00 00 00 48 c7 c6 60 a5 34 80 5b 5d 41 5c 41 5d e9 23 c1 f2 ff <0f> 0b eb fe 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 
Aug 16 22:40:59 helm kernel: RIP  [<ffffffff8034a50d>] cic_free_func+0x7d/0x90
Aug 16 22:40:59 helm kernel:  RSP <ffff88006ce19e88>
Aug 16 22:40:59 helm kernel: ---[ end trace bc35e6676be9231f ]---

It happened while unplugging an USB stick with some processes
reading from it, on a 2.6.27-rc1, but I'm not able to reproduce it,
neither with the old kernel version nor with newer ones.

The only sequence I can imagine that can lead to that BUG() is the
following one:

(exiting task)			(exiting queue)
exit_io_context()
cfq_exit_io_context()
cfq_exit_single_io_context():

cfqd = cic->key;
/* cfqd contains the old value of cic->key */

				cfq_exit_queue():
				spin_lock_irq(q->queue_lock);
				__cfq_exit_single_io_context(cfqd, cic);
				/*
				 * cic->dead_key = cic->key;
				 * cic->key = NULL;
				 */
				spin_unlock_irq(q->queue_lock);

if (cfqd) {
q = cfqd->queue;
spin_lock_irqsave(q->queue_lock, flags);
__cfq_exit_single_io_context(cfqd, cic);
/*
 * cic->dead_key = cic->key; // cic->key == NULL
 * cic->key = NULL;
 */ 

When the last reference to ioc will be put, cic_free_func() will find
a NULL cic->dead_key.

All the (other) accesses to cic->key throughout the cfq code should be
protected by the fact that both in changed_ioprio() and cfq_cic_lookup()
the process is still active (and this implies that the ioc cannot be
exited) and the queue cannot be removed (it is still getting requests).

Is that race possible?  Can it be the cause of the BUG()?
