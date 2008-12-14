Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYLNBMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYLNBMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 20:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLNBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 20:12:13 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18408 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYLNBML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 20:12:11 -0500
Date: Sat, 13 Dec 2008 18:12:10 -0700
From: Alex Chiang <achiang@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: matthew@wil.cx, justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: PCI BAR mem resource allocation "regression"
Message-ID: <20081214011210.GC22302@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, matthew@wil.cx,
	justin.chen@hp.com, linux-kernel@vger.kernel.org
References: <20081213000538.GC9947@ldl.fc.hp.com> <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain> <alpine.LFD.2.00.0812130929100.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812130929100.3340@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org>:
> On Sat, 13 Dec 2008, Linus Torvalds wrote:
> > 
> > I'm missing some pieces I'd like to see: /proc/iomem before and after, and 
> > lspci output before and after (you do give lspci output, but only one, and 
> > I can't tell if it's before or after).
> > 
> > Also, is it just the error message, or does it actually affect 
> > functionality?
> 
> Oh - one more thing. Your revert is very complex, and a simpler revert 
> (that _should_ revert just the actual behavioral change) is just the 
> two-liner that removes these two lines:
> 
> 		if ((first->start == new->start) && (first->end == new->end))
> 			break;
> 
> in __insert_resource.
> 
> So can you check if your more complex revert really has the same behaviour 
> as just removing those two lines?

Yes, the two-liner above does result in the same success (aka,
lack of an error message ;) as my complex revert.

	(a) /proc/iomem before hot remove
	(b) /proc/iomem after hot remove
	(c) /proc/iomem after hot add
	(d) lspci -vv after hot add

Thanks.

/ac

# (a) /proc/iomem before hot remove
00000000-00000fff : System RAM
00001000-0009ffff : System RAM
000a0000-000fffff : PCI Bus 0000:00
  000c0000-000fffff : reserved
00100000-00100fff : System RAM
00101000-03ffffff : System RAM
04000000-06c0ffff : System RAM
  04000000-0485b70f : Kernel code
  0485b710-053b9aef : Kernel data
  053b9af0-06c0fcc0 : Kernel bss
06c10000-3dc3bfff : System RAM
3dc3c000-3ddd7fff : reserved
3ddd8000-3ddd9fff : reserved
3ddda000-3e199fff : reserved
3e19a000-3e527fff : System RAM
3e528000-3f7fffff : reserved
3f800000-3fbfffff : reserved
3fc00000-3fd5dfff : System RAM
3fd5e000-3fd5ffff : reserved
3fd60000-3fd60fff : System RAM
3fd61000-3fd65fff : System RAM
3fd66000-3fdc7fff : reserved
3fdc8000-3fdcdfff : System RAM
3fdce000-3fdf7fff : reserved
3fdf8000-3fdfffff : reserved
3fe00000-3fffffff : reserved
80000000-8fffffff : PCI Bus 0000:00
  80000000-83ffffff : 0000:00:04.0
  84000000-8401ffff : 0000:00:04.0
  84020000-8402ffff : 0000:00:04.0
  84030000-840300ff : 0000:00:02.2
    84030000-840300ff : ehci_hcd
  84031000-84031fff : 0000:00:02.1
    84031000-84031fff : ohci_hcd
  84032000-84032fff : 0000:00:02.0
    84032000-84032fff : ohci_hcd
  84033000-84033fff : 0000:00:01.2
    84033000-84033007 : serial
  84034000-84034fff : 0000:00:01.1
90000000-9fffffff : PCI Bus 0000:01
  90000000-9003ffff : 0000:01:02.1
  90040000-9007ffff : 0000:01:02.1
    90040000-9007ffff : e1000
  90080000-900bffff : 0000:01:02.0
  900c0000-900fffff : 0000:01:02.0
    900c0000-900fffff : e1000
  90100000-9011ffff : 0000:01:02.1
    90100000-9011ffff : e1000
  90120000-9013ffff : 0000:01:02.0
    90120000-9013ffff : e1000
