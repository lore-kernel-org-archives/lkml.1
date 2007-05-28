Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbXE1T7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbXE1T7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXE1T7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:59:45 -0400
Received: from keil-draco.com ([216.193.185.50]:50549 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751373AbXE1T7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:59:44 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Mon, 28 May 2007 15:59:40 -0400
User-Agent: KMail/1.9.6
Cc: Nitin Gupta <nitingupta910@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com> <20070528171115.GQ3899@stusta.de>
In-Reply-To: <20070528171115.GQ3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281559.40237.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 13:11:15 Adrian Bunk wrote:
> On Mon, May 28, 2007 at 09:33:32PM +0530, Nitin Gupta wrote:
> > On 5/28/07, Adrian Bunk <bunk@stusta.de> wrote:
> >...
> >
> >> - then ensure that it works correctly on all architectures and
> >
> > Already tested on x86, amd64, ppc (by Bret). I do not have machines
> > from other archs available. Bret tested 'take 3' version but no
> > changes were introduced in further revisions that could affect
> > correctness - but still it will be good to have this version tested
> > too. Only with inclusion in -mm and testing by much wider user base
> > can make it to mainline (I suppose nobody uses -mm for production use
> > anyway).
> >
> >>   document why your version is that much faster than the original
> >>   version and why you know your optimizations have no side effects
> >
> > Replied in earlier mail regarding this.
> >...
>
> I have not seen any explanations:
> - Why did the upstream author write the code that way?
> - Why are your changes correct?
> - Why do your changes allow the compiler to produce faster code?

Would it help if I added instrumentation code to both the upstream code and 
the stripped down code in question?

> The upstream author of the code is available - and he might be able to
> help you getting answers. No matter whether your changes are incorrect
> or correct optimizations that should go upstream, in both cases
> discussing these issues with upstream is the best solution.
>
> And testing is nice, but if you broke some case that's outside of your
> tests you'll never notice.

Any suggestions for tests I could add to the boilerplate I've been using to 
benchmark the code? I'll add a few tests that use random input rather than 
one of the source files - I'd add a test to see how it deals with NULL input, 
but I ran into that in an early version of the testbed (where I had a typo 
that stopped the code from working) and the compressor didn't like it. And I 
suppose I could put in a test that reads in a chunk of /dev/mem or have it 
get a chunk of data from HAL/DBus as well.

But if anyone has a suggestion of what tests I could toss at it to really 
stress the code, let me know and I'll get to work extending this code so it 
can stress test both the standard implementation of miniLZO *and* this 
stripped down 'Tiny' version.

DRH

> > - Nitin
>
> cu
> Adrian


