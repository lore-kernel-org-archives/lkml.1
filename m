Return-Path: <linux-kernel-owner+w=401wt.eu-S936723AbXGTTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936723AbXGTTU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936397AbXGTTTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:19:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:60523 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935453AbXGTTTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:19:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,563,1175497200"; 
   d="scan'208";a="108310981"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 20 Jul 2007 12:19:03 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32903445DBE@orsmsx414.amr.corp.intel.com>
In-Reply-To: <aday7hac2vf.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
thread-index: AcfLAPLQ/jRig8XJS16lciP71280VwAALT6Q
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
       <jeff@garzik.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 19:19:05.0477 (UTC) FILETIME=[D6A3A350:01C7CB02]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, I see I don't understand what this driver is doing.  
> What is a "struct ioatdma_device"?  Is this driver requesting 
> interrupts that come from the NIC or the IOAT DMA engine?

I might have caused some confusion.  You had asked if any drivers
support MSI but not MSI-X, so I threw 2 drivers out there that currently
support both, and why we support MSI for compatibility.

> Anyway, if the NICs support MSI-X, is there any chance of 
> failing to get one MSI-X vectors but then succeeding in 
> getting MSI enabled?
> How could that happen?  I don't see what falling back to MSI 
> buys you beyond more code.

MSI-X doesn't make much sense if you have 1 Rx queue on your NIC, since
1 vector essentially acts like MSI.  In the case of why MSI-X could
fail, I have had it fail when I misconfigured my driver and didn't ask
for enough vectors for what I was assigning, so the driver disabled the
multiple Rx queues, and fell back to MSI.

I hope this helps.

-PJ