a0000000-afffffff : PCI Bus 0000:0a
b0000000-bfffffff : PCI Bus 0000:0f
  b0000000-bfffffff : PCI Bus 0000:10
    b0000000-b003ffff : 0000:10:00.1
    b0040000-b007ffff : 0000:10:00.0
    b0080000-b00800ff : 0000:10:00.1
      b0080000-b00800ff : lpfc
    b0081000-b0081fff : 0000:10:00.1
      b0081000-b0081fff : lpfc
    b0082000-b00820ff : 0000:10:00.0
      b0082000-b00820ff : lpfc
    b0083000-b0083fff : 0000:10:00.0
      b0083000-b0083fff : lpfc
c0000000-cfffffff : PCI Bus 0000:48
  c0000000-c003ffff : 0000:48:02.1
  c0040000-c007ffff : 0000:48:02.1
    c0040000-c007ffff : e1000
  c0080000-c00bffff : 0000:48:02.0
  c00c0000-c00fffff : 0000:48:02.0
    c00c0000-c00fffff : e1000
  c0100000-c011ffff : 0000:48:02.1
    c0100000-c011ffff : e1000
  c0120000-c013ffff : 0000:48:02.0
    c0120000-c013ffff : e1000
d0000000-dfffffff : PCI Bus 0000:49
e0000000-efffffff : PCI Bus 0000:4e
  e0000000-efffffff : PCI Bus 0000:4f
    e0000000-efffffff : PCI Bus 0000:50
      e0000000-e7ffffff : PCI Bus 0000:51
        e0000000-e7ffffff : PCI Bus 0000:52
          e0000000-e3ffffff : PCI Bus 0000:54
          e0000000-e03fffff : 0000:54:00.1
          e0400000-e07fffff : 0000:54:00.0
          e0800000-e081ffff : 0000:54:00.1
          e0820000-e083ffff : 0000:54:00.0
          e4000000-e7ffffff : PCI Bus 0000:53
          e4000000-e43fffff : 0000:53:00.1
          e4400000-e47fffff : 0000:53:00.0
          e4800000-e481ffff : 0000:53:00.1
          e4820000-e483ffff : 0000:53:00.0
      e8000000-efffffff : PCI Bus 0000:89
        e8000000-e80fffff : 0000:89:00.0
          e8000000-e80fffff : cciss
        e8100000-e813ffff : 0000:89:00.0
        e8140000-e8140fff : 0000:89:00.0
          e8140000-e8140fff : cciss
f0000000-fdffffff : PCI Bus 0000:c2
  f0000000-fdffffff : PCI Bus 0000:c3
    f0000000-f00fffff : 0000:c3:00.0
ff5d8004-ff5d8007 : ACPI PM_TMR
ff5d8008-ff5d800b : ACPI PM1a_EVT_BLK
ff5d800c-ff5d800d : ACPI PM1a_CNT_BLK
ff5d8010-ff5d8013 : ACPI GPE0_BLK
ff5d8014-ff5d8017 : ACPI GPE1_BLK
ff5e2000-ff5e2007 : PCI Bus 0000:00
  ff5e2000-ff5e2007 : serial
100000000-5ffffffff : System RAM
10040000000-100fede3fff : System RAM
100fede4000-100ff19ffff : System RAM
  100fede4010-100fede47f0 : EFI Memory Map
  100fede6010-100fede6060 : Boot parameter
100ff1a0000-100ff1fdfff : System RAM
100ff1fe000-100ff1fffff : reserved
100ff200000-100ff453fff : System RAM
100ff454000-100ff800fff : System RAM
100ff801000-100ff94dfff : System RAM
100ff94e000-100ff977fff : System RAM
100ff978000-100ff97bfff : System RAM
100ff97c000-100ff97ffff : System RAM
100ff980000-100ff981fff : System RAM
100ff982000-100ffbfffff : System RAM
100ffc00000-100ffe74fff : System RAM
100ffe75000-100ffffffff : System RAM
80000000000-80003ffffff : PCI Bus 0000:00 I/O Ports 01000000-0100ffff
80004000000-800ffffffff : PCI Bus 0000:00
  80080000000-8008001ffff : 0000:00:01.1
