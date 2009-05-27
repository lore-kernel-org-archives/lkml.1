Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZE0RZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZE0RZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbZE0RZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:25:09 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:43614 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbZE0RZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:25:08 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: LOCK prefix on uni processor has its use (was Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic)
Date: Wed, 27 May 2009 12:25:03 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <20090527170118.GC4024@prithivi.gnumonks.org> <alpine.LFD.2.00.0905271906490.3397@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905271906490.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271225.07842.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Thomas Gleixner wrote:
> On Wed, 27 May 2009, Harald Welte wrote:
> > Here are some statements from the CPU logic guys at VIA/Centaur:
> > 
> > * A read-modify-write sequence cannot be interupted.
> > * All X86 instructions except rep-strings are atomic wrt interrupts.
> > * The lock prefix has uses on a UP processor: It keeps DMA devices from
> >   interfering with a read-modify-write sequence
> ...
> 
> > Now if I understand the issues correctly, it would mean that there is some
> > driver code that modifies a certain chunk of memory, while DMA of some
> > peripheral is also accessing that memory.  I suppose it would not have to be
> > the same actual address, but probably being within the same cache line is
> > already sufficient.
> > 
> > Now the question is: Is this a valid operation of a driver?  Should the driver
> > do such things, or is such a driver broken?  When would that occur?  I'm trying
> > to come up with a case, but typically you e.g. allocate some DMA buffer and
> > then don't touch it until the hardware has processed it.
> 
> Right, that would be more than stupid, but even then it would not
> explain any breakage of the kernel. Such a driver would not be
> functional anyway if it relies on some read/write modify operations in
> an active DMA buffer. That would also explode on any other system as
> you have no control whether the access to that memory happens before
> or after the DMA operation.
> 

IFF your DMA buffer is cache-line aligned and doesn't have an immediately
adjacent spin-lock (or some such thing) sharing the cache-line.

Mike
> Can you please ask them to clarify that DMA issue further ?
> 
> Thanks,
> 
> 	tglx
> 
> 


