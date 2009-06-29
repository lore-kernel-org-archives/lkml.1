Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZF2Oqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZF2Oqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZF2Oqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:46:43 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:26760 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZF2Oql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:46:41 -0400
MIME-Version: 1.0
Message-ID: <5331ec14-c599-4317-bd5b-55911b8ee916@default>
Date: Mon, 29 Jun 2009 07:44:50 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>, linux-embedded@vger.kernel.org
Subject: RE: [RFC] transcendent memory for Linux
In-Reply-To: <63386a3d0906270618h5be01265v759f5acd1f49682f@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A48D379.0154:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: Linus Walleij [mailto:linus.ml.walleij@gmail.com]
> Sent: Saturday, June 27, 2009 7:19 AM
> Subject: Re: [RFC] transcendent memory for Linux
> 
> > We call this latter class "transcendent memory" and it
> > provides an interesting opportunity to more efficiently
> > utilize RAM in a virtualized environment.  However this
> > "memory but not really memory" may also have applications
> > in NON-virtualized environments, such as hotplug-memory
> > deletion, SSDs, and page cache compression.  Others have
> > suggested ideas such as allowing use of highmem memory
> > without a highmem kernel, or use of spare video memory.
> 
> Here is what I consider may be a use case from the embedded
> world: we have to save power as much as possible, so we need
> to shut off entire banks of memory.
> 
> Currently people do things like put memory into self-refresh
> and then sleep, but for long lapses of time you would
> want to compress memory towards lower addresses and
> turn as many banks as possible off.
> 
> So we have something like 4x16MB banks of RAM = 64MB RAM,
> and the most necessary stuff easily fits in one of them.
> If we can shut down 3x16MB we save 3 x power supply of the
> RAMs.
> 
> However in embedded we don't have any swap, so we'd need
> some call that would attempt to remove a memory by paging
> out code and data that has been demand-paged in
> from the FS but no dirty pages, these should instead be
> moved down to memory which will be retained, and the
> call should fail if we didn't succeed to migrate all
> dirty pages.
> 
> Would this be possible with transcendent memory?

Yes, I think this would work nicely as a use case for tmem.

As Avi points out, you could do this with memory defragmentation,
but if you know in advance that you will be frequently
powering on and off a bank of RAM, you could put only
ephemeral memory into it (enforced by a kernel policy and
the tmem API), then defragmentation (and compression towards
lower addresses) would not be necessary, and you could power
off a bank with no loss of data.

One issue though: I would guess that copying pages of memory
could be very slow in an inexpensive embedded processor.

Dan
