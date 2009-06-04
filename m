Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZFDPph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZFDPph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZFDPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:45:14 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44632 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbZFDPpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:45:12 -0400
Date: Thu, 4 Jun 2009 21:15:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 11/12] hw-breakpoints: ftrace plugin for kernel symbol
	tracing using HW Breakpoint interfaces
Message-ID: <20090604154500.GB5336@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com> <1243982616-18212-12-git-send-email-fweisbec@gmail.com> <4A25B1C8.7030708@caviumnetworks.com> <20090603003811.GF6041@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603003811.GF6041@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 02:38:12AM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 02, 2009 at 04:12:08PM -0700, David Daney wrote:
> > Frederic Weisbecker wrote:
> >> From: K.Prasad <prasad@linux.vnet.ibm.com>

> > I hate to sound like a broken record, but could some one explain to me  
> > again why it is a good idea to design a new API that requires processor  
> > specific #ifdefs to be sprinkled all around generic kernel code?
> >
> > Back in:
> > http://lkml.org/lkml/2008/12/4/329
> > and
> > http://lkml.org/lkml/2009/5/21/189
> >
> > I raised doubts about this hw-breakpoint thing being generic and the  
> > responses made think that the processor specific portions would be  
> > isolated in the processor specific parts of the kernel.  I now see that  
> > I was wrong.
> >
> > When we add sparc, MIPS, ppc...  Support it would be nice to not have to  
> > add all our own #ifdefs to this, but instead have a generic interface  
> > that will not need changes.
> >
> > David Daney
> 
> I was discussing about it with Prasad few hours ago :)
> 
> The fact is that archs support the hardware breakpoints in
> very different ways each.
> Some of them support read breakpoint, others not (x86).
> Some support addresses range, others (x86).
> 
> But still it would be nice to gather the most common
> breakpoints operations through a real generic wrapper
> that relies on arch specific implmentation in
> background.
> 
> Such as setting very simple x/w/r breakpoints...
> 
> Well Prasad and Alan Stern could tell more about it,
> I wait for their answer.
> 
> Anyway it's a fairly new Api that can still evolve.
> The basis are set but can still be improved and more high level
> and generic things can still be implemented.
> 

I think this concern can be partially addressed, atleast as far as the
breakpoint length is concerned. I've added my comments in the response
to David Daney here: http://lkml.org/lkml/2009/6/4/303.

Hope that the changes proposed there is acceptable to the community.

Thanks,
K.Prasad

