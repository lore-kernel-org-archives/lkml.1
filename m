Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZALVQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZALVQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZALVQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:16:27 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:58165 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZALVQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:16:26 -0500
Date: Mon, 12 Jan 2009 16:16:16 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI hotplug panic with current git head
In-reply-to: <1231604250.3642.33.camel@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1231604250.3642.33.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is on an IBM Maia system with the calgary IOMMU enabled. It's a
> fatal boot up panic.
> 

James,
A guided bisect...
Please let me know which of these fail

a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2 is 2.6.29 at ACPI merge
efcb3cf7f00c3c424db012380a8a974c2676a3c8 is 2.6.29 before ACPI merge
ec9f168fcc344d2ffec1c8c822076bf22dab5c33 is 2.6.28 with most ACPI
e8443c358c34f3fe65236e24147ddf0cd0e61b08 is 2.6.28 plus just ACPICA


Please test the "2.6.28+ACPICA" one first.
If it fails, we are close so you can skip the others above
and bisect between that and 2.6.28.

thanks,
-Len

> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> IP: [<ffffffff8039646f>] acpi_ns_get_next_node+0xb/0x3c
> PGD 0 
> Oops: 0000 [#1] SMP 
> last sysfs file: 
> CPU 0 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.28 #1
> RIP: 0010:[<ffffffff8039646f>]  [<ffffffff8039646f>] acpi_ns_get_next_node+0xb/0x3c
> RSP: 0018:ffff88007f87fd30  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff8037d260 R09: ffff88007f87fdfc
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff80742040(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000010 CR3: 0000000000201000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff88007f87e000, task ffff88007f875040)
> Stack:
>  0000000000000000 ffffffff803964f5 ffff88007f81b728 0000000000001001
>  ffff88007f87fdfc ffffffff8037d260 0000000600000001 0000000000000000
>  ffffffff8037d260 0000000000000000 0000000000000001 ffff88007f87fdfc
> Call Trace:
>  [<ffffffff803964f5>] acpi_ns_walk_namespace+0x55/0x138
>  [<ffffffff8037d260>] is_pci_dock_device+0x0/0x20
>  [<ffffffff8037d260>] is_pci_dock_device+0x0/0x20
>  [<ffffffff80394a9e>] acpi_walk_namespace+0x5f/0x83
>  [<ffffffff8037dd33>] detect_ejectable_slots+0x53/0x70
>  [<ffffffff8037de38>] add_bridge+0xe8/0x200
>  [<ffffffff80394aaa>] acpi_walk_namespace+0x6b/0x83
>  [<ffffffff803a4ad1>] acpi_pci_register_driver+0x48/0x61
>  [<ffffffff806fc5df>] acpiphp_init+0x0/0x58
>  [<ffffffff806fc732>] acpiphp_glue_init+0x4c/0x5a
>  [<ffffffff806fc616>] acpiphp_init+0x37/0x58
>  [<ffffffff8020903b>] _stext+0x3b/0x180
>  [<ffffffff80312598>] create_proc_entry+0x58/0xa0
>  [<ffffffff802815d1>] register_irq_proc+0xc1/0xe0
>  [<ffffffff806db64b>] kernel_init+0x152/0x1ac
>  [<ffffffff8023d970>] finish_task_switch+0x0/0x110
>  [<ffffffff8020ca7a>] child_rip+0xa/0x20
>  [<ffffffff8020c47c>] restore_args+0x0/0x30
>  [<ffffffff806db4f9>] kernel_init+0x0/0x1ac
>  [<ffffffff8020ca70>] child_rip+0x0/0x20
> Code: 89 c2 48 8b 00 48 85 c0 75 f5 48 8b 45 00 48 89 02 44 88 65 09 48 89 5d 00 31 c0 5b 5d 41 5c c3 53 48 85 d2 89 fb 48 89 d7 75 06 <48> 8b 56 10 eb 08 e8 73 f1 ff ff 48 89 c2 85 db 74 1a eb 13 0f 
> RIP  [<ffffffff8039646f>] acpi_ns_get_next_node+0xb/0x3c
>  RSP <ffff88007f87fd30>
> CR2: 0000000000000010
> ---[ end trace a7919e7f17c0a725 ]---
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
