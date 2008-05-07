Return-Path: <linux-kernel-owner+w=401wt.eu-S1765493AbYEGSDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765493AbYEGSDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbYEGSD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:03:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886AbYEGSD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:03:26 -0400
Date: Wed, 7 May 2008 11:02:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507174900.GB13591@elte.hu>
Message-ID: <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org>
 <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org>
 <20080507174900.GB13591@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> another idea: my trial-baloon patch should test your theory too, because 
> the generic down_trylock() is still the 'fat' version, it does:

I agree that your trial-balloon should likely get rid of the big 
regression, since it avoids the scheduler.

So with your patch, lock_kernel() ends up being just a rather expensive 
spinlock. And yes, I'd expect that it should get rid of the 40% cost, 
because while it makes lock_kernel() more expensive than a spinlock and 
you might end up having a few more cacheline bounces on the lock due to 
that, that's still the "small" expense compared to going through the whole 
scheduler on conflicts.

So I'd expect that realistically the performance difference between your 
version and just plain spinlocks shouldn't be *that* big. I'd expect it to 
be visible, but in the (low) single-digit percentage range rather than in 
any 40% range. That's just a guess.

		Linus
