Return-Path: <linux-kernel-owner+w=401wt.eu-S934576AbZDBKfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576AbZDBKfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZDBKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:35:35 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:38355 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbZDBKff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:35:35 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <18900.35934.799877.893556@cargo.ozlabs.ibm.com>
References: <20090328194359.426029037@chello.nl>
	 <20090328194929.546464621@chello.nl>
	 <18894.49084.341238.775487@cargo.ozlabs.ibm.com>
	 <1238662238.8530.5622.camel@twins>
	 <18900.33346.375497.2714@cargo.ozlabs.ibm.com>
	 <1238664979.8530.5723.camel@twins>
	 <18900.35934.799877.893556@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 12:36:27 +0200
Message-Id: <1238668587.8530.5793.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:58 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > > Good point.  This should work, though:
> > > 
> > > 	do {
> > > 		seq = pc->lock;
> > > 		barrier();
> > > 		value = read_pmc(pc->index) + pc->offset;
> > > 		barrier();
> > > 	} while (pc->lock != seq);
> > > 	return value;
> > 
> > I don't think you need the first barrier(), all you need to avoid is it
> > reusing the first pc->lock read, so one should suffice.
> 
> I need it to make sure that the compiler doesn't put the load of
> pc->index or pc->offset before the first load of pc->lock.  The second
> barrier is needed to make sure the compiler puts the second load of
> pc->lock after the loads of pc->index and pc->offset.  So I think I do
> need to barrier()s (but only compiler barriers, not cpu memory
> barriers).

Ah, you're right indeed.

> > Also, you need to handle the !pc->index case.
> 
> Hmmm, yeah.  I claim that read_pmc(0) always returns 0. :)

Hehe :-)

Ok, updated that patch.