80100000000-80103ffffff : PCI Bus 0000:01 I/O Ports 02000000-0200ffff
80104000000-801ffffffff : PCI Bus 0000:01
80200000000-80203ffffff : PCI Bus 0000:0a I/O Ports 03000000-0300ffff
80204000000-802ffffffff : PCI Bus 0000:0a
80300000000-80303ffffff : PCI Bus 0000:0f I/O Ports 04000000-0400ffff
80304000000-803ffffffff : PCI Bus 0000:0f
  80380000000-803ffffffff : PCI Bus 0000:10
80400000000-80403ffffff : PCI Bus 0000:48 I/O Ports 05000000-0500ffff
80404000000-804ffffffff : PCI Bus 0000:48
80500000000-80503ffffff : PCI Bus 0000:49 I/O Ports 06000000-0600ffff
80504000000-805ffffffff : PCI Bus 0000:49
80600000000-80603ffffff : PCI Bus 0000:4e I/O Ports 07000000-0700ffff
80604000000-806ffffffff : PCI Bus 0000:4e
  80680000000-806ffffffff : PCI Bus 0000:4f
    80680000000-806ffffffff : PCI Bus 0000:50
      80680000000-806bfffffff : PCI Bus 0000:51
        80680000000-806bfffffff : PCI Bus 0000:52
          80680000000-8069fffffff : PCI Bus 0000:53
          806a0000000-806bfffffff : PCI Bus 0000:54
      806c0000000-806ffffffff : PCI Bus 0000:89
80700000000-80703ffffff : PCI Bus 0000:c2 I/O Ports 08000000-0800ffff
80704000000-807ffffffff : PCI Bus 0000:c2
  80780000000-807ffffffff : PCI Bus 0000:c3
    80780000000-80787ffffff : 0000:c3:00.0
    80788000000-807887fffff : 0000:c3:00.0

# (b) /proc/iomem after hot remove
00000000-00000fff : System RAM
00001000-0009ffff : System RAM
000a0000-000fffff : PCI Bus 0000:00
  000c0000-000fffff : reserved
00100000-00100fff : System RAM
00101000-03ffffff : System RAM
04000000-06c0ffff : System RAM
  04000000-0485b70f : Kernel code
  0485b710-053b9aef : Kernel data
  053b9af0-06c0fcc0 : Kernel bss
06c10000-3dc3bfff : System RAM
3dc3c000-3ddd7fff : reserved
3ddd8000-3ddd9fff : reserved
3ddda000-3e199fff : reserved
3e19a000-3e527fff : System RAM
3e528000-3f7fffff : reserved
3f800000-3fbfffff : reserved
3fc00000-3fd5dfff : System RAM
3fd5e000-3fd5ffff : reserved
3fd60000-3fd60fff : System RAM
3fd61000-3fd65fff : System RAM
3fd66000-3fdc7fff : reserved
3fdc8000-3fdcdfff : System RAM
3fdce000-3fdf7fff : reserved
3fdf8000-3fdfffff : reserved
3fe00000-3fffffff : reserved
80000000-8fffffff : PCI Bus 0000:00
  80000000-83ffffff : 0000:00:04.0
  84000000-8401ffff : 0000:00:04.0
  84020000-8402ffff : 0000:00:04.0
  84030000-840300ff : 0000:00:02.2
    84030000-840300ff : ehci_hcd
  84031000-84031fff : 0000:00:02.1
    84031000-84031fff : ohci_hcd
  84032000-84032fff : 0000:00:02.0
    84032000-84032fff : ohci_hcd
  84033000-84033fff : 0000:00:01.2
    84033000-84033007 : serial
  84034000-84034fff : 0000:00:01.1
90000000-9fffffff : PCI Bus 0000:01
  90000000-9003ffff : 0000:01:02.1
  90040000-9007ffff : 0000:01:02.1
    90040000-9007ffff : e1000
  90080000-900bffff : 0000:01:02.0
  900c0000-900fffff : 0000:01:02.0
    900c0000-900fffff : e1000
  90100000-9011ffff : 0000:01:02.1
    90100000-9011ffff : e1000
  90120000-9013ffff : 0000:01:02.0
    90120000-9013ffff : e1000
