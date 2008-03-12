Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYCLBVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYCLBVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYCLBVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:21:24 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43234 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751367AbYCLBVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:21:23 -0400
From: akepner@sgi.com
Date: Tue, 11 Mar 2008 18:19:54 -0700
To: Michael Ellerman <michael@ellerman.id.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Mark Nelson <mdnelson@au1.ibm.com>
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080312011954.GN12370@sgi.com>
References: <20080228032448.GS11012@sgi.com> <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com> <20080229182504.GA18102@colo.lackof.org> <1204310276.4003.48.camel@localhost.localdomain> <20080305181307.GR17802@sgi.com> <1204783306.14874.37.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204783306.14874.37.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a new proposal for the documentation portion of this 
patchset. The code changes essentially amount to 
s/DMA_ATTR_SYNC_ON_WRITE/DMA_ATTR_BARRIER/ so thought I'd send 
just the doc change for comments now.

The description of the DMA_ATTR_BARRIER is now very short and 
generic - no particular architecture is even mentioned. I can add 
a sentence or two near the architecture-specific changes in 
arch/ia64/sn/pci/pci_dma.c about why the implementation works 
on ia64/sn, etc.

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index e69de29..a4106ec 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -0,0 +1,24 @@
+			DMA attributes
+			==============
+
+This document describes the semantics of the DMA attributes that are 
+defined in linux/dma-attrs.h. 
+
+DMA_ATTR_BARRIER
+----------------
+
+DMA_ATTR_BARRIER is a barrier attribute for DMA.  DMA to a memory 
+region with the DMA_ATTR_BARRIER attribute forces all pending DMA 
+writes to complete, and thus provides a mechanism to strictly order 
+DMA from a device across all intervening busses and bridges.  This 
+barrier is not specific to a particular type of interconnect, it 
+applies to the system as a whole, and so its implementation must 
+account for the idiosyncracies of the system all the way from the 
+DMA device to memory. 
+
+As an example of a situation where DMA_ATTR_BARRIER would be useful, 
+suppose that a device does a DMA write to indicate that data is ready 
+and available in memory.  The DMA of the "completion indication" could
+race with data DMA.  Mapping the memory used for completion indications 
+with DMA_ATTR_BARRIER would prevent the race.
+

