Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbXEPQ3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbXEPQ3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbXEPQ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:29:40 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57055 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758123AbXEPQ3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:29:40 -0400
Date: Wed, 16 May 2007 12:29:37 -0400
To: Roger Heflin <rheflin@atipa.com>
Cc: NFS <nfs@lists.sourceforge.net>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] Kernel BUG at mm/slab.c:2380 on NFS server in nfsd (2.6.21.1)
Message-ID: <20070516162937.GC9895@fieldses.org>
References: <464B0D47.6070509@atipa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B0D47.6070509@atipa.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 08:55:19AM -0500, Roger Heflin wrote:
> Running bonnie over nfs on a RHEL4.4 client against a 2.6.21.1 server
> got me this crash after about 4 hours of running on the server:
> 
> This was running lvm -> ext3 -> nfs ---- nfsclient (RHEL4.4).

Yipes.  Has this happened only once, or do you have a way to reliably
reproduce it?

Is it a new problem?  (And, if so, what changed?)

> May 15 21:10:31 vault1 kernel: ------------[ cut here ]------------
> May 15 21:10:31 vault1 kernel: kernel BUG at mm/slab.c:2380!

That's the check_spinlock_acquired() in cache_alloc_refill().  What
causes that to fail?

> May 15 21:10:31 vault1 kernel: invalid opcode: 0000 [1] SMP
> May 15 21:10:31 vault1 kernel: CPU 0
> May 15 21:10:31 vault1 kernel: Modules linked in: qla2xxx nfsd exportfs 
> lockd nfs_acl sunrpc hidp l2cap bluetooth ipv6 cpufreq_ondemand jfs 
> dm_mirror dm_multipath dm_mod video sbs i2c_ec dock button battery 
> asus_acpi ac lp snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy 
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device sg snd_pcm_oss 
> floppy snd_mixer_oss snd_pcm cfi_cmdset_0002 cfi_util mtdpart snd_timer 
> jedec_probe cfi_probe gen_probe snd ck804xrom sata_nv mtdcore chipreg 
> i2c_nforce2 soundcore map_funcs libata snd_page_alloc pcspkr i2c_core 
> k8temp hwmon forcedeth ohci1394 ieee1394 parport_pc ide_cd parport cdrom 
> serio_raw scsi_transport_fc shpchp megaraid_mbox sd_mod scsi_mod 
> megaraid_mm ext3 jbd ehci_hcd ohci_hcd uhci_hcd
> May 15 21:10:31 vault1 kernel: Pid: 4256, comm: nfsd Not tainted 2.6.21.1 #1
> May 15 21:10:31 vault1 kernel: RIP: 0010:[<ffffffff8025a710>] 
> [<ffffffff8025a710>] cache_alloc_refill+0xe6/0x1f3
> May 15 21:10:31 vault1 kernel: RSP: 0018:ffff81021dead6d0  EFLAGS: 00010002
> May 15 21:10:31 vault1 kernel: RAX: 0000000000000001 RBX: 
> ffff81012211d960 RCX: ffff810120013040
> May 15 21:10:31 vault1 kernel: RDX: 000000000000000e RSI: 
> ffff810139020000 RDI: ffff810120013040

There wasn't a backtrace?

--b.
