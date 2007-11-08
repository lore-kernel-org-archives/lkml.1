Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXKHAfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXKHAfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXKHAff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:35:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbXKHAfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:35:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Date: Thu, 8 Nov 2007 01:52:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Willy Tarreau <w@1wt.eu>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
References: <1193918202.8439.7.camel@rukbat> <1194387459.5205.2.camel@rukbat> <1194472374.7176.4.camel@rukbat>
In-Reply-To: <1194472374.7176.4.camel@rukbat>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711080152.34769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of November 2007, Romano Giannetti wrote:
> 
> On Tue, 2007-11-06 at 23:17 +0100, Romano Giannetti wrote:
> > Well, I started bisecting it. It will be a long shot, I suspect...
> 
> Well, I spent the last 36 hours (more or less) trying to bisect the SD
> problem. The method I used was to insert the card, umount it, and make 8 dd
> in a row; the kernel is "bad" if they differs, "good" if they are the same. 
> 
> I could not finish the bisect. The last pair good/bad were:
> 
> bad:   [7aeacf982203fb4dea2f3434eefdc268cfd5d6d9] 
>        [BLOCK] blk_rq_map_sg: force clear termination bit
> good:  [e38f981758118d829cd40cfe9c09e3fa81e422aa] 
>        exportfs: update documentation
> 
> The problem to conclude the bisect is that there is a whole series of
> commits, named [SG] something, that seems to matter; but my three try of a
> commit between the previous two ended with a MMC layer not working with this
> oops:

