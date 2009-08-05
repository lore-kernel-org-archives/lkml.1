Return-Path: <linux-kernel-owner+w=401wt.eu-S934752AbZHERJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752AbZHERJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934303AbZHERJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:09:45 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:39566 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934748AbZHERJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:09:41 -0400
Date: Wed, 5 Aug 2009 19:09:34 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Message-ID: <20090805170934.GA32274@roarinelk.homelinux.net>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net> <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Aug 05, 2009 at 09:38:52AM -0700, Linus Torvalds wrote:
> On Wed, 5 Aug 2009, Linus Torvalds wrote:
> > 
> > So I think I understand the behavior on your box, and the warning was 
> > actually correct and useful - our PCI layer is being stupid. We should 
> > mark ROM resources as being prefetchable.
> > 
> > Hmm.. We do seem to _try_ do exactly that in pci_read_bases(). I wonder 
> > what I'm missing, and where that bit is then cleared. Or whether we're 
> > doing that ROM BAR probe somewhere else too..
> 
> Manuel, could you compile your kernel with CONFIG_PCI_DEBUG enabled, and
> then boot it with "pci=earlydump", and send me the dmesg of a kernel boot? 

Linux version 2.6.31-rc5-00246-g90bc1a6 (mano@scarran) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1) ) #1 Wed Aug 5 18:57:04 CEST 2009
KERNEL supported cpus:
  Intel GenuineIntel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff40000 (usable)
 BIOS-e820: 000000003ff40000 - 000000003ff50000 (ACPI data)
 BIOS-e820: 000000003ff50000 - 0000000040000000 (ACPI NVS)
pci 0000:00:00.0 config space:
  00: 86 80 40 33 06 00 90 20 03 00 00 06 00 00 00 00
  10: 08 00 00 e0 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 87 81
  30: 00 00 00 00 e4 00 00 00 00 00 00 00 00 00 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 27 00 00
  60: 08 10 18 20 00 00 00 00 00 00 00 00 00 00 00 00
  70: 03 03 00 00 00 00 00 00 08 00 02 2d 71 32 40 30
  80: 71 00 80 05 00 00 00 00 00 10 01 00 00 00 00 00
  90: 10 11 11 00 00 33 33 00 41 19 00 00 00 0a 38 00
  a0: 02 00 20 00 17 02 00 1f 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 44 40 50 11 00 40 05 06 00 00 00 00 00 00 00 00
  d0: 02 28 00 0e 0b 00 00 30 00 00 31 b5 00 00 02 00
  e0: 00 00 00 00 09 a0 04 41 00 00 00 00 00 00 00 00
  f0: 00 00 01 00 74 f8 20 80 38 0f 21 00 04 00 00 00
pci 0000:00:01.0 config space:
  00: 86 80 41 33 07 01 a0 00 03 00 04 06 00 40 01 00
  10: 00 00 00 00 00 00 00 00 00 01 01 40 c0 c0 a0 22
  20: 50 ff 50 ff 90 ce 90 de 00 00 00 00 00 00 00 00
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:00:1d.0 config space:
  00: 86 80 c2 24 05 00 80 02 03 00 03 0c 00 00 80 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 01 e8 00 00 00 00 00 00 00 00 00 00 4d 10 88 81
  30: 00 00 00 00 00 00 00 00 00 00 00 00 09 01 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 30 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00
pci 0000:00:1d.1 config space:
  00: 86 80 c4 24 05 00 80 02 03 00 03 0c 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 81 e8 00 00 00 00 00 00 00 00 00 00 4d 10 88 81
  30: 00 00 00 00 00 00 00 00 00 00 00 00 04 02 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 30 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00
pci 0000:00:1d.2 config space:
  00: 86 80 c7 24 05 00 80 02 03 00 03 0c 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 01 ec 00 00 00 00 00 00 00 00 00 00 4d 10 88 81
  30: 00 00 00 00 00 00 00 00 00 00 00 00 07 03 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 30 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00
