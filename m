Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXCPJaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXCPJaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXCPJaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:30:21 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:51309 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798AbXCPJaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:30:19 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/3] FUTEX : new PRIVATE futexes, SMP and NUMA improvements
Date: Fri, 16 Mar 2007 10:30:17 +0100
User-Agent: KMail/1.9.5
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
References: <20060808070708.GA3931@localhost.localdomain> <200703152010.35614.dada1@cosmosbay.com> <1174032341.7124.9.camel@twins>
In-Reply-To: <1174032341.7124.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161030.17597.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 09:05, Peter Zijlstra wrote:
> On Thu, 2007-03-15 at 20:10 +0100, Eric Dumazet wrote:
> > Hi
> >
> > I'm pleased to present these patches which improve linux futex
> > performance and scalability, on both UP, SMP and NUMA configs.
> >
> > I had this idea last year but I was not understood, probably because I
> > gave not enough explanations. Sorry if this mail is really long...
>
> I started playing with it after your last reference to it, I have some
> code here (against -rt):
>   http://programming.kicks-ass.net/kernel-patches/futex-vma-cache/
>
> Which I will post once I have the found what keeps pthread_join() from
> completing :-(
>
> It basically adds a per task vma lookup cache which can also activate
> the private logic without explicit use of the new interface.

Hi Peter

I dont think yet another cache will help in the general case.
A typical program uses many vmas at once...

glibc has internal futexes, on a different vma than futexes declared in your 
program. Each shared library is going to have its own vma for its data (and 
futexes)

(244 vmas on one kmail program for example)

About your guess_futex_shared() thing, I miss the vma_anon() definition.
But if it has to walk the vmas (and take mmap_sem), you already loose the 
PRIVATE benefit.
