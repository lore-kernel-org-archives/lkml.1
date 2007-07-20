Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbXGTTtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbXGTTtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762879AbXGTTt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:49:28 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:4171 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761333AbXGTTt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:49:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAD+voEarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,563,1175497200"; 
   d="scan'208"; a="167627391:sNHT40403214"
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
       <jeff@garzik.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
X-Message-Flag: Warning: May contain useful information
References: <D5C1322C3E673F459512FB59E0DDC32903445DBE@orsmsx414.amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 12:49:24 -0700
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC32903445DBE@orsmsx414.amr.corp.intel.com> (Waskiewicz Jr's message of "Fri, 20 Jul 2007 12:19:03 -0700")
Message-ID: <adair8ec0u3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jul 2007 19:49:25.0260 (UTC) FILETIME=[13507CC0:01C7CB07]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Hmm, I see I don't understand what this driver is doing.  
 > > What is a "struct ioatdma_device"?  Is this driver requesting 
 > > interrupts that come from the NIC or the IOAT DMA engine?
 > 
 > I might have caused some confusion.  You had asked if any drivers
 > support MSI but not MSI-X, so I threw 2 drivers out there that currently
 > support both, and why we support MSI for compatibility.
 > 
 > > Anyway, if the NICs support MSI-X, is there any chance of 
 > > failing to get one MSI-X vectors but then succeeding in 
 > > getting MSI enabled?
 > > How could that happen?  I don't see what falling back to MSI 
 > > buys you beyond more code.
 > 
 > MSI-X doesn't make much sense if you have 1 Rx queue on your NIC, since
 > 1 vector essentially acts like MSI.  In the case of why MSI-X could
 > fail, I have had it fail when I misconfigured my driver and didn't ask
 > for enough vectors for what I was assigning, so the driver disabled the
 > multiple Rx queues, and fell back to MSI.

OK, let's try to avoid going off into the weeds here.  In the context
of the specific patch that this thread started with, is there any
point in having both "msix-single-vector" and "msi" interrupt support?

 - R.
