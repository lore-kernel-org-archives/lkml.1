Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbXK3V6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbXK3V6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbXK3V62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:58:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:19297 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbXK3V6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a1cpfKdbhD01/KcyrqMhZEBmdJZ6SdaR3R0FZO1dnEMC0xyC5sZ8T2wJqsl3Abv561ZE133COj9NAoLrrQAKHE/EMcBvF9jCdftS7To3rmoyFCsCkGcmoPgUTqsbKeGMUzcbGcLgSuGuc7w4EN4jOfejuZMs/t++6e1p+vRMH6o=
Message-ID: <5a4c581d0711301358j12514debs2803736f70725b2c@mail.gmail.com>
Date: Fri, 30 Nov 2007 22:58:23 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Meelis Roos" <mroos@linux.ee>
Subject: Re: ata4294967295: failed to start port (errno=-19)
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.SOC.4.64.0711301433130.13468@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
	 <20071128200716.14eccfdd@the-village.bc.nu>
	 <Pine.SOC.4.64.0711301433130.13468@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2007 1:34 PM, Meelis Roos <mroos@linux.ee> wrote:
> > Can you stick a stack trace in at that point ? That would help diagnose
> > it a great deal quicker.
>
> Finally done - found out hard way that BUG() is too bad and
> dump_st5ack() suits me better.
>
> libata version 3.00 loaded.
> Pid: 661, comm: modprobe Not tainted 2.6.24-rc3 #3
>  [<d48cac80>] ata_host_start+0xf0/0x140 [libata]
>  [<d48d5f2e>] ata_pci_init_one+0xee/0x2a0 [libata]
>  [<c01a6077>] sysfs_create_link+0x77/0x100
>  [<d4825037>] pacpi_init_one+0x17/0x20 [pata_acpi]
>  [<c01d64e6>] pci_device_probe+0x56/0x80
>  [<c022dfd7>] driver_probe_device+0x87/0x190
>  [<c02b2191>] klist_next+0x51/0xb0
>  [<c022e216>] __driver_attach+0x76/0x80
>  [<c022d3ea>] bus_for_each_dev+0x3a/0x60
>  [<c022de56>] driver_attach+0x16/0x20
>  [<c022e1a0>] __driver_attach+0x0/0x80
>  [<c022d7ab>] bus_add_driver+0x8b/0x1e0
>  [<c01d667c>] __pci_register_driver+0x4c/0x90
>  [<c0139231>] sys_init_module+0x121/0x1550
>  [<c014eabf>] vma_prio_tree_insert+0x1f/0x50
>  [<d48d12f0>] ata_std_prereset+0x0/0x160 [libata]
>  [<c0155648>] do_mmap_pgoff+0x298/0x320
>  [<c0104086>] syscall_call+0x7/0xb
>  [<c02b0000>] packet_setsockopt+0xf0/0x3b0
>  =======================
> ata4294967295: failed to start port (errno=-19)

Mine is slightly different - I just put dump_stack();
 before the ata_port_printk in libata-core.c:

PCI: Setting latency timer of device 0000:00:1f.2 to 64
Pid: 364, comm: insmod Not tainted 2.6.24-rc3-git5 #5
 [<c010448a>] show_trace_log_lvl+0x1a/0x2f
 [<c0104df7>] show_trace+0x12/0x14
 [<c010568a>] dump_stack+0x6a/0x70
 [<c027c36b>] ata_host_start+0xb0/0x122
 [<c028649f>] ata_pci_init_one+0xd3/0x252
 [<f882103a>] pacpi_init_one+0x1c/0x1e [pata_acpi]
 [<c01f298d>] pci_device_probe+0x39/0x5b
 [<c0254a87>] driver_probe_device+0xe8/0x168
 [<c0254c2c>] __driver_attach+0x74/0xab
 [<c0253f7f>] bus_for_each_dev+0x36/0x5b
 [<c02548d3>] driver_attach+0x19/0x1b
 [<c025429e>] bus_add_driver+0x73/0x1aa
 [<c0254e19>] driver_register+0x67/0x6c
 [<c01f2aef>] __pci_register_driver+0x56/0x83
 [<f8826017>] pacpi_init+0x17/0x19 [pata_acpi]
 [<c01390e5>] sys_init_module+0x1278/0x1391
 [<c0103df2>] sysenter_past_esp+0x5f/0xa5
 =======================
ata4294967295: failed to start port (errno=-19)

--alessandro

 "Damaged people are dangerous. They know they can survive."

   (Anna Barton/Juliette Binoche, 'Damage')
