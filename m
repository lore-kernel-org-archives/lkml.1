Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbXBFJJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbXBFJJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXBFJJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:09:01 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:35939 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbXBFJJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:09:00 -0500
Message-ID: <45C845AA.3010702@s5r6.in-berlin.de>
Date: Tue, 06 Feb 2007 10:08:58 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Moore <dcm@mit.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>, discuss@x86-64.org,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
References: <1170614380.26464.52.camel@PISCES.MIT.EDU> <20070205133556.9b290d0a.akpm@linux-foundation.org> <200702060856.45473.ak@suse.de> <45C84399.70407@s5r6.in-berlin.de>
In-Reply-To: <45C84399.70407@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Unfortunately an author of lib/swiotlb.c chose to call many variables
> holding *virtual* addresses "dma_addr". Note how that file at the same
> time contains variables like "dma_addr_t dma_handle".

And there is even one occurrence of a "dma_addr" holding a physical
address/ bus address, unlike the other dma_addr's:
int
swiotlb_dma_mapping_error(dma_addr_t dma_addr)
{
	return (dma_addr == virt_to_phys(io_tlb_overflow_buffer));
}
-- 
Stefan Richter
-=====-=-=== --=- --==-
http://arcgraph.de/sr/
