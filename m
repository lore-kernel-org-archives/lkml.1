Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbZFELop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbZFELop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZFELoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:44:37 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37543 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZFELog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ILKwwjAfPvmvg3sipqHkWoObATKn+yUDMsyUXqE3+Y990aoS12taII0KrcGPlj96pR
         i4P5nY/HEfEXRP3Qri8GpQLEjOqu4S3SAxMzd3weQyEV2OO82Wt2jwk1GXFE5TXzqeRQ
         lVdrEKyXMfXyXZsl/7puf88QFXghXmzRDrysk=
Date: Fri, 5 Jun 2009 13:44:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: David Daney <ddaney@caviumnetworks.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 11/12] hw-breakpoints: ftrace plugin for kernel symbol
	tracing using HW Breakpoint interfaces
Message-ID: <20090605114434.GB6004@nowhere>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com> <1243982616-18212-12-git-send-email-fweisbec@gmail.com> <4A25B1C8.7030708@caviumnetworks.com> <20090603003811.GF6041@nowhere> <20090604154500.GB5336@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604154500.GB5336@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 09:15:00PM +0530, K.Prasad wrote:
> On Wed, Jun 03, 2009 at 02:38:12AM +0200, Frederic Weisbecker wrote:
> > On Tue, Jun 02, 2009 at 04:12:08PM -0700, David Daney wrote:
> > > Frederic Weisbecker wrote:
> > >> From: K.Prasad <prasad@linux.vnet.ibm.com>
> 
> > > I hate to sound like a broken record, but could some one explain to me  
> > > again why it is a good idea to design a new API that requires processor  
> > > specific #ifdefs to be sprinkled all around generic kernel code?
> > >
> > > Back in:
> > > http://lkml.org/lkml/2008/12/4/329
> > > and
> > > http://lkml.org/lkml/2009/5/21/189
> > >
> > > I raised doubts about this hw-breakpoint thing being generic and the  
> > > responses made think that the processor specific portions would be  
> > > isolated in the processor specific parts of the kernel.  I now see that  
> > > I was wrong.
> > >
> > > When we add sparc, MIPS, ppc...  Support it would be nice to not have to  
> > > add all our own #ifdefs to this, but instead have a generic interface  
> > > that will not need changes.
> > >
> > > David Daney
> > 
> > I was discussing about it with Prasad few hours ago :)
> > 
> > The fact is that archs support the hardware breakpoints in
> > very different ways each.
> > Some of them support read breakpoint, others not (x86).
> > Some support addresses range, others (x86).
> > 
> > But still it would be nice to gather the most common
> > breakpoints operations through a real generic wrapper
> > that relies on arch specific implmentation in
> > background.
> > 
> > Such as setting very simple x/w/r breakpoints...
> > 
> > Well Prasad and Alan Stern could tell more about it,
> > I wait for their answer.
> > 
> > Anyway it's a fairly new Api that can still evolve.
> > The basis are set but can still be improved and more high level
> > and generic things can still be implemented.
> > 
> 
> I think this concern can be partially addressed, atleast as far as the
> breakpoint length is concerned. I've added my comments in the response
> to David Daney here: http://lkml.org/lkml/2009/6/4/303.
> 
> Hope that the changes proposed there is acceptable to the community.


Yeah, I think it's worth trying it.

Btw, I see there is no easy way to implement read breapoints in x86.
I guess the only solution would be to use the instruction decoder sent
recently by Masami for the kprobe tracer, coupled with RW breakpoints.

 
> Thanks,
> K.Prasad
> 