a0000000-afffffff : PCI Bus 0000:0a
b0000000-bfffffff : PCI Bus 0000:0f
  b0000000-bfffffff : PCI Bus 0000:10
    b0000000-b003ffff : 0000:10:00.1
    b0040000-b007ffff : 0000:10:00.0
    b0080000-b00800ff : 0000:10:00.1
      b0080000-b00800ff : lpfc
    b0081000-b0081fff : 0000:10:00.1
      b0081000-b0081fff : lpfc
    b0082000-b00820ff : 0000:10:00.0
      b0082000-b00820ff : lpfc
    b0083000-b0083fff : 0000:10:00.0
      b0083000-b0083fff : lpfc
c0000000-cfffffff : PCI Bus 0000:48
  c0000000-c003ffff : 0000:48:02.1
  c0040000-c007ffff : 0000:48:02.1
    c0040000-c007ffff : e1000
  c0080000-c00bffff : 0000:48:02.0
  c00c0000-c00fffff : 0000:48:02.0
    c00c0000-c00fffff : e1000
  c0100000-c011ffff : 0000:48:02.1
    c0100000-c011ffff : e1000
  c0120000-c013ffff : 0000:48:02.0
    c0120000-c013ffff : e1000
d0000000-dfffffff : PCI Bus 0000:49
e0000000-efffffff : PCI Bus 0000:4e
  e0000000-efffffff : PCI Bus 0000:4f
    e0000000-efffffff : PCI Bus 0000:50
      e0000000-e7ffffff : PCI Bus 0000:51
        e0000000-e7ffffff : PCI Bus 0000:52
          e0000000-e3ffffff : PCI Bus 0000:54
          e0000000-e03fffff : 0000:54:00.1
          e0400000-e07fffff : 0000:54:00.0
          e0800000-e081ffff : 0000:54:00.1
          e0820000-e083ffff : 0000:54:00.0
          e4000000-e7ffffff : PCI Bus 0000:53
          e4000000-e43fffff : 0000:53:00.1
          e4400000-e47fffff : 0000:53:00.0
          e4800000-e481ffff : 0000:53:00.1
          e4820000-e483ffff : 0000:53:00.0
      e8000000-efffffff : PCI Bus 0000:89
        e8000000-e80fffff : 0000:89:00.0
          e8000000-e80fffff : cciss
        e8100000-e813ffff : 0000:89:00.0
        e8140000-e8140fff : 0000:89:00.0
          e8140000-e8140fff : cciss
f0000000-fdffffff : PCI Bus 0000:c2
  f0000000-fdffffff : PCI Bus 0000:c3
ff5d8004-ff5d8007 : ACPI PM_TMR
ff5d8008-ff5d800b : ACPI PM1a_EVT_BLK
ff5d800c-ff5d800d : ACPI PM1a_CNT_BLK
ff5d8010-ff5d8013 : ACPI GPE0_BLK
ff5d8014-ff5d8017 : ACPI GPE1_BLK
ff5e2000-ff5e2007 : PCI Bus 0000:00
  ff5e2000-ff5e2007 : serial
100000000-5ffffffff : System RAM
10040000000-100fede3fff : System RAM
100fede4000-100ff19ffff : System RAM
  100fede4010-100fede47f0 : EFI Memory Map
  100fede6010-100fede6060 : Boot parameter
100ff1a0000-100ff1fdfff : System RAM
100ff1fe000-100ff1fffff : reserved
100ff200000-100ff453fff : System RAM
100ff454000-100ff800fff : System RAM
100ff801000-100ff94dfff : System RAM
100ff94e000-100ff977fff : System RAM
100ff978000-100ff97bfff : System RAM
100ff97c000-100ff97ffff : System RAM
100ff980000-100ff981fff : System RAM
100ff982000-100ffbfffff : System RAM
100ffc00000-100ffe74fff : System RAM
100ffe75000-100ffffffff : System RAM
80000000000-80003ffffff : PCI Bus 0000:00 I/O Ports 01000000-0100ffff
80004000000-800ffffffff : PCI Bus 0000:00
  80080000000-8008001ffff : 0000:00:01.1
80100000000-80103ffffff : PCI Bus 0000:01 I/O Ports 02000000-0200ffff
80104000000-801ffffffff : PCI Bus 0000:01
80200000000-80203ffffff : PCI Bus 0000:0a I/O Ports 03000000-0300ffff
80204000000-802ffffffff : PCI Bus 0000:0a
80300000000-80303ffffff : PCI Bus 0000:0f I/O Ports 04000000-0400ffff
80304000000-803ffffffff : PCI Bus 0000:0f
  80380000000-803ffffffff : PCI Bus 0000:10
