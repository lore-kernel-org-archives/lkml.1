Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbYE3Fwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbYE3Fwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYE3Fw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:52:27 -0400
Received: from ozlabs.org ([203.10.76.45]:48336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbYE3Fw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:52:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
Date: Fri, 30 May 2008 15:52:24 +1000
User-Agent: KMail/1.9.9
Cc: Eric Dumazet <dada1@cosmosbay.com>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805301552.25423.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2008 15:20:45 Christoph Lameter wrote:
> On Fri, 30 May 2008, Eric Dumazet wrote:
> > > +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
> >
> > area[] is not guaranteed to be aligned on anything but 4 bytes.
> >
> > If someone then needs to call cpu_alloc(8, GFP_KERNEL, 8), it might get
> > an non aligned result.
> >
> > Either you should add an __attribute__((__aligned__(PAGE_SIZE))),
> > or take into account the real address of area[] in cpu_alloc() to avoid
> > waste of up to PAGE_SIZE bytes
> > per cpu.
>
> I think cacheline aligning should be sufficient. People should not
> allocate large page aligned objects here.

I vaguely recall there were issues with this in the module code.  They might 
be gone now, but failing to meet alignment contraints without a big warning 
would suck.

But modifying your code to consider the actual alignment is actually pretty 
trivial, AFAICT.

Cheers,
Rusty.
