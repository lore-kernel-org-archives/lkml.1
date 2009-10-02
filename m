Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZJBCwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZJBCwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZJBCwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:52:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56491 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZJBCwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 22:52:30 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost> <4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 01 Oct 2009 19:52:21 -0700
In-Reply-To: <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk> (Alan Cox's message of "Tue\, 29 Sep 2009 23\:52\:32 +0100")
Message-ID: <m163ayzevu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> As it stands today ftdi_sio does indeed call tty_flip_buffer_push from
>> interrupt context with low_latency set and that is obviously incorrect,
>> right?
>
> It seems to do it from a work queue - or did I miss a case ?

ftdi_sio crash quite regularly for me with 2.6.31.

With a bunch of nasties like:
BUG: scheduling while atomic: swapper/0/0x00010000
bad: scheduling from the idle thread!

I don't know if I have a good backtrace as things
scrolled away faster than they were captured
but the code below looks like it may be.

Eric

BUG: scheduling while atomic: swapper/0/0x00010000
Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp bnep l2cap bluetooth sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_mirror dm_region_hash dm_log dm_multipath dm_mod uinput kvm_amd kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd amd64_edac_mod firewire_ohci firewire_core soundcore i2c_nforce2 k8temp sg edac_core hwmon pcspkr sata_sil24 pata_amd snd_page_alloc e1000e forcedeth crc_itu_t i2c_core ftdi_sio usbserial ata_generic pata_acpi sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
CPU 0:
Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp bnep l2cap bluetooth sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_mirror dm_region_hash dm_log dm_multipath dm_mod uinput kvm_amd kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd amd64_edac_mod firewire_ohci firewire_core soundcore i2c_nforce2 k8temp sg edac_core hwmon pcspkr sata_sil24 pata_amd snd_page_alloc e1000e forcedeth crc_itu_t i2c_core ftdi_sio usbserial ata_generic pata_acpi sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.31-185494.2008.AroraEbiederm.fc11.x86_64 #1  
RIP: 0010:[<ffffffff8102c86c>]  [<ffffffff8102c86c>] native_safe_halt+0x6/0x8
RSP: 0018:ffffffff81541e48  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81541e48 RCX: 0000000003000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81541e58
RBP: ffffffff8100c7ce R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffff880038d0fef8 R12: ffffffff81073a1f
R13: ffffffff81541dd8 R14: ffffffff8105c8d7 R15: ffffffff81541e38
FS:  00007fe289d71910(0000) GS:ffff8800017ba000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000404070 CR3: 000000003b87d000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff81014126>] ? default_idle+0x51/0x8b
 [<ffffffff81014265>] ? c1e_idle+0x105/0x120
 [<ffffffff8100ae15>] ? cpu_idle+0xb0/0xf3
 [<ffffffff81392135>] ? rest_init+0x79/0x8f
 [<ffffffff815c8fae>] ? start_kernel+0x3dc/0x3fd
 [<ffffffff815c82d4>] ? x86_64_start_reservations+0xbb/0xd6
 [<ffffffff815c83f4>] ? x86_64_start_kernel+0x105/0x128
bad: scheduling from the idle thread!
Pid: 0, comm: swapper Not tainted 2.6.31-185494.2008.AroraEbiederm.fc11.x86_64 #1
Call Trace:
 <IRQ>  [<ffffffff81041261>] dequeue_task_idle+0x37/0x5a
 [<ffffffff81040a23>] dequeue_task+0xce/0xf0
 [<ffffffff81040a7c>] deactivate_task+0x37/0x56
 [<ffffffff813a4fb7>] schedule+0x13d/0x6f3
 [<ffffffff81042b82>] ? enqueue_task_fair+0xdf/0x13c
 [<ffffffff810404df>] ? enqueue_task+0x6f/0x91
 [<ffffffff813a5e87>] __mutex_lock_common+0x12f/0x1aa
 [<ffffffff813a5f29>] __mutex_lock_slowpath+0x27/0x3d
 [<ffffffff813a5c3d>] mutex_lock+0x25/0x53
 [<ffffffff81253ff9>] tty_unthrottle+0x29/0x6d
 [<ffffffff8125298a>] reset_buffer_flags+0xe8/0x105
 [<ffffffff812529cb>] n_tty_flush_buffer+0x24/0x97
 [<ffffffff8125367b>] n_tty_receive_buf+0xc3d/0xe72
 [<ffffffff8129b0fd>] ? usb_hcd_submit_urb+0x888/0x943
 [<ffffffff81254e83>] ? tty_ldisc_try+0x53/0x71
 [<ffffffff81255f85>] flush_to_ldisc+0x116/0x1bd
 [<ffffffff8125608a>] tty_flip_buffer_push+0x5e/0x85
 [<ffffffffa010a0ab>] ftdi_process_read+0x481/0x627 [ftdi_sio]
 [<ffffffffa0001aea>] ? timer_action+0x63/0x79 [ehci_hcd]
 [<ffffffffa010a480>] ftdi_read_bulk_callback+0x22f/0x25a [ftdi_sio]
 [<ffffffff81040e89>] ? complete+0x54/0x73
 [<ffffffffa000597f>] ? ehci_irq+0x351/0x391 [ehci_hcd]
 [<ffffffff81299a32>] usb_hcd_giveback_urb+0x9b/0xe5
 [<ffffffffa00010f9>] ehci_urb_done+0x91/0xbc [ehci_hcd]
 [<ffffffffa00027f3>] qh_completions+0x42a/0x4ca [ehci_hcd]
 [<ffffffffa0002938>] ehci_work+0xa5/0x7ab [ehci_hcd]
 [<ffffffffa00db90f>] ? nv_swncq_interrupt+0x6a3/0x6d1 [sata_nv]
 [<ffffffffa000597f>] ehci_irq+0x351/0x391 [ehci_hcd]
 [<ffffffff81073641>] ? clocksource_read+0x1d/0x33
 [<ffffffff81073a1f>] ? getnstimeofday+0x69/0xd3
 [<ffffffff8129933c>] usb_hcd_irq+0x4d/0xa1
 [<ffffffff810a2553>] handle_IRQ_event+0x6a/0x13f
 [<ffffffff810a4613>] handle_fasteoi_irq+0x90/0xe1
 [<ffffffff8100eb5a>] handle_irq+0x95/0xb7
 [<ffffffff8100df49>] do_IRQ+0x6a/0xe0
 [<ffffffff8100c7d3>] ret_from_intr+0x0/0x11
 <EOI>  [<ffffffff8102c86c>] ? native_safe_halt+0x6/0x8
 [<ffffffff81014126>] ? default_idle+0x51/0x8b
 [<ffffffff81014265>] ? c1e_idle+0x105/0x120
 [<ffffffff8100ae15>] ? cpu_idle+0xb0/0xf3
 [<ffffffff81392135>] ? rest_init+0x79/0x8f
 [<ffffffff815c8fae>] ? start_kernel+0x3dc/0x3fd
 [<ffffffff815c82d4>] ? x86_64_start_reservations+0xbb/0xd6
 [<ffffffff815c83f4>] ? x86_64_start_kernel+0x105/0x128
BUG: scheduling while atomic: swapper/0/0x00010000

