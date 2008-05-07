Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYEGRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYEGRZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYEGRZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:25:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbYEGRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:25:28 -0400
Date: Wed, 7 May 2008 10:24:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507170528.GA11511@elte.hu>
Message-ID: <alpine.LFD.1.10.0805071017130.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org>
 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507162012.GA10096@elte.hu> <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org> <20080507170528.GA11511@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> it was removed by me in the course of this discussion:
> 
>    http://lkml.org/lkml/2008/1/2/58
> 
> the whole discussion started IIRC because !CONFIG_PREEMPT_BKL [the 
> spinlock version] was broken for a longer period of time (it crashed 
> trivially), because nobody apparently used it.

Hmm. I've generally used PREEMPT_NONE, and always thought PREEMPT_BKL was 
the known-flaky one.

The thread you point to also says that it's PREEMPT_BKL=y that was the 
problem (ie "I've seen 1s+ desktop latencies due to PREEMPT_BKL when I was 
still using reiserfs."), not the plain spinlock approach.

But it would definitely be interesting to see the crash reports. And the 
help message always said "Say N if you are unsure." even if it ended up 
being marked 'y' by default at some point (and then in January was made 
first unconditional, and then removed entirely)

Because in many ways, the non-preempt BKL is the *much* simpler case. I 
don't see why it would crash - it just turns the BKL into a trivial 
counting spinlock that can sleep.

			Linus
