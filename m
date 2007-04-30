Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXD3TtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXD3TtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbXD3TtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:49:11 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26165 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbXD3TtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:49:10 -0400
Date: Mon, 30 Apr 2007 12:49:04 -0700 (PDT)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [5/6] dynamically allocate IRQ stacks (was: Re: [-mm patch] i386:
 enable 4k stacks by default)
In-reply-to: <20070430174630.GH19966@holomorphy.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <Pine.LNX.4.64.0704301247470.26601@montezuma.windriver.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20070428191927.GN3468@stusta.de>
 <1177795118.7828.6.camel@localhost>
 <20070430035838.GC77450368@melbourne.sgi.com>
 <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de>
 <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de>
 <20070430173819.GC19966@holomorphy.com> <20070430174630.GH19966@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, William Lee Irwin III wrote:

> -static char softirq_stack[NR_CPUS * THREAD_SIZE]
> -		__attribute__((__aligned__(THREAD_SIZE)));
> +static DEFINE_PER_CPU(char *, softirq_stack);
> +static DEFINE_PER_CPU(char *, hardirq_stack);
>  
> -static char hardirq_stack[NR_CPUS * THREAD_SIZE]
> -		__attribute__((__aligned__(THREAD_SIZE)));
> +#ifdef CONFIG_VMALLOC_STACK
> +static void * __init __alloc_irqstack(int cpu)

How about just using DEFINE_PER_CPU and allowing the percpu code 
dynamically allocate.
