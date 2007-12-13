Return-Path: <linux-kernel-owner+w=401wt.eu-S1765786AbXLMW3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765786AbXLMW3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761385AbXLMW24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:28:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:57384 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbXLMW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:28:56 -0500
Subject: Re: What was the problem with quicklists and x86-64?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712131332100.24778@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>
	 <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
	 <1197578876.15741.163.camel@pasglop>
	 <Pine.LNX.4.64.0712131251300.18314@schroedinger.engr.sgi.com>
	 <1197579788.15741.172.camel@pasglop>
	 <Pine.LNX.4.64.0712131332100.24778@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 09:27:39 +1100
Message-Id: <1197584859.15741.185.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 13:33 -0800, Christoph Lameter wrote:
> > 
> > Ah ok, so that's a NUMA issue due to how the quicklists are
> implemented,
> > I see. Note that the flush isn't necessary a solution on all
> platforms.
> > On powerpc, I -still- need to defer with RCU as we don't do anything
> in
> > flush tlb. Our TLB invalidations are HW broadcast in the first
> place,
> > but what we need to sync with is the SW hash reload code.
> > 
> > So your solution in the quicklists doesn't solve the problem for us.
> 
> No this may mean that the problem does not exist on powerpc since it 
> seems to be okay to free pages before all processors have flushed the 
> TLBs? Or are you deferrring the freeing of the pages via RCU?

I'm deferring the freeing with RCU.

Ben.