80400000000-80403ffffff : PCI Bus 0000:48 I/O Ports 05000000-0500ffff
80404000000-804ffffffff : PCI Bus 0000:48
80500000000-80503ffffff : PCI Bus 0000:49 I/O Ports 06000000-0600ffff
80504000000-805ffffffff : PCI Bus 0000:49
80600000000-80603ffffff : PCI Bus 0000:4e I/O Ports 07000000-0700ffff
80604000000-806ffffffff : PCI Bus 0000:4e
  80680000000-806ffffffff : PCI Bus 0000:4f
    80680000000-806ffffffff : PCI Bus 0000:50
      80680000000-806bfffffff : PCI Bus 0000:51
        80680000000-806bfffffff : PCI Bus 0000:52
          80680000000-8069fffffff : PCI Bus 0000:53
          806a0000000-806bfffffff : PCI Bus 0000:54
      806c0000000-806ffffffff : PCI Bus 0000:89
80700000000-80703ffffff : PCI Bus 0000:c2 I/O Ports 08000000-0800ffff
80704000000-807ffffffff : PCI Bus 0000:c2
  80780000000-807ffffffff : PCI Bus 0000:c3

# (c) /proc/iomem after hot add
00000000-00000fff : System RAM
00001000-0009ffff : System RAM
000a0000-000fffff : PCI Bus 0000:00
  000c0000-000fffff : reserved
00100000-00100fff : System RAM
00101000-03ffffff : System RAM
04000000-06c0ffff : System RAM
  04000000-0485b70f : Kernel code
  0485b710-053b9aef : Kernel data
  053b9af0-06c0fcc0 : Kernel bss
06c10000-3dc3bfff : System RAM
3dc3c000-3ddd7fff : reserved
3ddd8000-3ddd9fff : reserved
3ddda000-3e199fff : reserved
3e19a000-3e527fff : System RAM
3e528000-3f7fffff : reserved
3f800000-3fbfffff : reserved
3fc00000-3fd5dfff : System RAM
3fd5e000-3fd5ffff : reserved
3fd60000-3fd60fff : System RAM
3fd61000-3fd65fff : System RAM
3fd66000-3fdc7fff : reserved
3fdc8000-3fdcdfff : System RAM
3fdce000-3fdf7fff : reserved
3fdf8000-3fdfffff : reserved
3fe00000-3fffffff : reserved
80000000-8fffffff : PCI Bus 0000:00
  80000000-83ffffff : 0000:00:04.0
  84000000-8401ffff : 0000:00:04.0
  84020000-8402ffff : 0000:00:04.0
  84030000-840300ff : 0000:00:02.2
    84030000-840300ff : ehci_hcd
  84031000-84031fff : 0000:00:02.1
    84031000-84031fff : ohci_hcd
  84032000-84032fff : 0000:00:02.0
    84032000-84032fff : ohci_hcd
  84033000-84033fff : 0000:00:01.2
    84033000-84033007 : serial
  84034000-84034fff : 0000:00:01.1
90000000-9fffffff : PCI Bus 0000:01
  90000000-9003ffff : 0000:01:02.1
  90040000-9007ffff : 0000:01:02.1
    90040000-9007ffff : e1000
  90080000-900bffff : 0000:01:02.0
  900c0000-900fffff : 0000:01:02.0
    900c0000-900fffff : e1000
  90100000-9011ffff : 0000:01:02.1
    90100000-9011ffff : e1000
  90120000-9013ffff : 0000:01:02.0
    90120000-9013ffff : e1000
a0000000-afffffff : PCI Bus 0000:0a
b0000000-bfffffff : PCI Bus 0000:0f
  b0000000-bfffffff : PCI Bus 0000:10
    b0000000-b003ffff : 0000:10:00.1
    b0040000-b007ffff : 0000:10:00.0
    b0080000-b00800ff : 0000:10:00.1
      b0080000-b00800ff : lpfc
    b0081000-b0081fff : 0000:10:00.1
      b0081000-b0081fff : lpfc
    b0082000-b00820ff : 0000:10:00.0
      b0082000-b00820ff : lpfc
    b0083000-b0083fff : 0000:10:00.0
      b0083000-b0083fff : lpfc
