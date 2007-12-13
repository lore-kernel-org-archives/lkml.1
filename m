Return-Path: <linux-kernel-owner+w=401wt.eu-S933377AbXLMVlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbXLMVlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbXLMVlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:41:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40327 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759381AbXLMVlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:41:03 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 16:41:03 EST
Date: Thu, 13 Dec 2007 13:33:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: What was the problem with quicklists and x86-64?
In-Reply-To: <1197579788.15741.172.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0712131332100.24778@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>  <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
  <1197578876.15741.163.camel@pasglop>  <Pine.LNX.4.64.0712131251300.18314@schroedinger.engr.sgi.com>
 <1197579788.15741.172.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Benjamin Herrenschmidt wrote:

> > This is a generic NUMA issue here! Quicklist pages that are not on 
> > the current node are freed without waiting for the TLB flush. The patch 
> > that I posted fixes that by requiring that all pages be flushed. 
> 
> Ah ok, so that's a NUMA issue due to how the quicklists are implemented,
> I see. Note that the flush isn't necessary a solution on all platforms.
> On powerpc, I -still- need to defer with RCU as we don't do anything in
> flush tlb. Our TLB invalidations are HW broadcast in the first place,
> but what we need to sync with is the SW hash reload code.
> 
> So your solution in the quicklists doesn't solve the problem for us.

No this may mean that the problem does not exist on powerpc since it 
seems to be okay to free pages before all processors have flushed the 
TLBs? Or are you deferrring the freeing of the pages via RCU?


