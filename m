Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZCURc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZCURc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 13:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZCURcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 13:32:47 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41656 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZCURcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 13:32:47 -0400
Date: Sat, 21 Mar 2009 23:02:32 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090321173232.GC9906@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090319234804.GB10517@in.ibm.com> <Pine.LNX.4.44L0.0903201006120.2686-100000@iolanthe.rowland.org> <20090320183058.GB31629@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320183058.GB31629@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 07:30:58PM +0100, Ingo Molnar wrote:
> 
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > + * Kernel breakpoints grow downwards, starting from HB_NUM
> > > + * 'hbkpt_kernel_pos' denotes lowest numbered breakpoint register occupied for
> > > + * kernel-space request
> > > + */
> > > +unsigned int hbkpt_kernel_pos;
> > 
> > This doesn't make much sense.  All you need to know is which 
> > registers are in use; all others are available.
> > 
> > For example, suppose the kernel allocated breakpoints 3, 2, and 1, 
> > and then deallocated 2.  Then bp 2 would be available for use, 
> > even though 2 > 1.
> 
> it's a high/low watermark mechanism. Yes, it's not an allocator that 
> can allocate into a debug registrs 'hole', but it is a simple one 
> that matches current hardware breakpoint usages and enables the 
> kernel to utilize them as well - and keeps all the code simple.
> 
> 	Ingo

I've explained the design here: http://lkml.org/lkml/2009/3/21/169 in a
and is slightly different from what you've explained above.

It involves shifting of kernel-space registers by one-level if a
kernel-register is uninstalled. We compact the kernel-space registers
since a)not to leave a 'hole' thereby wasting a register forever during
runtime b)kernel-space requests are not specific to a register number
and can be moved at will (unlike user-space requests).

Hope that the design is acceptable and the resultant code - simple.

Thanks,
K.Prasad

