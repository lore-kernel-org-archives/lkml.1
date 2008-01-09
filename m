Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbYAIBL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbYAIBL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYAIBLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:11:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbYAIBLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:11:03 -0500
Date: Wed, 9 Jan 2008 02:11:00 +0100
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109011100.GC25945@bingen.suse.de>
References: <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47841B09.3020507@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is _PAGE_GLOBAL causing the first if() to fall through to the second 

Yes it obviously is.


> clause?  Because otherwise it shouldn't have any effect on the pte_huge() 
> test.

>
> Gah!  This can't be right!  I think the original change_page_attr() code is 
> plain buggy.

It has a few rough edges.  I was fixing various issues in the c_p_a() patch 
series I posted recently.

The code bugs when you set the same area to the same protection several
times. That likely happens here.

The cpa series adds a helpful comment explaining this.

               /*
                 * When you're here you either set the same page to PAGE_KERNEL
                 * two times in a row or the page table reference counting is
                 * broken again. To catch the later bug for now (sorry)
                 */
                printk(KERN_ERR "address %lx\n", address);
                dump_pagetable(address);
                BUG();

I've been considering taking it out, but is there ever a good reason
to do that?  I left it in because it catches bugs in c_p_a itself.

-Andi

