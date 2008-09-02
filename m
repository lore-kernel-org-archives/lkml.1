Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYIBPii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYIBPii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYIBPia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:38:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:53723 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYIBPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:38:30 -0400
Date: Tue, 2 Sep 2008 08:38:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "CHADHA,VINEET" <vineet@ufl.edu>
Cc: "CHADHA,VINEET" <vineet@ufl.edu>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: TLB evaluation for Linux
Message-ID: <20080902083826.02ca5418@infradead.org>
In-Reply-To: <960293705.209651220367565443.JavaMail.osg@osgjas01.cns.ufl.edu>
References: <960293705.209651220367565443.JavaMail.osg@osgjas01.cns.ufl.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 10:59:25 -0400 (EDT)
"CHADHA,VINEET" <vineet@ufl.edu> wrote:

> 
> On Tue Sep 02 09:43:53 EDT 2008, Arjan van de Ven 
> <arjan@infradead.org> wrote:
> 
> > On Tue, 2 Sep 2008 00:12:03 -0400 (EDT)
> > "CHADHA,VINEET" <vineet@ufl.edu> wrote:
> > 
> 
> > note that linux only does an ipi to processors that actually are
> > currently running a thread of the same program (or a kernel 
> > thread).
> > Old versions didn't do this (they also IPI'd idle processors), 
> > but
> > on modern cpus and modern kernels that's not supposed to happen 
> > anymore
> > (the C-states that flush the tlb anyway now do the kernel side
> > bookkeeping as well to avoid the wakeup+useless flush)
> 
> Interesting to know about it.
> 
> > one of the problems is that invlpg is rather expensive; in 
> > long-ago
> > experiments the threshold was like around a handful of pages 
> > already.
> > At that point.. all the bookkeeping isn't likely to be a win.
> > Esp since a tlb refill on x86 is quite cheap.
> 
> Yeah that is possible. Do you have link to any published work ? It 
> would be still interesting to characterize and  compare behavior 
> for new workloads scenarios such as virtual machines.
> 

I don't have a reference, but I'd not be surprised to see on virtual
machines for this to be even stronger; each invlpg would be a
hypercall, compared to only one for the total flush.
