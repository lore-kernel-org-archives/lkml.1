Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYDRR4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYDRR4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbYDRR4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:56:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:51429 "EHLO
	outbound10-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758927AbYDRR4J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:56:09 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] Re: Microblaze Linux release
Date: Fri, 18 Apr 2008 10:56:00 -0700
In-reply-to: <4804A59B.5040909@seznam.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] Re: Microblaze Linux release
Thread-Index: AcifD6fcD6twljegTIK/2BNqnQNdJQCbKFow
References: <48020A21.4000404@seznam.cz> <200804140538.30268.arnd@arndb.de> <200804140801.57464.arnd@arndb.de> <4804A59B.5040909@seznam.cz>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>, "Arnd Bergmann" <arnd@arndb.de>
Cc: "John Williams" <john.williams@petalogix.com>,
       <jwboyer@linux.vnet.ibm.com>, <benh@kernel.crashing.org>,
       "John Linn" <linnj@xilinx.com>, "git-dev" <git-dev@xilinx.com>,
       "Grant Likely" <grant.likely@secretlab.ca>, "git" <git@xilinx.com>,
       <linux-kernel@vger.kernel.org>, <paulus@samba.org>
X-OriginalArrivalTime: 18 Apr 2008 17:56:01.0360 (UTC) FILETIME=[76A57D00:01C8A17D]
Message-Id: <20080418175602.5E15E670052@mail81-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > * the consistent.c implementation looks strange. Is any of that code
> > even used anywhere? What is it good for, considering that you don't
have
> > an mmu?
> 
> We have prepared MMU code. I hope that this code for FDT kernel comes
soon.
> This code is written by John Williams. I have never changed it. I see
that this
> code solves problems around ucached_shadows stuff.
>
http://developer.petalogix.com/wiki/UserGuide/AdvancedTopics/EnablingUnc
achedShadow
> JW. Can you comment this?

It probably makes sense to grab: arch/microblaze/mm/dma-coherent.c from
git.xilinx.com and drop consistent.c.  I believe this is the more
'modern' way to implement this functionality.  I think it's easiest for
you to just grab this file.

> > * Your dma_mapping.h does BUG() for almost everything. I suspect you
could
> > easily replace it with a trivial implementation, like the x86_32
one.
> 
> OK. I'll synchronize this.

This is also in git.xilinx.com.

> > * You don't seem to have any code for PCI, so the pci.h and
pci-bridge.h
> > files don't make much sense.
> 
> Yes you are right. I don't have any PCI code but I think that this
code for MB
> exists. Steve or John: Do you have any code for PCI?

I'd recommend dropping anything having to do with PCI: I don't know that
there is much interest in it on microblaze.

Other comments:

memset/memmove/memcpy are broken under gcc4.  There are fixed versions
of this at git.xilinx.com.  Again, it's probably easiest if you just
grab the files directly.

It would also be good to have irq_of_parse_and_map, which drivers will
need.  I'll send you a patch for this one.

Steve