Can you please update the Bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=9286 with this information?

 
> [   81.738991] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> [   81.739003] printing eip: c01db437 *pde = 00000000 
> [   81.739010] Oops: 0000 [#1] SMP 
> [   81.739016] Modules linked in: mmc_block binfmt_misc rfcomm l2cap bluetooth ppdev i915 drm acpi_cpufreq cpufreq_conservative cpufreq_stats cpufreq_ondemand freq_table cpufreq_userspace cpufreq_powersave dock container sbs sbshc af_packet nls_iso8859_1 nls_cp437 vfat fat nls_utf8 ntfs dm_crypt dm_mod sbp2 parport_pc lp parport fuse snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss iTCO_wdt iTCO_vendor_support serio_raw sdhci snd_seq_midi snd_rawmidi snd_seq_midi_event psmouse pcspkr mmc_core snd_seq snd_timer snd_seq_device snd soundcore video output battery snd_page_alloc ac button intel_agp agpgart evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_piix ehci_hcd ata_generic ohci1394 uhci_hcd ieee1394 libata scsi_mod generic usbcore r8169 thermal processor fan
> [   81.739122] 
> [   81.739127] Pid: 6075, comm: mmcqd Not tainted (2.6.23-bisect #19)
> [   81.739132] EIP: 0060:[<c01db437>] EFLAGS: 00010246 CPU: 0
> [   81.739141] EIP is at blk_rq_map_sg+0xd7/0x190
> [   81.739145] EAX: 03619000 EBX: 00000000 ECX: c3464198 EDX: c3464698
> [   81.739150] ESI: 0361a000 EDI: 00001000 EBP: cb82fe24 ESP: cb82fdec
> [   81.739154]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   81.739159] Process mmcqd (pid: 6075, ti=cb82e000 task=cb2a5550 task.ti=cb82e000)
> [   81.739163] Stack: 00000292 c366c530 cb839a70 00002000 0361b000 c3464698 00000001 00000001 
> [   81.739176]        00000000 c34e0848 01ae4698 c33ef2b0 c33ef2b0 cb2ec870 cb82fe3c f8e81e6c 
> [   81.739188]        00200200 c3342580 c33ef2b0 cb2ec870 cb82ffb8 f8e816f9 7898775f 5f6f5965 
> [   81.739200] Call Trace:
> [   81.739204]  [<c01052fa>] show_trace_log_lvl+0x1a/0x30
> [   81.739213]  [<c01053c1>] show_stack_log_lvl+0xb1/0xe0
> [   81.739220]  [<c01054b1>] show_registers+0xc1/0x1d0
> [   81.739226]  [<c01056da>] die+0x11a/0x230
> [   81.739232]  [<c011d7e9>] do_page_fault+0x269/0x5f0
> [   81.739239]  [<c02f3eea>] error_code+0x72/0x78
> [   81.739247]  [<f8e81e6c>] mmc_queue_map_sg+0x2c/0xe0 [mmc_block]
> [   81.739258]  [<f8e816f9>] mmc_blk_issue_rq+0x199/0x750 [mmc_block]
> [   81.739267]  [<f8e821a0>] mmc_queue_thread+0x80/0xf0 [mmc_block]
> [   81.739275]  [<c013d862>] kthread+0x42/0x70
> [   81.739282]  [<c0104ee7>] kernel_thread_helper+0x7/0x10
> [   81.739289]  =======================
> [   81.739292] Code: f0 89 45 d8 8b 01 2b 05 80 aa 67 c0 c1 f8 02 69 c0 c5 4e ec c4 c1 e0 0c 03 41 08 39 45 d8 0f 84 8e 00 00 00 f6 03 02 74 52 31 db <8b> 03 c7 43 0c 00 00 00 00 c7 43 08 00 00 00 00 83 e0 03 0b 01 
> [   81.739358] EIP: [<c01db437>] blk_rq_map_sg+0xd7/0x190 SS:ESP 0068:cb82fdec
> 
> It seems to me that the two commits:
> 
> [BLOCK] blk_rq_map_sg: force clear termination bit
> [BLOCK] Don't clear sg_dma_len/addr() in blk_rq_map_sg()
> 
> have the potential to fix the aforementioned oops, but in a way that create
> for the mmc layer the problem reported. It's just gut feeling, I have not
> the knowledge of the kernel needed to debug this, but this comment:
> 
> +	 * If the driver previously mapped a shorter
> +	 * list, we could see a termination bit
> +	 * prematurely unless it fully inits the sg
> +	 * table on each mapping. We KNOW that there
> +	 * must be more entries here or the driver
> +	 * would be buggy, so force clear the
> +	 * termination bit to avoid doing a full
> +	 * sg_init_table() in drivers for each command.
> +	 */
> 
> rang a bell. When the bug occurs, it seems that some random page is mapped
> into the device, so that... maybe the list was not supposed to continue in
> this case? 
> 
> Well, I hope it can helps someone to find the bug. I am available to
> test/try whatever patches you send me. 
> 
> 	 Romano 
> 
> Complete git bisect log:
> 
> git-bisect start
> # bad: [2655e2cee2d77459fcb7e10228259e4ee0328697] ata_piix: Add additional PCI identifier for 40 wire short cable
> git-bisect bad 2655e2cee2d77459fcb7e10228259e4ee0328697
> # good: [bbf25010f1a6b761914430f5fca081ec8c7accd1] Linux 2.6.23
> git-bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1
> # good: [f4921aff5b174349bc36551f142a5dbac782ea3f] Merge git://git.linux-nfs.org/pub/linux/nfs-2.6
> git-bisect good f4921aff5b174349bc36551f142a5dbac782ea3f
> # good: [9cf52b2921fbe62566b6b2ee79f71203749c9e5e] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6
> git-bisect good 9cf52b2921fbe62566b6b2ee79f71203749c9e5e
> # bad: [a98ce5c6feead6bfedefabd46cb3d7f5be148d9a] Fix synchronize_irq races with IRQ handler
> git-bisect bad a98ce5c6feead6bfedefabd46cb3d7f5be148d9a
> # good: [e9a404580ccaeb31dd2a976f9929c4f9eb6f3540] nfs: Fix build break with CONFIG_NFS_V4=n
> git-bisect good e9a404580ccaeb31dd2a976f9929c4f9eb6f3540
> # good: [668f895a85b0c3a62a690425145f13dabebebd7a] [NET]: Hide the queue_mapping field inside netif_subqueue_stopped
> git-bisect good 668f895a85b0c3a62a690425145f13dabebebd7a
> # bad: [ba1c28a94322865457ad59f80474615156065123] Merge branch 'sg' of git://git.kernel.dk/linux-2.6-block
> git-bisect bad ba1c28a94322865457ad59f80474615156065123
> # good: [e38f981758118d829cd40cfe9c09e3fa81e422aa] exportfs: update documentation
> git-bisect good e38f981758118d829cd40cfe9c09e3fa81e422aa
> # bad: [7aeacf982203fb4dea2f3434eefdc268cfd5d6d9] [BLOCK] blk_rq_map_sg: force clear termination bit
> git-bisect bad 7aeacf982203fb4dea2f3434eefdc268cfd5d6d9
