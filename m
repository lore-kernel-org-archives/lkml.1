Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbYEaI7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbYEaI7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYEaI7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:59:42 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:53402 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYEaI7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:59:41 -0400
Date: Sat, 31 May 2008 10:59:38 +0200
Message-Id: <298992806@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: netsc520 remapping RAM
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/miWY/71/nwNwtdu7Td4If0o8n3XotbxoV1+uc5rk4X051g
 p1hc0xGyMxONPfYTZQklYMhI0wAMLO5fqwqqZwvH97xsWKToPQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added to bugzilla as i have also come across issues with netsc520 at least twice.

see 
http://bugzilla.kernel.org/show_bug.cgi?id=10840



List:       linux-kernel
Subject:    netsc520 remapping RAM
From:       Alexey Dobriyan <adobriyan () gmail ! com>
Date:       2008-05-30 23:38:37
Message-ID: 20080530233837.GC7358 () martell ! zuzino ! mipt ! ru
[Download message RAW]

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


_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