c0000000-cfffffff : PCI Bus 0000:48
  c0000000-c003ffff : 0000:48:02.1
  c0040000-c007ffff : 0000:48:02.1
    c0040000-c007ffff : e1000
  c0080000-c00bffff : 0000:48:02.0
  c00c0000-c00fffff : 0000:48:02.0
    c00c0000-c00fffff : e1000
  c0100000-c011ffff : 0000:48:02.1
    c0100000-c011ffff : e1000
  c0120000-c013ffff : 0000:48:02.0
    c0120000-c013ffff : e1000
d0000000-dfffffff : PCI Bus 0000:49
e0000000-efffffff : PCI Bus 0000:4e
  e0000000-efffffff : PCI Bus 0000:4f
    e0000000-efffffff : PCI Bus 0000:50
      e0000000-e7ffffff : PCI Bus 0000:51
        e0000000-e7ffffff : PCI Bus 0000:52
          e0000000-e3ffffff : PCI Bus 0000:54
          e0000000-e03fffff : 0000:54:00.1
          e0400000-e07fffff : 0000:54:00.0
          e0800000-e081ffff : 0000:54:00.1
          e0820000-e083ffff : 0000:54:00.0
          e4000000-e7ffffff : PCI Bus 0000:53
          e4000000-e43fffff : 0000:53:00.1
          e4400000-e47fffff : 0000:53:00.0
          e4800000-e481ffff : 0000:53:00.1
          e4820000-e483ffff : 0000:53:00.0
      e8000000-efffffff : PCI Bus 0000:89
        e8000000-e80fffff : 0000:89:00.0
          e8000000-e80fffff : cciss
        e8100000-e813ffff : 0000:89:00.0
        e8140000-e8140fff : 0000:89:00.0
          e8140000-e8140fff : cciss
f0000000-fdffffff : PCI Bus 0000:c2
  f0000000-fdffffff : PCI Bus 0000:c3
    f0000000-f00fffff : 0000:c3:00.0
ff5d8004-ff5d8007 : ACPI PM_TMR
ff5d8008-ff5d800b : ACPI PM1a_EVT_BLK
ff5d800c-ff5d800d : ACPI PM1a_CNT_BLK
ff5d8010-ff5d8013 : ACPI GPE0_BLK
ff5d8014-ff5d8017 : ACPI GPE1_BLK
ff5e2000-ff5e2007 : PCI Bus 0000:00
  ff5e2000-ff5e2007 : serial
100000000-5ffffffff : System RAM
10040000000-100fede3fff : System RAM
100fede4000-100ff19ffff : System RAM
  100fede4010-100fede47f0 : EFI Memory Map
  100fede6010-100fede6060 : Boot parameter
100ff1a0000-100ff1fdfff : System RAM
100ff1fe000-100ff1fffff : reserved
100ff200000-100ff453fff : System RAM
100ff454000-100ff800fff : System RAM
100ff801000-100ff94dfff : System RAM
100ff94e000-100ff977fff : System RAM
100ff978000-100ff97bfff : System RAM
100ff97c000-100ff97ffff : System RAM
100ff980000-100ff981fff : System RAM
100ff982000-100ffbfffff : System RAM
100ffc00000-100ffe74fff : System RAM
100ffe75000-100ffffffff : System RAM
80000000000-80003ffffff : PCI Bus 0000:00 I/O Ports 01000000-0100ffff
80004000000-800ffffffff : PCI Bus 0000:00
  80080000000-8008001ffff : 0000:00:01.1
80100000000-80103ffffff : PCI Bus 0000:01 I/O Ports 02000000-0200ffff
80104000000-801ffffffff : PCI Bus 0000:01
80200000000-80203ffffff : PCI Bus 0000:0a I/O Ports 03000000-0300ffff
80204000000-802ffffffff : PCI Bus 0000:0a
80300000000-80303ffffff : PCI Bus 0000:0f I/O Ports 04000000-0400ffff
80304000000-803ffffffff : PCI Bus 0000:0f
  80380000000-803ffffffff : PCI Bus 0000:10
