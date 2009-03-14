Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZCNDwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZCNDwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 23:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZCNDw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 23:52:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:60784 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbZCNDw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 23:52:27 -0400
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, prasad@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Gibson <dwgibson@au1.ibm.com>, Torez Smith <torez@us.ibm.com>
In-Reply-To: <20090312024617.3F392FC3B6@magilla.sf.frob.com>
References: <20090305043440.189041194@linux.vnet.ibm.com>
	 <20090305043801.GC17747@in.ibm.com> <20090310140950.GD3850@elte.hu>
	 <20090312024617.3F392FC3B6@magilla.sf.frob.com>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 14:51:06 +1100
Message-Id: <1237002666.25062.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 19:46 -0700, Roland McGrath wrote:
> 
> I think it would be illustrative to have a second arch implementation to
> compare to the x86 one.  Ingo has a tendency to pretend everything is an
> x86 until shown the concrete evidence.  The obvious choice is powerpc.
> Its facility is very simple, so the arch-specific part of the
> implementation should be trivial--it's the "base case" of simplest
> available hw_breakpoint arch, really.  Also, it happens that Prasad's
> employer is interested in having that support.
> 
> For example, a sensible powerpc implementation would clearly demonstrate
> why you need accessors or at least either pre-registration setters or
> explicit type/len arguments in registration calls.

Well, we happen to be just in the middle of implementing support for
BookE HW debug facilities :-) (which have more HW breakpoints &
watchpoints than server PPCs along with fancy features like ranged
breakpoints or value compare) so it's a right time to give that a try.

I'm Ccing David Gibson and Torez Smith who both have been working on the
infrastructure to control the debug regs. For now we are just giving
pretty much direct access to the debug regs from ptrace (since they are
somewhat architected they are very similar if not identical between a
whole bunch of embedded powerpc's) but a more abstract interface would
be nice.

Ben.


