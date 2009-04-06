Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbZDFVVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbZDFVVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZDFVVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:21:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:40063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbZDFVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:21:12 -0400
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49DA70F0.3020108@linux.vnet.ibm.com>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl> <1238763023.798.27.camel@twins>
	 <49D654AB.4030207@linux.vnet.ibm.com>  <1239015668.798.4243.camel@twins>
	 <1239016035.798.4254.camel@twins>  <49DA4FA0.6090902@linux.vnet.ibm.com>
	 <1239044818.798.4775.camel@twins>  <49DA6324.9080801@linux.vnet.ibm.com>
	 <1239050799.4557.24.camel@laptop>  <49DA70F0.3020108@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 23:21:04 +0200
Message-Id: <1239052864.4557.62.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 14:15 -0700, Corey Ashford wrote:
> 
> Peter Zijlstra wrote:
> > On Mon, 2009-04-06 at 13:16 -0700, Corey Ashford wrote:
> > 
> >>>> One downside of this approach is that you if you specify "no header" 
> >>>> (currently not possible, but maybe later?), you will not be able to get 
> >>>> the level bits.
> >>> Would this be desirable? 
> > 
> >> I think it would.  For one use case I'm working on right now, simple 
> >> profiling, all I need are ip's.  If I could omit the header, that would 
> >> reduce the frequency of sigio's by a factor of three, and make it faster 
> >> to read up the ip's when the SIGIO's occur.
> > 
> > Self-profiling?
> > 
> > So you're interested in getting the smallest possible record size, that
> > would still be 2 u64, right? Otherwise you don't get the IP context that
> > started this.
> > 
> > 
> 
> Self-profiling mainly, yes.  PAPI specs an ability for remote monitoring 
> of processes and threads, but I think it's only partially implemented.
> 
> So when you are talking about IP context, you mean pid/tid?

Ah, we called it level before, the hv/kernel/user thing. For remote
profiling you'd want to have the mmap thing too.



