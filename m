Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYE3Xm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYE3Xm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYE3Xmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:42:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:2925 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbYE3Xmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PBfxaDegnQa50PVE9e5FHpU40K8eTdANd47bKJBbX1eWSpNB88QMLPaMMIsb8ESjq9LTvyOAd1B3XdA/ly5KuLYTZKcJ1nvYDnW40ShipDSejc9O6czuNS7Gz9CAGj4oT045havQl47Dqj6RWnFj5P21d+JY+bjI1VLCu7bXiNY=
Date: Sat, 31 May 2008 03:38:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: netsc520 remapping RAM
Message-ID: <20080530233837.GC7358@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce:

	modprobe netsc520

NetSc520 flash device: 0x100000 at 0x200000
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:159 __ioremap_caller+0x15e/0x2c0()
Modules linked in: netsc520(+) [many]
Pid: 13101, comm: modprobe Not tainted 2.6.26-rc4-fat #6

Call Trace:
 [<ffffffff80238042>] warn_on_slowpath+0x58/0x88
 [<ffffffff80238c7e>] ? printk+0x67/0x69
 [<ffffffff80222adc>] __ioremap_caller+0x15e/0x2c0
 [<ffffffffa1fab033>] ? :netsc520:init_netsc520+0x33/0xf4
 [<ffffffff80222c61>] ioremap_nocache+0x12/0x14
 [<ffffffffa1fab033>] :netsc520:init_netsc520+0x33/0xf4
 [<ffffffff80261e35>] sys_init_module+0x9e/0x1b2
 [<ffffffff8020c15a>] system_call_after_swapgs+0x8a/0x8f

---[ end trace dd7999c17a89437b ]---
CFI: Found no netsc520 Flash Bank device at location zero
Creating 4 MTD partitions on "netsc520 Flash Bank":
0x00000000-0x000c0000 : "NetSc520 boot kernel"
mtd: Giving out device 2 to NetSc520 boot kernel
ftl_cs: FTL header not found.
0x000c0000-0x00100000 : "NetSc520 Low BIOS"
mtd: Giving out device 3 to NetSc520 Low BIOS
ftl_cs: FTL header not found.
0x00100000-0x00f80000 : "NetSc520 file system"
mtd: partition "NetSc520 file system" is out of reach -- disabled
mtd: Giving out device 4 to NetSc520 file system
ftl_cs: FTL header not found.
0x00f80000-0x01000000 : "NetSc520 High BIOS"
mtd: partition "NetSc520 High BIOS" is out of reach -- disabled
mtd: Giving out device 5 to NetSc520 High BIOS
ftl_cs: FTL header not found.


Should it depend on something so it won't be selected on usual
i386/x86_64 allmodconfig crash test?