pci 0000:00:1d.7 config space:
  00: 86 80 cd 24 06 00 90 02 03 20 03 0c 00 00 00 00
  10: 00 fc 7f ff 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 88 81
  30: 00 00 00 00 50 00 00 00 00 00 00 00 03 04 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 01 58 c2 c9 00 00 00 00 0a 00 80 20 00 00 00 00
  60: 20 20 7f 00 00 00 00 00 01 00 00 00 00 00 00 c0
  70: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 10 00 3f 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 78 bf 1f 00 88 83 00 00 60 0f 00 00 06 00 00 00
pci 0000:00:1e.0 config space:
  00: 86 80 48 24 07 01 80 80 83 00 04 06 00 00 01 00
  10: 00 00 00 00 00 00 00 00 00 02 02 40 d0 d0 80 22
  20: 60 ff 60 ff a0 de a0 de 00 00 00 00 00 00 00 00
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 02
  40: 02 28 20 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 02 74 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 10 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 01 00 02 00 00 00 c0 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 2c 4a
pci 0000:00:1f.0 config space:
  00: 86 80 cc 24 0f 00 80 02 03 00 01 06 00 00 80 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  40: 01 04 00 00 10 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 01 05 00 00 10 00 00 00
  60: 09 09 07 04 90 00 00 00 09 80 05 03 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: ff fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 20 02 00 00 01 00 00 00 0d 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 fe 00 00 00 00 00 00 01 00 00 00
  d0: 06 20 00 00 02 cf 00 00 04 00 00 00 00 00 00 00
  e0: 10 00 00 ff 00 00 00 00 33 22 11 01 00 00 67 45
  f0: 00 00 00 00 00 00 00 00 60 0f 03 00 00 00 80 00
pci 0000:00:1f.1 config space:
  00: 86 80 ca 24 05 00 80 02 03 8a 01 01 00 00 00 00
  10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
  20: a1 ff 00 00 00 00 00 00 00 00 00 00 4d 10 88 81
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00
  40: 07 e3 07 e3 00 00 00 00 05 00 01 02 00 00 00 00
  50: 00 00 00 00 31 14 00 00 00 00 00 00 00 00 00 00
  60: 08 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00
pci 0000:00:1f.3 config space:
  00: 86 80 c3 24 01 00 80 02 03 00 05 0c 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 41 05 00 00 00 00 00 00 00 00 00 00 4d 10 88 81
  30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00
  40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00
pci 0000:00:1f.5 config space:
  00: 86 80 c5 24 07 00 90 02 03 00 01 04 00 00 00 00
  10: 01 ee 00 00 01 e0 00 00 00 f8 7f ff 00 f4 7f ff
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 8b 81
  30: 00 00 00 00 50 00 00 00 00 00 00 00 09 02 00 00
  40: 09 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 01 00 c2 c9 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00
pci 0000:00:1f.6 config space:
  00: 86 80 c6 24 05 00 90 02 03 00 03 07 00 00 00 00
  10: 01 e4 00 00 81 e0 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 8c 81
  30: 00 00 00 00 50 00 00 00 00 00 00 00 09 02 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 01 00 c2 c9 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00
pci 0000:01:00.0 config space:
  00: 02 10 50 4e 07 00 b0 02 00 00 00 03 10 40 00 00
  10: 08 00 00 d0 01 c8 00 00 00 00 5f ff 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 8a 81
  30: 00 00 5c ff 58 00 00 00 00 00 00 00 09 01 08 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 8a 81
  50: 01 00 02 06 00 00 00 00 02 50 20 00 17 02 00 4f
  60: 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:02:01.0 config space:
  00: 4c 10 8e ac 07 00 10 02 00 00 07 06 10 40 82 00
  10: 00 00 00 00 a0 00 00 02 00 00 00 20 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 01 40 03
  40: 4d 10 8f 81 e1 03 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 21 f0 44 28 19 00 90 05 00 00 1f 00 22 1b 00 01
  90: c0 02 64 60 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 01 00 22 7e 00 00 c0 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:02:01.2 config space:
  00: 4c 10 2e 80 16 00 10 02 00 10 00 0c 10 40 80 00
  10: 00 e8 6f ff 00 80 6f ff 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 8f 81
  30: 00 00 00 00 44 00 00 00 00 00 00 00 03 03 03 04
  40: 00 00 00 00 01 00 02 7e 00 80 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 00 00
  f0: 00 00 00 00 82 10 00 00 4d 10 8f 81 00 00 00 00