80400000000-80403ffffff : PCI Bus 0000:48 I/O Ports 05000000-0500ffff
80404000000-804ffffffff : PCI Bus 0000:48
80500000000-80503ffffff : PCI Bus 0000:49 I/O Ports 06000000-0600ffff
80504000000-805ffffffff : PCI Bus 0000:49
80600000000-80603ffffff : PCI Bus 0000:4e I/O Ports 07000000-0700ffff
80604000000-806ffffffff : PCI Bus 0000:4e
  80680000000-806ffffffff : PCI Bus 0000:4f
    80680000000-806ffffffff : PCI Bus 0000:50
      80680000000-806bfffffff : PCI Bus 0000:51
        80680000000-806bfffffff : PCI Bus 0000:52
          80680000000-8069fffffff : PCI Bus 0000:53
          806a0000000-806bfffffff : PCI Bus 0000:54
      806c0000000-806ffffffff : PCI Bus 0000:89
80700000000-80703ffffff : PCI Bus 0000:c2 I/O Ports 08000000-0800ffff
80704000000-807ffffffff : PCI Bus 0000:c2
  80780000000-807ffffffff : PCI Bus 0000:c3
    80780000000-80787ffffff : 0000:c3:00.0
    80788000000-807887fffff : 0000:c3:00.0

# (d) lspci -vv after hot add
00:01.0 Class ff00: Hewlett-Packard Company RMP-3 (Remote Management Processor)
	Subsystem: Hewlett-Packard Company RMP-3 (Remote Management Processor)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000

00:01.1 Communication controller: Hewlett-Packard Company RMP-3 Shared Memory Driver
	Subsystem: Hewlett-Packard Company RMP-3 Shared Memory Driver
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 1: Memory at 84034000 (64-bit, non-prefetchable) [size=4K]
	Region 3: Memory at 80080000000 (64-bit, prefetchable) [size=128K]
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: 0000000000000000  Data: 0000

00:01.2 Serial controller: Hewlett-Packard Company Diva Serial [GSP] Multiport UART (prog-if 02 [16550])
	Subsystem: Hewlett-Packard Company Diva RMP3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 60
	Region 1: Memory at 84033000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: serial

