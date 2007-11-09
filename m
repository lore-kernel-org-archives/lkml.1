Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbXKIBy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbXKIBy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbXKIByU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:54:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36727 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758110AbXKIByU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:54:20 -0500
Date: Thu, 8 Nov 2007 17:54:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zou, Nanhai" <nanhai.zou@intel.com>
cc: Mel Gorman <mel@skynet.ie>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: RE: [Patch] Allocate sparse vmemmap block above 4G
In-Reply-To: <10EA09EFD8728347A513008B6B0DA77A01751532@pdsmsx411.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0711081749250.11392@schroedinger.engr.sgi.com>
References: <1194483127.3046.1471.camel@linux-znh> <20071108140705.GA2591@skynet.ie>
 <10EA09EFD8728347A513008B6B0DA77A01751532@pdsmsx411.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Zou, Nanhai wrote:

> > More magic values, both the 4GiB address here and the magic "1" at the
> > end are problems.
> > 
> Yes, the 4UL*1024*1024*1024 could be a define here.

The 4GB boundary here is MAX_DMA32_ADDRESS I guess? We are only having 
this problem because of the two DMA zones on x86_64. I thought Andi was 
getting rid of the first one at 16MB. If he would do so then ZONE_DMA 
could be used instead of DMA32 and everything will be fine.

For now you may want to put

#ifdef CONFIG_ZONE_DMA32

around this code since it depends on DMA32.