pci 0000:02:01.3 config space:
  00: 4c 10 8f ac 06 00 10 02 00 00 80 01 10 40 80 00
  10: 00 f0 6f ff 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 90 81
  30: 00 00 00 00 44 00 00 00 00 00 00 00 05 02 07 04
  40: 00 00 00 00 01 00 02 7e 00 00 00 00 20 00 00 00
  50: 4d 10 90 81 05 03 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:02:02.0 config space:
  00: 86 80 20 42 16 00 90 02 05 00 80 02 10 40 00 00
  10: 00 d0 6f ff 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 53 27
  30: 00 00 00 00 dc 00 00 00 00 00 00 00 07 01 03 18
  40: 80 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 c8
  e0: 00 20 00 13 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:02:03.0 config space:
  00: 86 80 76 10 17 00 30 02 00 00 00 02 10 40 00 00
  10: 00 00 6c ff 00 00 6a ff 01 dc 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 8e 81
  30: 00 00 68 ff dc 00 00 00 00 00 00 00 09 01 ff 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 e4 22 c8
  e0: 00 21 00 28 07 00 02 00 00 00 40 00 00 00 00 00
  f0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:02:04.0 config space:
  00: 33 10 35 00 16 00 10 02 43 10 03 0c 10 40 80 00
  10: 00 70 6f ff 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 9a 81
  30: 00 00 00 00 40 00 00 00 00 00 00 00 09 01 01 2a
  40: 01 00 02 fe 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 05 33 b0 6c 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:02:04.1 config space:
  00: 33 10 35 00 16 00 10 02 43 10 03 0c 10 40 00 00
  10: 00 c0 6f ff 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 9a 81
  30: 00 00 00 00 40 00 00 00 00 00 00 00 09 02 01 2a
  40: 01 00 02 fe 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:02:04.2 config space:
  00: 33 10 e0 00 16 00 10 02 04 20 03 0c 10 40 00 00
  10: 00 e4 6f ff 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 10 9a 81
  30: 00 00 00 00 40 00 00 00 00 00 00 00 07 03 10 22
  40: 01 00 02 fe 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 20 20 3f 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 05 33 b0 6c 00 00 00 00 01 00 00 00 00 00 00 c0
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x3ff40 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009fc00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000003ff40000 (usable)
 modified: 000000003ff40000 - 000000003ff50000 (ACPI data)
 modified: 000000003ff50000 - 0000000040000000 (ACPI NVS)
initial memory mapped : 0 - 01c00000
init_memory_mapping: 0000000000000000-000000003ff40000
 0000000000 - 0000400000 page 4k
 0000400000 - 003fc00000 page 2M
 003fc00000 - 003ff40000 page 4k
kernel direct mapping tables up to 3ff40000 @ 10000-15000
ACPI: RSDP 000f53f0 00014 (v00 SONY  )
ACPI: RSDT 3ff40000 0002C (v01   SONY       F1 20040928 MSFT 00000097)
ACPI: FACP 3ff40200 00084 (v02   SONY       F1 20040928 MSFT 00000097)
ACPI: DSDT 3ff40500 03B58 (v01   SONY       F1 20040928 MSFT 0100000D)
ACPI: FACS 3ff50000 00040
ACPI: OEMB 3ff50040 00053 (v01   SONY       F1 20040928 MSFT 00000097)
1023MB LOWMEM available.
  mapped low ram: 0 - 3ff40000
  low ram: 0 - 3ff40000
  node 0 low ram: 00000000 - 3ff40000
  node 0 bootmap 00011000 - 00018fe8
(6 early reservations) ==> bootmem [0000000000 - 003ff40000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 00016999b4]    TEXT DATA BSS ==> [0001000000 - 00016999b4]
  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #3 [000169a000 - 00016a1104]              BRK ==> [000169a000 - 00016a1104]
  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #5 [0000011000 - 0000019000]          BOOTMAP ==> [0000011000 - 0000019000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0003ff40
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003ff40
On node 0 totalpages: 261839
free_area_init_node: node 0, pgdat b159bea4, node_mem_map b16a2200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 2015 pages used for memmap
  Normal zone: 255841 pages, LIFO batch:31
