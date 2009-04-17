Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbZDQV70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbZDQV70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZDQV7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:59:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:8090 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbZDQV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wm77t77VDbbvJMAQXA3CPuxSN+82+ZQtZA47QzaKJJ06XIvRh+GPc38zQVkvEHhmpX
         E8cScZEJxAYOkPyEqI8bJBQiZ2o8lSURD3R/VcSIQJYKWOAVny1oSZXQTOnd/DvQ/je0
         EuenWSiXqdD8lrYvPEgZmVUuZ+P/0vTi+kn+A=
MIME-Version: 1.0
In-Reply-To: <20090417131633.GA30578@elte.hu>
References: <49E52D3F.1090206@kernel.org>
	 <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain>
	 <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org>
	 <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org>
	 <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
	 <20090416235452.GE21405@elte.hu>
	 <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain>
	 <20090417131633.GA30578@elte.hu>
Date: Fri, 17 Apr 2009 14:59:14 -0700
Message-ID: <86802c440904171459u7aee493do98fe1b56f395761d@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while testing linus's patch, found some resource name get corrupted...
even bare tip

cat /proc/iomem
00000000-000973ff : System RAM
00097400-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
000c0000-000cffff : pnp 00:0c
000e0000-000fffff : reserved
00100000-b7f9ffff : System RAM
  00200000-00c67b4b : Kernel code
  00c67b4c-01331edf : Kernel data
  015a5000-01fc9657 : Kernel bss
  20000000-23ffffff : GART
b7fae000-b7faffff : System RAM
b7fb0000-b7fbdfff : ACPI Tables
b7fbe000-b7feffff : ACPI Non-volatile Storage
b7ff0000-b7ffffff : reserved
b8000000-beffffff : PCI Bus #00
bf000000-bfffffff : PCI Bus #80
  bfe80000-bfebffff : pnp 00:0e
  bfef9000-bfef9fff :
    bfef9000-bfef9fff : forcedeth
  bfefa000-bfefa00f :
    bfefa000-bfefa00f : forcedeth
  bfefa400-bfefa4ff :
    bfefa400-bfefa4ff : forcedeth
  bfefa800-bfefa80f :
    bfefa800-bfefa80f : forcedeth
  bfefac00-bfefacff :
    bfefac00-bfefacff : forcedeth
  bfefb000-bfefbfff :
    bfefb000-bfefbfff : forcedeth
  bfefc000-bfefcfff :
    bfefc000-bfefcfff : sata_nv
  bfefd000-bfefdfff :
    bfefd000-bfefdfff : sata_nv
  bfefe000-bfefefff :
    bfefe000-bfefefff : sata_nv
  bfeff000-bfefffff : IOAPIC 1
    bfeff000-bfefffff :
  bff00000-bfffffff : PCI Bus 0000:83
    bff80000-bffbffff : 0000:83:00.0
    bfffec00-bfffecff : 0000:83:00.0
      bfffec00-bfffecff : lpfc
    bffff000-bfffffff : 0000:83:00.0
      bffff000-bfffffff : lpfc
c0000000-dfffffff : PCI Bus #00
  c0000000-d9ffffff : PCI Bus 0000:03
    c0000000-cfffffff : 0000:03:00.0
    d9800000-d9ffffff : 0000:03:00.0
  da6b8c00-da6b8c0f : 0000:00:09.0
    da6b8c00-da6b8c0f : forcedeth
  da6b9000-da6b9fff : 0000:00:09.0
    da6b9000-da6b9fff : forcedeth
  da6ba000-da6bafff : 0000:00:08.0
    da6ba000-da6bafff : forcedeth
  da6bb000-da6bbfff : 0000:00:05.2
    da6bb000-da6bbfff : sata_nv
  da6bc000-da6bcfff : 0000:00:05.1
    da6bc000-da6bcfff : sata_nv
  da6bd000-da6bdfff : 0000:00:05.0
    da6bd000-da6bdfff : sata_nv
  da6be000-da6be0ff : 0000:00:09.0
    da6be000-da6be0ff : forcedeth
  da6be400-da6be40f : 0000:00:08.0
    da6be400-da6be40f : forcedeth
  da6be800-da6be8ff : 0000:00:08.0
    da6be800-da6be8ff : forcedeth
  da6bec00-da6becff : 0000:00:02.1
    da6bec00-da6becff : ehci_hcd
  da6bf000-da6bffff : 0000:00:02.0
    da6bf000-da6bffff : ohci_hcd
  da6c0000-da6fffff : pnp 00:05
  da700000-daffffff : PCI Bus 0000:01
    da7e0000-da7fffff : 0000:01:05.0
    da800000-daffffff : 0000:01:05.0
  db000000-dfbfffff : PCI Bus 0000:02
    db000000-dbffffff : 0000:02:00.3
    dc000000-dcffffff : 0000:02:00.2
    dd000000-ddffffff : 0000:02:00.1
      dd000000-ddffffff : niu
    de000000-deffffff : 0000:02:00.0
      de000000-deffffff : niu
    df700000-df7fffff : 0000:02:00.3
    df800000-df8fffff : 0000:02:00.2
    df900000-df9fffff : 0000:02:00.1
    dfa00000-dfafffff : 0000:02:00.0
    dfbc0000-dfbc7fff : 0000:02:00.3
    dfbc8000-dfbcffff : 0000:02:00.3
    dfbd0000-dfbd7fff : 0000:02:00.2
    dfbd8000-dfbdffff : 0000:02:00.2
    dfbe0000-dfbe7fff : 0000:02:00.1
      dfbe0000-dfbe7fff : niu
    dfbe8000-dfbeffff : 0000:02:00.1
      dfbe8000-dfbeffff : niu
    dfbf0000-dfbf7fff : 0000:02:00.0
      dfbf0000-dfbf7fff : niu
    dfbf8000-dfbfffff : 0000:02:00.0
      dfbf8000-dfbfffff : niu
  dfc00000-dfcfffff : PCI Bus 0000:03
    dfc00000-dfcfffff : 0000:03:00.0
  dfd00000-dfffffff : PCI Bus 0000:04
    dfd80000-dfdfffff : 0000:04:00.0
    dfe00000-dfffffff : 0000:04:00.0
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:0b
f0000000-ffffffff : PCI Bus #00
  fec00000-fec00fff : IOAPIC 0
    fec00000-fec00fff : reserved
      fec00000-fec00fff : pnp 00:0a
  fed00000-fed003ff : HPET 0
  fee00000-feefffff : reserved
    fee00000-fee00fff : Local APIC
      fee00000-fee00fff : pnp 00:0a
    fee01000-feefffff : pnp 00:05
  ff700000-ffffffff : reserved
100000000-2047ffffff : System RAM
2048000000-fcffffffff : PCI Bus #00
