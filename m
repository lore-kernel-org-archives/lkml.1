Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYJTSwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYJTSwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYJTSv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:51:57 -0400
Received: from www17.your-server.de ([213.133.104.17]:42165 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbYJTSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:51:56 -0400
Subject: Re: WARNING: at arch/x86/mm/ioremap.c:226
From: Thomas Meyer <thomas@m3y3r.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081020112851.3ea44576@infradead.org>
References: <1224526053.4948.2.camel@dhcppc2>
	 <20081020112851.3ea44576@infradead.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 20:53:05 +0200
Message-Id: <1224528785.5180.1.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 20.10.2008, 11:28 -0700 schrieb Arjan van de Ven:
> [   16.914566] ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ff000000-0x00000000ffffffff - kernel bug?
> [   16.914575] resource map sanity check conflict: 0xff000000
> 0xffffffff 0xff780000 0xffffffff reserved
> 
> [   16.914636]  [<c042c02c>] ioremap_nocache+0xd/0xf
> [   16.914640]  [<f87e4246>] ? init_ck804xrom+0x246/0x4c7 [ck804xrom]
> [   16.914643]  [<f87e4246>] init_ck804xrom+0x246/0x4c7 [ck804xrom]
> 
> the init_ck804xrom driver seems to be requesting a bunch of memory with ioremap that crosses several resources...
> which is very bad.
> 
> Can you sent the /proc/iomem file ?

Sure:

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cffff : Video ROM
000d0000-000d07ff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-bffcffff : System RAM
  00400000-009d8e2e : Kernel code
  009d8e2f-00d30f57 : Kernel data
  00da3000-00e855df : Kernel bss
bffd0000-bffddfff : ACPI Tables
bffde000-bfffffff : ACPI Non-volatile Storage
c0000000-cfffffff : PCI Bus 0000:07
  c0000000-cfffffff : 0000:07:00.0
d0000000-dfffffff : reserved
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : pnp 00:0c
f0000000-f00fffff : PCI Bus 0000:01
  f0000000-f0003fff : 0000:01:00.0
fe980000-fe9bffff : pnp 00:06
fe9f0000-fe9f3fff : 0000:00:06.1
  fe9f0000-fe9f3fff : ICH HD audio
fe9f4c00-fe9f4c0f : 0000:00:09.0
  fe9f4c00-fe9f4c0f : forcedeth
fe9f5000-fe9f5fff : 0000:00:09.0
  fe9f5000-fe9f5fff : forcedeth
fe9f6000-fe9f6fff : 0000:00:08.0
  fe9f6000-fe9f6fff : forcedeth
fe9f7000-fe9f7fff : 0000:00:05.2
  fe9f7000-fe9f7fff : sata_nv
fe9f8000-fe9f8fff : 0000:00:05.1
  fe9f8000-fe9f8fff : sata_nv
fe9f9000-fe9f9fff : 0000:00:05.0
  fe9f9000-fe9f9fff : sata_nv
fe9fa000-fe9fa0ff : 0000:00:09.0
  fe9fa000-fe9fa0ff : forcedeth
fe9fa400-fe9fa40f : 0000:00:08.0
  fe9fa400-fe9fa40f : forcedeth
fe9fa800-fe9fa8ff : 0000:00:08.0
  fe9fa800-fe9fa8ff : forcedeth
fe9fac00-fe9facff : 0000:00:02.1
  fe9fac00-fe9facff : ehci_hcd
fe9fb000-fe9fbfff : 0000:00:02.0
  fe9fb000-fe9fbfff : ohci_hcd
fea00000-feafffff : PCI Bus 0000:01
  feafe800-feafefff : 0000:01:04.0
    feafe800-feafefff : firewire_ohci
  feaff000-feaff7ff : 0000:01:00.0
    feaff000-feaff7ff : olympic
  feaffc00-feaffcff : 0000:01:00.0
    feaffc00-feaffcff : olympic
feb00000-febfffff : PCI Bus 0000:07
  febc0000-febdffff : 0000:07:00.0
  febec000-febeffff : 0000:07:00.1
    febec000-febeffff : ICH HD audio
  febf0000-febfffff : 0000:07:00.0
fec00000-fec00fff : reserved
fed00000-fed003ff : HPET 0
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
ff780000-ffffffff : reserved
100000000-1bfffffff : System RAM



