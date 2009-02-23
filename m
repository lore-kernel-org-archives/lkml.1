Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZBWV04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZBWV04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZBWV0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:26:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:36401 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZBWV0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:26:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eyvr9/5V57cyhV4CVi6meXC3QafdDJdWU13bQ1KFPz/IhmFEPtaBNo/p0gjFuxx98o
         dajo1VI17jylt8HMoThjHYsaixVawclWbrVoHbD5zsiboIyfVQqgClpzZHfGK9nSIus9
         Dk+hnNotw3YT6+4EKSpy40N7kQRpeaIGLLwp8=
Date: Mon, 23 Feb 2009 22:26:15 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: iwlagn warning in 2.6.29-rc6
Message-ID: <20090223212615.GA5047@Pilar.Speedport_W_303V_Typ_A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just got this warning in my Vaio laptop:

------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1254 iwl_tx_cmd_complete+0x28a/0x2e0()
Hardware name: VGN-FZ240E
wrong command queue 31, sequence 0x7FFF readp=241 writep=241
Modules linked in: usbhid nvram snd_hda_codec_idt snd_hda_intel snd_hda_codec uvcvideo snd_hwdep snd_pcm iwlagn videodev snd_timer sky2 v4l1_compat v4l2_compat_ioctl32 evdev sg i2c_i801 snd_page_alloc sr_mod ata_piix ahci libata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.29-rc6 #37
Call Trace:
 <IRQ>  [<ffffffff8023d850>] warn_slowpath+0xd0/0x130
 [<ffffffff8025072d>] ? queue_work_on+0x4d/0x60
 [<ffffffff802508da>] ? queue_work+0x1a/0x20
 [<ffffffff8053bb70>] ? ieee80211_sta_rx_mgmt+0xc0/0xf0
 [<ffffffff80540f45>] ? ieee80211_invoke_rx_handlers+0x12c5/0x1650
 [<ffffffff80233530>] ? enqueue_task_fair+0x190/0x2d0
 [<ffffffff8022ecc0>] ? enqueue_task+0x50/0x60
 [<ffffffff8025c049>] ? getnstimeofday+0x59/0xe0
 [<ffffffff80234c24>] ? find_busiest_group+0x234/0x760
 [<ffffffff8041eb3a>] iwl_tx_cmd_complete+0x28a/0x2e0
 [<ffffffffa0124245>] iwl_rx_handle+0x115/0x4a0 [iwlagn]
 [<ffffffffa01249ef>] iwl_irq_tasklet+0x41f/0xb30 [iwlagn]
 [<ffffffff8025c049>] ? getnstimeofday+0x59/0xe0
 [<ffffffff80242c39>] tasklet_action+0x69/0xf0
 [<ffffffff80243784>] __do_softirq+0x94/0x160
 [<ffffffff8020d57c>] call_softirq+0x1c/0x30
 [<ffffffff8020ef35>] do_softirq+0x45/0x90
 [<ffffffff80243435>] irq_exit+0x75/0xa0
 [<ffffffff8020f196>] do_IRQ+0x86/0x110
 [<ffffffff8020ce53>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff803a0322>] ? acpi_idle_enter_bm+0x2bf/0x344
 [<ffffffff803a0318>] ? acpi_idle_enter_bm+0x2b5/0x344
 [<ffffffff802587cf>] ? notifier_call_chain+0x3f/0x80
 [<ffffffff80455345>] ? cpuidle_idle_call+0xa5/0x100
 [<ffffffff8020b492>] ? cpu_idle+0x62/0xc0
 [<ffffffff80549c7c>] ? rest_init+0x5c/0x70
---[ end trace 281a546e35661751 ]---

The wireless connection still seems to be good after this (I've
found this warning after a curious look in the dmesg), but I
thought I should send the warning to lkml just in case it has
a deeper meaning to people out there.

The card is this one,
Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)

I can provide the whole dmesg output if needed too.
