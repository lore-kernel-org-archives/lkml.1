Return-Path: <linux-kernel-owner+w=401wt.eu-S1423632AbXD3UHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423632AbXD3UHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946743AbXD3UHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:07:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946742AbXD3UHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:07:13 -0400
Date: Mon, 30 Apr 2007 22:07:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [5/6] dynamically allocate IRQ stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430200710.GA12376@one.firstfloor.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174630.GH19966@holomorphy.com> <Pine.LNX.4.64.0704301247470.26601@montezuma.windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704301247470.26601@montezuma.windriver.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 12:49:04PM -0700, Zwane Mwaikambo wrote:
> On Mon, 30 Apr 2007, William Lee Irwin III wrote:
> 
> > -static char softirq_stack[NR_CPUS * THREAD_SIZE]
> > -		__attribute__((__aligned__(THREAD_SIZE)));
> > +static DEFINE_PER_CPU(char *, softirq_stack);
> > +static DEFINE_PER_CPU(char *, hardirq_stack);
> >  
> > -static char hardirq_stack[NR_CPUS * THREAD_SIZE]
> > -		__attribute__((__aligned__(THREAD_SIZE)));
> > +#ifdef CONFIG_VMALLOC_STACK
> > +static void * __init __alloc_irqstack(int cpu)
> 
> How about just using DEFINE_PER_CPU and allowing the percpu code 
> dynamically allocate.

That would require a true possible map first.

-Andi
