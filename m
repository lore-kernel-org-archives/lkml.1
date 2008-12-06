Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYLFNmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYLFNmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 08:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYLFNmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 08:42:43 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:19674 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbYLFNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 08:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d6H7yfKJqMaDYZiafpS4acKO6z/d9uYOozwAQmpTfKBBn0BWJ0AFNMaxWuDfuNatJH
         o1vPzQo8dVjTShxsOcLbS3PD6K6eG+liknDEz/NWdf5ZsLIplRvvVATJW88t5GqN/Qig
         y0Rv017lYgfjiOkG6FJFZY/HrORaPrDHuQgQg=
Message-ID: <a4423d670812060542u4c646891oc4db646b3f89b2ad@mail.gmail.com>
Date: Sat, 6 Dec 2008 16:42:40 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: linux-next: Tree for December 4
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200812061304.12216.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
	 <200812061304.12216.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/6 Mariusz Kozlowski <m.kozlowski@tuxland.pl>:
> =============================================================================
> BUG kmalloc-4096: Invalid object pointer 0xffff88007fb20010
> -----------------------------------------------------------------------------
>
> INFO: Slab 0xffffe20001beef00 objects=7 used=1 fp=0xffff88007fb21048 flags=0x40000000000020c3
> Pid: 1, comm: swapper Not tainted 2.6.28-rc7-next-20081204 #1
> Call Trace:
>  [<ffffffff802a4edd>] slab_err+0x9d/0xc0
>  [<ffffffff80218992>] save_stack_trace+0x22/0x40
>  [<ffffffff80260f57>] save_trace+0x37/0xa0
>  [<ffffffff80261027>] add_lock_to_list+0x67/0xf0
>  [<ffffffff80244c42>] __release_region+0x22/0xc0
>  [<ffffffff80264dac>] validate_chain+0xcdc/0x1200
>  [<ffffffff802a558b>] check_bytes_and_report+0x4b/0x100
>  [<ffffffff802a53f7>] slab_pad_check+0xe7/0x170
>  [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
>  [<ffffffff802a6c28>] __slab_free+0x258/0x380
>  [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
>  [<ffffffff802a6ee2>] kfree+0xb2/0x150
>  [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
>  [<ffffffff803c4f18>] serial8250_register_port+0x88/0x1f0
>  [<ffffffff804851d0>] serial_pnp_probe+0x1a0/0x220
>  [<ffffffff8039bfef>] match_device+0x2f/0x50
>  [<ffffffff8039c0a4>] pnp_device_probe+0x64/0xe0
>  [<ffffffff803ca4d6>] driver_probe_device+0x96/0x1b0
>  [<ffffffff803ca68c>] __driver_attach+0x9c/0xa0
>  [<ffffffff803ca5f0>] __driver_attach+0x0/0xa0
>  [<ffffffff803c98f3>] bus_for_each_dev+0x53/0x80
>  [<ffffffff803ca08b>] bus_add_driver+0x1cb/0x230
>  [<ffffffff803ca855>] driver_register+0x55/0x140
>  [<ffffffff8062e200>] serial8250_pnp_init+0x0/0x10
>  [<ffffffff8020903b>] _stext+0x3b/0x170
>  [<ffffffff8027b181>] register_irq_proc+0xc1/0xe0
>  [<ffffffff806119ad>] kernel_init+0x15d/0x1f0
>  [<ffffffff8020c9fa>] child_rip+0xa/0x20
>  [<ffffffff8020c3c0>] restore_args+0x0/0x30
>  [<ffffffff80611850>] kernel_init+0x0/0x1f0
>  [<ffffffff8020c9f0>] child_rip+0x0/0x20
> FIX kmalloc-4096: Object at 0xffff88007fb20010 not freed
> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

Hi Mariusz

This patch should fix it.
http://lkml.org/lkml/2008/12/4/249