Allocating PCI resources starting at 40000000 (gap: 40000000:c0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259792
Kernel command line: root=/dev/sda2 rootfstype=xfs hpet=force dyntick=enable radeon.modeset=0 pci=earlydump
PID hash table entries: 4096 (order: 12, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Memory: 1031336k/1047808k available (3914k kernel code, 15800k reserved, 1860k data, 252k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
    vmalloc : 0xf0740000 - 0xfffe3000   ( 248 MB)
    lowmem  : 0xb0000000 - 0xeff40000   (1023 MB)
      .init : 0xb15a6000 - 0xb15e5000   ( 252 kB)
      .data : 0xb13d2be9 - 0xb15a3cd0   (1860 kB)
      .text : 0xb1000000 - 0xb13d2be9   (3914 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:16
Fast TSC calibration using PIT
Detected 1794.313 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Calibrating delay loop (skipped), value calculated using timer frequency.. 3590.15 BogoMIPS (lpj=5981043)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
mce: CPU supports 5 MCE banks
CPU: Intel(R) Pentium(R) M processor 1.80GHz stepping 06
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090521
ACPI: setting ELCR to 0200 (from 02b8)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [8086:3340] class 000600 header type 00
pci 0000:00:00.0: reg 10 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:00:00.0: calling asus_hides_smbus_hostbridge+0x0/0x1f3
pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:01.0: found [8086:3341] class 000604 header type 01
pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1d.0: found [8086:24c2] class 000c03 header type 00
pci 0000:00:1d.0: reg 20 io port: [0xe800-0xe81f]
pci 0000:00:1d.0: calling asus_hides_smbus_hostbridge+0x0/0x1f3
pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1d.1: found [8086:24c4] class 000c03 header type 00
pci 0000:00:1d.1: reg 20 io port: [0xe880-0xe89f]
pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1d.2: found [8086:24c7] class 000c03 header type 00
pci 0000:00:1d.2: reg 20 io port: [0xec00-0xec1f]
pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1d.7: found [8086:24cd] class 000c03 header type 00
pci 0000:00:1d.7: reg 10 32bit mmio: [0xff7ffc00-0xff7fffff]
pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: found [8086:2448] class 000604 header type 01
pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1f.0: found [8086:24cc] class 000601 header type 00
pci 0000:00:1f.0: calling old_ich_force_enable_hpet_user+0x0/0xf
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: calling asus_hides_smbus_lpc+0x0/0xa2
pci 0000:00:1f.0: calling quirk_ich4_lpc_acpi+0x0/0x5f
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH4 GPIO
pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1f.1: found [8086:24ca] class 000101 header type 00
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1f.1: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1f.3: found [8086:24c3] class 000c05 header type 00
pci 0000:00:1f.3: reg 20 io port: [0x540-0x55f]
pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1f.5: found [8086:24c5] class 000401 header type 00
pci 0000:00:1f.5: reg 10 io port: [0xee00-0xeeff]
pci 0000:00:1f.5: reg 14 io port: [0xe000-0xe03f]
pci 0000:00:1f.5: reg 18 32bit mmio: [0xff7ff800-0xff7ff9ff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0xff7ff400-0xff7ff4ff]
pci 0000:00:1f.5: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: found [8086:24c6] class 000703 header type 00
pci 0000:00:1f.6: reg 10 io port: [0xe400-0xe4ff]
pci 0000:00:1f.6: reg 14 io port: [0xe080-0xe0ff]
pci 0000:00:1f.6: calling quirk_resource_alignment+0x0/0x163
pci 0000:00:1f.6: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
PCI: Fixups for bus 0000:00
pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
PCI: Scanning bus 0000:01
pci 0000:01:00.0: found [1002:4e50] class 000300 header type 00
pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x20
pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:01:00.0: reg 14 io port: [0xc800-0xc8ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xff5f0000-0xff5fffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xff5c0000-0xff5dffff]
pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:01:00.0: supports D1 D2
PCI: Fixups for bus 0000:01
pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:01.0: bridge 32bit mmio: [0xff500000-0xff5fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xce900000-0xde9fffff]
PCI: Bus scan for 0000:01 returning with max=01
pci 0000:00:1e.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
pci 0000:02:01.0: found [104c:ac8e] class 000607 header type 02
pci 0000:02:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:02:01.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:01.0: supports D1 D2
pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot
pci 0000:02:01.0: PME# disabled
pci 0000:02:01.2: found [104c:802e] class 000c00 header type 00
pci 0000:02:01.2: reg 10 32bit mmio: [0xff6fe800-0xff6fefff]
pci 0000:02:01.2: reg 14 32bit mmio: [0xff6f8000-0xff6fbfff]
pci 0000:02:01.2: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:01.2: supports D1 D2
pci 0000:02:01.2: PME# supported from D0 D1 D2 D3hot
pci 0000:02:01.2: PME# disabled
pci 0000:02:01.3: found [104c:ac8f] class 000180 header type 00
pci 0000:02:01.3: reg 10 32bit mmio: [0xff6ff000-0xff6fffff]
pci 0000:02:01.3: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:01.3: supports D1 D2
pci 0000:02:01.3: PME# supported from D0 D1 D2 D3hot
pci 0000:02:01.3: PME# disabled
pci 0000:02:02.0: found [8086:4220] class 000280 header type 00
pci 0000:02:02.0: reg 10 32bit mmio: [0xff6fd000-0xff6fdfff]
pci 0000:02:02.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:02.0: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
pci 0000:02:02.0: PME# disabled
pci 0000:02:03.0: found [8086:1076] class 000200 header type 00
pci 0000:02:03.0: reg 10 32bit mmio: [0xff6c0000-0xff6dffff]
pci 0000:02:03.0: reg 14 32bit mmio: [0xff6a0000-0xff6bffff]
pci 0000:02:03.0: reg 18 io port: [0xdc00-0xdc3f]
pci 0000:02:03.0: reg 30 32bit mmio: [0xff680000-0xff69ffff]
pci 0000:02:03.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:03.0: calling pci_fixup_transparent_bridge+0x0/0x27
pci 0000:02:03.0: PME# supported from D0 D3hot D3cold
pci 0000:02:03.0: PME# disabled
pci 0000:02:04.0: found [1033:0035] class 000c03 header type 00
pci 0000:02:04.0: reg 10 32bit mmio: [0xff6f7000-0xff6f7fff]
pci 0000:02:04.0: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:04.0: supports D1 D2
pci 0000:02:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:04.0: PME# disabled
pci 0000:02:04.1: found [1033:0035] class 000c03 header type 00
pci 0000:02:04.1: reg 10 32bit mmio: [0xff6fc000-0xff6fcfff]
pci 0000:02:04.1: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:04.1: supports D1 D2
pci 0000:02:04.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:04.1: PME# disabled
pci 0000:02:04.2: found [1033:00e0] class 000c03 header type 00
pci 0000:02:04.2: reg 10 32bit mmio: [0xff6fe400-0xff6fe4ff]
pci 0000:02:04.2: calling quirk_resource_alignment+0x0/0x163
pci 0000:02:04.2: supports D1 D2
pci 0000:02:04.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:04.2: PME# disabled
PCI: Fixups for bus 0000:02
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xff600000-0xff6fffff]
pci 0000:00:1e.0: bridge 32bit mmio pref: [0xdea00000-0xdeafffff]
pci 0000:02:01.0: scanning behind bridge, config 000000, pass 0
pci 0000:02:01.0: bus configuration invalid, reconfiguring
pci 0000:02:01.0: scanning behind bridge, config 000000, pass 1
PCI: Bus #03 (-#06) is partially hidden behind transparent bridge #02 (-#02)
PCI: Bus scan for 0000:02 returning with max=06
pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
pci 0000:00:1e.0: scanning behind bridge, config 020200, pass 1
PCI: Bus scan for 0000:00 returning with max=06
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 7 9)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9)
ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 9)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
cfg80211: Calling CRDA to update world regulatory domain
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0xfe00-0xfe01 has been reserved
system 00:08: iomem range 0xff800000-0xffbfffff has been reserved
system 00:08: iomem range 0xffc00000-0xffffffff has been reserved
system 00:09: ioport range 0x400-0x47f has been reserved
system 00:09: ioport range 0x500-0x53f has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
pci 0000:02:03.0: BAR 6: address space collision on of device [0xff680000-0xff69ffff]
pci 0000:00:1f.1: BAR 5: got res [0x40000000-0x400003ff] bus [0x40000000-0x400003ff] flags 0x20200
pci 0000:00:1f.1: BAR 5: moved to bus [0x40000000-0x400003ff] flags 0x20200
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xc000-0xcfff
pci 0000:00:01.0:   MEM window: 0xff500000-0xff5fffff
pci 0000:00:01.0:   PREFETCH window: 0xce900000-0xde9fffff
pci 0000:02:03.0: BAR 6: got res [0xdea00000-0xdea1ffff] bus [0xdea00000-0xdea1ffff] flags 0x27200
pci 0000:02:01.0: BAR 0: got res [0xff600000-0xff600fff] bus [0xff600000-0xff600fff] flags 0x20200
pci 0000:02:01.0: BAR 0: moved to bus [0xff600000-0xff600fff] flags 0x20200
pci 0000:02:01.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:01.0:   IO window: 0x00d000-0x00d0ff
pci 0000:02:01.0:   IO window: 0x00d400-0x00d4ff
pci 0000:02:01.0:   PREFETCH window: 0x44000000-0x47ffffff
pci 0000:02:01.0:   MEM window: 0x48000000-0x4bffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
pci 0000:00:1e.0:   MEM window: 0xff600000-0xff6fffff
pci 0000:00:1e.0:   PREFETCH window: 0xdea00000-0xdeafffff
pci 0000:00:1e.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
pci 0000:02:01.0: PCI INT A -> Link[LNKF] -> GSI 9 (level, low) -> IRQ 9
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:01: resource 1 mem: [0xff500000-0xff5fffff]
pci_bus 0000:01: resource 2 pref mem [0xce900000-0xde9fffff]
pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:02: resource 1 mem: [0xff600000-0xff6fffff]
pci_bus 0000:02: resource 2 pref mem [0xdea00000-0xdeafffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:03: resource 0 io:  [0xd000-0xd0ff]
pci_bus 0000:03: resource 1 io:  [0xd400-0xd4ff]
pci_bus 0000:03: resource 2 pref mem [0x44000000-0x47ffffff]
pci_bus 0000:03: resource 3 mem: [0x48000000-0x4bffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
cpu0(1) debug files 135
microcode: CPU0 sig=0x6d6, pf=0x20, revision=0x17
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Scanning for low memory corruption every 60 seconds
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with security attributes, no debug enabled
msgmni has been set to 2014
alg: No test for stdrng (krng)
alg: No test for stdrng (ansi_cprng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:00.0: calling pci_fixup_video+0x0/0x91
pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:01.0: calling pci_fixup_video+0x0/0x91
pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1d.0: calling pci_fixup_video+0x0/0x91
pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1d.1: calling pci_fixup_video+0x0/0x91
pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1d.2: calling pci_fixup_video+0x0/0x91
pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1d.7: calling pci_fixup_video+0x0/0x91
pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1e.0: calling pci_fixup_video+0x0/0x91
pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1f.0: calling pci_fixup_video+0x0/0x91
pci 0000:00:1f.1: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1f.1: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1f.1: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1f.1: calling pci_fixup_video+0x0/0x91
pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1f.3: calling pci_fixup_video+0x0/0x91
pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1f.5: calling pci_fixup_video+0x0/0x91
pci 0000:00:1f.6: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:00:1f.6: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:00:1f.6: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:00:1f.6: calling pci_fixup_video+0x0/0x91
pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:01:00.0: calling pci_fixup_video+0x0/0x91
pci 0000:01:00.0: Boot video device
pci 0000:02:01.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:01.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:01.0: calling pci_fixup_video+0x0/0x91
pci 0000:02:01.2: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:01.2: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:01.2: calling pci_fixup_video+0x0/0x91
pci 0000:02:01.3: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:01.3: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:01.3: calling pci_fixup_video+0x0/0x91
pci 0000:02:02.0: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:02:02.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:02.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:02.0: calling pci_fixup_video+0x0/0x91
pci 0000:02:03.0: calling quirk_e100_interrupt+0x0/0x14f
pci 0000:02:03.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:03.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:03.0: calling pci_fixup_video+0x0/0x91
pci 0000:02:04.0: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:04.0: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:04.0: calling pci_fixup_video+0x0/0x91
pci 0000:02:04.1: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:04.1: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:04.1: calling pci_fixup_video+0x0/0x91
pci 0000:02:04.2: calling quirk_cardbus_legacy+0x0/0x1d
pci 0000:02:04.2: calling quirk_usb_early_handoff+0x0/0x55b
pci 0000:02:04.2: calling pci_fixup_video+0x0/0x91
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
Marking TSC unstable due to TSC halts in idle
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor LNXCPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
Switched to high resolution mode on CPU 0
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [ATF0] (57 C)
sonypi: Sony Programmable I/O Controller Driver v1.26.
Platform driver 'sonypi' needs updating - please use dev_pm_ops
ACPI: Battery Slot [BAT1] (battery present)
sonypi: please try the sony-laptop module instead and report failures, see also http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
sonypi: detected type2 model, verbose = 0, fnkeyinit = off, camera = off, compat = off, mask = 0xffffffff, useinput = on, acpi = on
sonypi: enabled at irq=11, port1=0x1080, port2=0x1084
sonypi: device allocated minor is 61
input: Sony Vaio Jogdial as /devices/platform/sonypi/input/input2
input: Sony Vaio Keys as /devices/platform/sonypi/input/input3
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 855PM Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 9
pci 0000:01:00.0: PCI INT A -> Link[LNKE] -> GSI 9 (level, low) -> IRQ 9
[drm] Initialized radeon 1.30.0 20080528 for 0000:01:00.0 on minor 0
loop: module loaded
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
tifm_7xx1 0000:02:01.3: PCI INT B -> Link[LNKG] -> GSI 5 (level, low) -> IRQ 5
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 7 (level, low) -> IRQ 7
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
e1000 0000:02:03.0: PCI INT A -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
tifm_core: MMC/SD card detected in socket 0:0
e1000: 0000:02:03.0: e1000_probe: (PCI:33MHz:32-bit) 08:00:46:d8:b6:1d
ata2.00: ATAPI: SONY    DVD RW DW-U55A, 2.5b, max UDMA/33
ata1.00: ATA-7: ST910021A, 3.04, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata2.00: configured for UDMA/33
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST910021A        3.04 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            SONY     DVD RW DW-U55A   2.5b PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
 sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
firewire_ohci 0000:02:01.2: PCI INT C -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
firewire_ohci: Added fw-ohci device 0000:02:01.2, OHCI version 1.10
yenta_cardbus 0000:02:01.0: CardBus bridge found [104d:818f]
yenta_cardbus 0000:02:01.0: Using CSCINT to route CSC interrupts to PCI
yenta_cardbus 0000:02:01.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:01.0: TI: mfunc 0x01001b22, devctl 0x64
yenta_cardbus 0000:02:01.0: ISA IRQ mask 0x0450, PCI irq 9
yenta_cardbus 0000:02:01.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #02 to #06
yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge I/O window: 0xd000 - 0xdfff
yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge Memory window: 0xff600000 - 0xff6fffff
yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge Memory window: 0xdea00000 - 0xdeafffff
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 3, io mem 0xff7ffc00
firewire_net: firewire0: IPv4 over FireWire on device 0800460301a42b6f
firewire_core: created device fw0: GUID 0800460301a42b6f, S400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31-rc5-00246-g90bc1a6 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:02:04.2: PCI INT C -> Link[LNKC] -> GSI 7 (level, low) -> IRQ 7
ehci_hcd 0000:02:04.2: EHCI Host Controller
ehci_hcd 0000:02:04.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:02:04.2: irq 7, io mem 0xff6fe400
ehci_hcd 0000:02:04.2: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.31-rc5-00246-g90bc1a6 ehci_hcd
usb usb2: SerialNumber: 0000:02:04.2
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 9
ohci_hcd 0000:02:04.0: PCI INT A -> Link[LNKA] -> GSI 9 (level, low) -> IRQ 9
ohci_hcd 0000:02:04.0: OHCI Host Controller
ohci_hcd 0000:02:04.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:02:04.0: irq 9, io mem 0xff6f7000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.31-rc5-00246-g90bc1a6 ohci_hcd
usb usb3: SerialNumber: 0000:02:04.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci_hcd 0000:02:04.1: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
ohci_hcd 0000:02:04.1: OHCI Host Controller
ohci_hcd 0000:02:04.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:02:04.1: irq 9, io mem 0xff6fc000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.31-rc5-00246-g90bc1a6 ohci_hcd
usb usb4: SerialNumber: 0000:02:04.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 9 (level, low) -> IRQ 9
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 9, io base 0x0000e800
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.31-rc5-00246-g90bc1a6 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 4
PCI: setting IRQ 4 as level-triggered
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 4 (level, low) -> IRQ 4
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 4, io base 0x0000e880
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.31-rc5-00246-g90bc1a6 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 7 (level, low) -> IRQ 7
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 7, io base 0x0000ec00
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.31-rc5-00246-g90bc1a6 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Platform driver 'i8042' needs updating - please use dev_pm_ops
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Bluetooth: Generic Bluetooth USB driver ver 0.5
usbcore: registered new interface driver btusb
cpuidle: using governor ladder
cpuidle: using governor menu
wacom driver registered
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.20.
Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
Intel ICH 0000:00:1f.5: setting latency timer to 64
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input5
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input6
usb 3-1: new low speed USB device using ohci_hcd and address 2
usb 3-1: New USB device found, idVendor=046d, idProduct=c50a
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: USB Receiver
usb 3-1: Manufacturer: Logitech
usb 3-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:04.0/usb3/3-1/3-1:1.0/input/input7
generic-usb 0003:046D:C50A.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:02:04.0-1/input0
intel8x0_measure_ac97_clock: measured 53214 usecs (2564 samples)
intel8x0: clocking to 48000
ALSA device list:
  #0: Intel 82801DB-ICH4 with ALC203 at irq 9
NET: Registered protocol family 26
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP cubic registered
TCP vegas registered
TCP scalable registered
TCP yeah registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
Mobile IPv6
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
ip6tnl0: Disabled Privacy Extensions
NET: Registered protocol family 17
Bridge firewalling registered
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
rtc_cmos 00:02: setting system clock to 2009-08-05 19:04:55 UTC (1249499095)
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
XFS mounting filesystem sda2
usb 3-2: new full speed USB device using ohci_hcd and address 3
Ending clean XFS mount for filesystem: sda2
VFS: Mounted root (xfs filesystem) readonly on device 8:2.
Freeing unused kernel memory: 252k freed
usb 3-2: New USB device found, idVendor=044e, idProduct=3007
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: UGX
usb 3-2: Manufacturer: ALPS
Clocksource tsc unstable (delta = -276686096 ns)
usb 3-2: configuration #1 chosen from 1 choice
udev: starting version 141
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
sony-laptop: Sony Notebook Control Driver v0.6.
input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:10/SNY5001:00/input/input8
input: Sony Vaio Jogdial as /devices/virtual/input/input9
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kdmprq
ipw2200: Copyright(c) 2003-2006 Intel Corporation
ipw2200 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 7 (level, low) -> IRQ 7
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
ipw2200 0000:02:02.0: firmware: requesting ipw2200-bss.fw
ipw2200: Detected geography ZZD (13 802.11bg channels, 0 802.11a channels)
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
Adding 987956k swap on /dev/sda6.  Priority:-1 extents:1 across:987956k 
ADDRCONF(NETDEV_UP): eth0: link is not ready
lib80211_crypt: registered algorithm 'WEP'
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth1: no IPv6 routers present
