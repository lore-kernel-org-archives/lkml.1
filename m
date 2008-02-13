Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbYBMWky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbYBMWky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYBMWko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:40:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44147 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYBMWkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:40:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Date: Wed, 13 Feb 2008 23:39:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Garzik <jgarzik@pobox.com>, LKML <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132339.19764.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thursday, 7 of February 2008, Thomas Gleixner wrote:
> current mainline triggers:

Has the issue been fixed in the meantime?

> WARNING: at /home/tglx/work/kernel/x86/linux-2.6/arch/x86/mm/highmem_32.c:52 kmap_atomic_prot+0xe5/0x19b()
> Modules linked in: ahci(+) sata_sil libata sd_mod scsi_mod raid1 ext3 jbd ehci_hcd ohci_hcd uhci_hcd
> Pid: 0, comm: swapper Not tainted 2.6.24 #173
>  [<c0126b60>] warn_on_slowpath+0x41/0x51
>  [<c011c5eb>] ? __enqueue_entity+0x9c/0xa4
>  [<c011c717>] ? enqueue_entity+0x124/0x13b
>  [<c011cedb>] ? enqueue_task_fair+0x41/0x4c
>  [<c032ce88>] ? _spin_lock_irqsave+0x14/0x2e
>  [<c012e885>] ? lock_timer_base+0x1f/0x3e
>  [<c011ad6d>] kmap_atomic_prot+0xe5/0x19b
>  [<c011ae37>] kmap_atomic+0x14/0x16
>  [<f88ea218>] ata_scsi_rbuf_get+0x1e/0x2c [libata]
>  [<f88ea821>] atapi_qc_complete+0x23f/0x289 [libata]
>  [<f88e3d00>] __ata_qc_complete+0x8e/0x93 [libata]
>  [<f88e3fc7>] ata_qc_complete+0x115/0x128 [libata]
>  [<f88e8d47>] ata_qc_complete_multiple+0x86/0xa0 [libata]
>  [<f8841a5d>] ahci_interrupt+0x370/0x40d [ahci]
>  [<c01512c6>] handle_IRQ_event+0x21/0x48
>  [<c01521ca>] handle_edge_irq+0xc9/0x10a
>  [<c0152101>] ? handle_edge_irq+0x0/0x10a
>  [<c0107518>] do_IRQ+0x8b/0xb7
>  [<c01055db>] common_interrupt+0x23/0x28
>  [<c032007b>] ? init_chipset_cmd64x+0xb/0x93
>  [<c010316e>] ? mwait_idle_with_hints+0x39/0x3d
>  [<c0103172>] ? mwait_idle+0x0/0xf
>  [<c010317f>] mwait_idle+0xd/0xf
>  [<c0103761>] cpu_idle+0xb0/0xe4
>  [<c031b509>] rest_init+0x5d/0x5f
> 
> This is not a new problem. It was pointed out some time ago already,
> but now the WARN_ON() finally made it into mainline :)
> 
> The fix is not obvious, as this code seems to be called from various
> call sites.
> 
> Thanks,
> 	tglx
