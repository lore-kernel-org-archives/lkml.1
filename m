Return-Path: <linux-kernel-owner+w=401wt.eu-S934568AbXHWAGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934568AbXHWAGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934444AbXHWAGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:06:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:59629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933894AbXHWAF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,296,1183359600"; 
   d="scan'208";a="120469008"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Date: Wed, 22 Aug 2007 17:05:54 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023B307D@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070822235445.GG89849@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Thread-Index: AcflF9QTbcbMbN/lR5uxfvZmG4Jq6wAAJ5fg
References: <46CC48FD.4000607@linux.vnet.ibm.com> <20070822091959.aa38fd3e.akpm@linux-foundation.org> <20070822172541.GA8058@bingen.suse.de> <46CC811C.9010600@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com> <46CCB79E.7070109@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2F6A@scsmsx411.amr.corp.intel.com> <20070822231111.GD89849@sgi.com> <617E1C2C70743745A92448908E030B2A023B2FD5@scsmsx411.amr.corp.intel.com> <20070822235445.GG89849@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jeremy Higdon" <jeremy@sgi.com>
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 23 Aug 2007 00:05:55.0439 (UTC) FILETIME=[60352FF0:01C7E519]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm.  Must be something else going on then.  It should be less than 1MB
> per ioc plus whatever is used for streaming I/O.
>
> | mptbase: Initiating ioc2 bringup                              | GSI 16 (level, low) -> CPU 2 (0xc418) vector 50
> | ioc2: LSI53C1030 C0: Capabilities={Initiator}                 | ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) ->
> | DMA: Out of SW-IOMMU space for 263200 bytes at device ?       | uhci_hcd 0000:00:1d.0: UHCI Host Controller
> | Kernel panic - not syncing: DMA: Memory would be corrupted    | uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus n

I traced the pci_alloc_consistent calls from PrimeIocFifos on my
system.  There are two calls for each ioc.  The first is for
266368 bytes, the second for 16320 bytes.

I wonder why Kamalesh's system wants the slightly different
amount (263200 bytes) from what my system asks for?

It also looks to be a little unfriendly to swiotlb to ask for
more than 256K at a time (see IO_TLB_SEGSIZE) in swiotlb.c

-Tony
