Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbXEYIC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbXEYIC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXEYICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:02:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57500 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbXEYICK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:02:10 -0400
Date: Fri, 25 May 2007 10:02:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525080209.GE8094@one.firstfloor.org>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525075446.GA20140@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 09:54:46AM +0200, Ingo Molnar wrote:
> Subject: [patch] x86_64: fix sched_clock()
> From: Ingo Molnar <mingo@elte.hu>
> 
> sched_clock() is totally broken on x86_64, because it is not defined by 
> the architecture at all! It fell the victim to the opaqueness of 
> __attribute__((weak)) and to non-testing.

More non retesting.

> 
> the i386 version was supposed to be used. This patch fixes that. Booted 
> and tested on x86_64 and i386.

Hmm indeed. I actually had it correct at some point (i remember
fixing 64bit compile errors in sched-clock ;-). I guess the Makefile hunk 
accidentially dropped out during some later merging and this didn't get 
noticed due to the weak attribute.

That also explains the issue reported by Peter earlier I guess.

-Andi

