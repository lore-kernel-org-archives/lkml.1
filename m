Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYE3FOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYE3FOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYE3FOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:14:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42003 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752346AbYE3FOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:14:19 -0400
Date: Thu, 29 May 2008 22:14:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 03/41] cpu alloc: Use cpu allocator instead of the builtin
 modules per cpu allocator
In-Reply-To: <20080529215837.0528fb3b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805292210420.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.451400376@sgi.com>
 <20080529215837.0528fb3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> > +			printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> > +			mod->name, align, PAGE_SIZE);
> 
> Indenting broke.

Hmmm. Okay.
 
> Alas, PAGE_SIZE has, iirc, unsigned type on some architectures and
> unsigned long on others.  I suspect you'll need to cast it to be able
> to print it.

This is code that was moved.

> > +		percpu = cpu_alloc(size, GFP_KERNEL|__GFP_ZERO, align);
> > +		if (!percpu)
> > +			printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
> 
> 80-col bustage,.
> 
> A printk like this should, I think, identify what part of the kernel it
> came from.

Again moved code. Should I really do string separations for code 
that is moved?

> But really, I don't think any printk should be present here. 
> cpu_alloc() itself should dump the warning and the backtrace when it
> runs out.  Because a cpu_alloc() failure is a major catastrophe.  It
> probably means a reconfigure-and-reboot cycle.

The code has been able to deal with an allocpercpu failure in the 
past. Why would it have trouble with a cpu_alloc failure here?

