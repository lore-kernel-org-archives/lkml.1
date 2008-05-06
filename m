Return-Path: <linux-kernel-owner+w=401wt.eu-S1764177AbYEFAbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764177AbYEFAbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763921AbYEFAb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:31:27 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:18923 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763665AbYEFAb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:31:26 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Microblaze: implement dma-coherent API andrefactorcache flush code.
Date: Mon, 5 May 2008 17:31:07 -0700
In-reply-to: <1210032899.5798.179.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Microblaze: implement dma-coherent API andrefactorcache flush code.
Thread-Index: AcivDls/AtY1noHiSgCdVEtvoNvaEgAAe4pw
References: <20080505223706.1236C1C8004E@mail131-sin.bigfish.com> <1210028237.5798.121.camel@localhost> <20080505231206.922A61C780C0@mail19-wa4.bigfish.com> <1210032899.5798.179.camel@localhost>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "John Williams" <john.williams@petalogix.com>
Cc: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <matthew@wil.cx>,
       <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 May 2008 00:31:03.0397 (UTC) FILETIME=[772F1150:01C8AF10]
Message-Id: <20080506003104.4717D19B8050@mail213-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Monday, May 05, 2008 5:15 PM
> To: Stephen Neuendorffer
> Cc: arnd@arndb.de; linux-arch@vger.kernel.org; John Linn;
matthew@wil.cx; will.newton@gmail.com;
> drepper@redhat.com; microblaze-uclinux@itee.uq.edu.au;
grant.likely@secretlab.ca; Michal Simek;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] Microblaze: implement dma-coherent API
andrefactorcache flush code.
> 
> 
> > > Does the DMA API insist upon the dma_cache_sync call to guarantee
> > > sensible results?  If so, your implementation looks fine.  If not,
> > then
> > > the results will clearly be bogus as there's nothing magical about
the
> > > memory being allocated in dma_alloc.
> >
> > Yes, in fact this is one of the keys to getting the lltemac driver
to
> > work right.  see Documentation/DMA-API.txt
> >
> > > To that end, can it just call kmalloc(), and similarly kfree() for
> > > dma_free?
> >
> > My understanding is that on other architectures (x86, for instance)
> > 'dma' memory ensures other things, like it's accessible in PCI
memory
> > space.  On microblaze, there's nothing really special about dma
memory,
> > but you get the API as a chunk.
> 
> Sure - what I meant is can dma_alloc just call kmalloc to do it's
work?

I scanned through Linux Device Drivers, and it appears that calling
get_free_pages is:
1) more efficient than kmalloc for large allocations
2) allocates physically contiguous memory, which kmalloc doesn't
necessarily do if there's an mmu.

Steve