00:02.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: Unknown device 03f0:0226
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns min, 10500ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 74
	Region 0: Memory at 84032000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: Unknown device 03f0:0226
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns min, 10500ns max), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 75
	Region 0: Memory at 84031000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 20 [EHCI])
	Subsystem: Unknown device 03f0:0326
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
	Interrupt: pin C routed to IRQ 73
	Region 0: Memory at 84030000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:04.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE] (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Radeon 7000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (2000ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at 80000000 (32-bit, prefetchable) [size=64M]
	Region 1: I/O ports at 1001000 [size=256]
	Region 2: Memory at 84020000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at 84000000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:02.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 66
	Region 0: Memory at 90120000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at 900c0000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 2001040 [size=64]
	Expansion ROM at 90080000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=01:02.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

01:02.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 67
	Region 0: Memory at 90100000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at 90040000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 2001000 [size=64]
	Expansion ROM at 90000000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=01:02.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

0f:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=0f, secondary=10, subordinate=47, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: b0000000-bfffffff
	Prefetchable memory behind bridge: 0000080380000000-00000803ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 4033
	Capabilities: [60] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  6, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Vendor Specific Information <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

10:00.0 Fibre Channel: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter (rev 02)
	Subsystem: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 70
	Region 0: Memory at b0083000 (64-bit, non-prefetchable) [size=4K]
	Region 2: Memory at b0082000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 4001100 [size=256]
	Expansion ROM at b0040000 [disabled] [size=256K]
	Capabilities: [58] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable+
		Address: 00000000fee00000  Data: 4046
	Capabilities: [44] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <4us, L1 <16us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [12c] Power Budgeting <?>
	Kernel driver in use: lpfc

10:00.1 Fibre Channel: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter (rev 02)
	Subsystem: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 72
	Region 0: Memory at b0081000 (64-bit, non-prefetchable) [size=4K]
	Region 2: Memory at b0080000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 4001000 [size=256]
	Expansion ROM at b0000000 [disabled] [size=256K]
	Capabilities: [58] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable+
		Address: 00000000fee00000  Data: 4048
	Capabilities: [44] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <4us, L1 <16us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [12c] Power Budgeting <?>
	Kernel driver in use: lpfc

48:02.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 68
	Region 0: Memory at c0120000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at c00c0000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 5001040 [size=64]
	Expansion ROM at c0080000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=48:02.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

48:02.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 69
	Region 0: Memory at c0100000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at c0040000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 5001000 [size=64]
	Expansion ROM at c0000000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=48:02.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

4e:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=4e, secondary=4f, subordinate=c1, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: e0000000-efffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 4035
	Capabilities: [60] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Vendor Specific Information <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

4f:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=4f, secondary=50, subordinate=c1, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: e0000000-efffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Upstream Port, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-SlotPowerLimit 0.000000W
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

50:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=50, secondary=51, subordinate=88, sec-latency=0
	I/O behind bridge: 00009000-0000ffff
	Memory behind bridge: e0000000-e7ffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806bfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  4, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt+ HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4036
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

50:01.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=50, secondary=89, subordinate=c1, sec-latency=0
	I/O behind bridge: 00001000-00008fff
	Memory behind bridge: e8000000-efffffff
	Prefetchable memory behind bridge: 00000806c0000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  3, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt+ HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4037
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

51:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=51, secondary=52, subordinate=54, sec-latency=0
	I/O behind bridge: 00009000-0000ffff
	Memory behind bridge: e0000000-e7ffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806bfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Upstream Port, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-SlotPowerLimit 25.000000W
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

52:02.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=52, secondary=53, subordinate=53, sec-latency=0
	I/O behind bridge: 00009000-0000cfff
	Memory behind bridge: e4000000-e7ffffff
	Prefetchable memory behind bridge: 0000080680000000-000008069fffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4038
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

52:04.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=52, secondary=54, subordinate=54, sec-latency=0
	I/O behind bridge: 0000d000-0000ffff
	Memory behind bridge: e0000000-e3ffffff
	Prefetchable memory behind bridge: 00000806a0000000-00000806bfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4039
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

53:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 0
	Region 0: Memory at e4820000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e4400000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 7009020 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number e8-03-47-ff-ff-c4-1c-00

53:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at e4800000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e4000000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 7009000 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number e8-03-47-ff-ff-c4-1c-00

54:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 0
	Region 0: Memory at e0820000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e0400000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 700d020 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number ea-03-47-ff-ff-c4-1c-00

54:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at e0800000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 700d000 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number ea-03-47-ff-ff-c4-1c-00

89:00.0 RAID bus controller: Hewlett-Packard Company Smart Array Controller (rev 03)
	Subsystem: Hewlett-Packard Company P400 SAS Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 61
	Region 0: Memory at e8000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: I/O ports at 7001000 [size=256]
	Region 3: Memory at e8140000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at e8100000 [disabled] [size=256K]
	Capabilities: [b0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 2048 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 <2us, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [d4] MSI-X: Enable+ Mask- TabSize=4
		Vector table: BAR=0 offset=000fe000
		PBA: BAR=0 offset=000ff000
	Capabilities: [e0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [ec] Vital Product Data <?>
	Capabilities: [100] Power Budgeting <?>
	Kernel driver in use: cciss

c2:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=c2, secondary=c3, subordinate=fb, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: f0000000-fdffffff
	Prefetchable memory behind bridge: 0000080780000000-00000807ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 403b
	Capabilities: [60] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  5, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Vendor Specific Information <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

c3:00.0 InfiniBand: Mellanox Technologies MT25208 InfiniHost III Ex (Tavor compatibility mode) (rev a0)
	Subsystem: Mellanox Technologies MT25208 InfiniHost III Ex (Tavor compatibility mode)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at f0000000 (64-bit, non-prefetchable) [disabled] [size=1M]
	Region 2: Memory at 80788000000 (64-bit, prefetchable) [disabled] [size=8M]
	Region 4: Memory at 80780000000 (64-bit, prefetchable) [disabled] [size=128M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Vital Product Data <?>
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [84] MSI-X: Enable- Mask- TabSize=32
		Vector table: BAR=0 offset=00082000
		PBA: BAR=0 offset=00082200
	Capabilities: [60] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #8, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-

