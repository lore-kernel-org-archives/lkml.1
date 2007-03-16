Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbXCPIFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbXCPIFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXCPIFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:05:48 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:40550 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751689AbXCPIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:05:46 -0400
Subject: Re: [PATCH 0/3] FUTEX : new PRIVATE futexes, SMP and NUMA
	improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703152010.35614.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 09:05:41 +0100
Message-Id: <1174032341.7124.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 20:10 +0100, Eric Dumazet wrote:
> Hi
> 
> I'm pleased to present these patches which improve linux futex performance and 
> scalability, on both UP, SMP and NUMA configs.
> 
> I had this idea last year but I was not understood, probably because I gave 
> not enough explanations. Sorry if this mail is really long...

I started playing with it after your last reference to it, I have some
code here (against -rt):
  http://programming.kicks-ass.net/kernel-patches/futex-vma-cache/

Which I will post once I have the found what keeps pthread_join() from
completing :-(

It basically adds a per task vma lookup cache which can also activate
the private logic without explicit use of the new interface.

