Return-Path: <linux-kernel-owner+w=401wt.eu-S1761989AbXGSLhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761989AbXGSLhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXGSLhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:37:35 -0400
Received: from mtaout5.barak.net.il ([212.150.49.175]:34008 "EHLO
	mtaout5.barak.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXGSLhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:37:34 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 07:37:34 EDT
Date: Thu, 19 Jul 2007 14:04:05 +0300
From: Mike Rapoport <mike@compulab.co.il>
Subject: Re: Oops on arm pxa270 2.6.22
In-reply-to: <469F1CDA.8080304@kanardia.eu>
To: Rok Markovic <kernel@kanardia.eu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Message-id: <469F4525.5040309@compulab.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <469F1CDA.8080304@kanardia.eu>
User-Agent: Thunderbird 2.0.0.4 (X11/20070715)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rok Markovic wrote:
> Hi
> 
> I would like to ask what could be a problem or how could I start 
> debuging it.
> My board is cm-x270 from compulab and it successfully boot until it should
> start init from busysbox. I get the folowing report.
> 
> environment:
> pxa270
> 128Mb RAM
> network boot
> gcc 3.4.5 softfloat
> 
> 
> Linux image detected in memory at 0xA0100000, booting...

[snip]

> pxa2xx-fb: probe of pxa2xx-fb failed with error -22
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled

[snip]

> RAMDISK driver initialized: 4 RAM disks of 4096K size 1024 blocksize
>     bootserver=0.0.0.0, rootserver=192.168.10.124, rootpath=
> Looking up port of RPC 100003/2 on 192.168.10.124
> Looking up port of RPC 100005/1 on 192.168.10.124
> VFS: Mounted root (nfs filesystem).
> Freeing init memory: 108K
> Unable to handle kernel NULL pointer dereference at virtual address 
> 00000004
> pgd = c0004000
> [00000004] *pgd=00000000
> Internal error: Oops: f5 [#1]
> Modules linked in:
> CPU: 0    Not tainted  (2.6.22-cm-x270 #2)
> PC is at init_dev+0x38/0x5b8
> LR is at tty_open+0xf8/0x33c
> pc : [<c0135dd8>]    lr : [<c0136450>]    psr: 60000013

[snip]

> 3fe0: 00000000 00000000 00000000 c0423ff8 c003c9e8 c0008b30 e1a01007 
> ebfd4ec0
> Backtrace:
> [<c0135da0>] (init_dev+0x0/0x5b8) from [<c0136450>] (tty_open+0xf8/0x33c)
> [<c0136358>] (tty_open+0x0/0x33c) from [<c0088600>] 
> (chrdev_open+0x114/0x174)
> r8:c04e0d20 r7:00000000 r6:00000000 r5:c048f76c r4:c02e5c3c
> [<c00884ec>] (chrdev_open+0x0/0x174) from [<c00847d0>] 
> (__dentry_open+0x188/0x228)
> r8:c0531c80 r7:c04ae364 r6:c00884ec r5:c048f76c r4:c04e0d20
> [<c0084648>] (__dentry_open+0x0/0x228) from [<c00848a4>] 
> (nameidata_to_filp+0x34/0x4c)
> [<c0084870>] (nameidata_to_filp+0x0/0x4c) from [<c0084908>] 
> (do_filp_open+0x4c/0x50)
> r4:00000002
> [<c00848bc>] (do_filp_open+0x0/0x50) from [<c0084c48>] 
> (do_sys_open+0x5c/0xec)
> r5:00000000 r4:00000002
> [<c0084bec>] (do_sys_open+0x0/0xec) from [<c0084cfc>] (sys_open+0x24/0x28)
> [<c0084cd8>] (sys_open+0x0/0x28) from [<c0023300>] (init_post+0x2c/0xfc)
> [<c00232d4>] (init_post+0x0/0xfc) from [<c0008c80>] 
> (kernel_init+0x15c/0x2bc)
> r4:c02afed8
> [<c0008b24>] (kernel_init+0x0/0x2bc) from [<c003c9e8>] (do_exit+0x0/0x86c)
> Code: e3a03000 e5823000 059030b8 e1a06000 (07935107)
> Kernel panic - not syncing: Attempted to kill init!

I think you have conflict between PXA serial and 8250 drivers. Make sure you use 
only one of them.
If you need to use PCMCIA serial cards, please see 
http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2007-July/040604.html


-- 
Sincerely yours,
Mike.

