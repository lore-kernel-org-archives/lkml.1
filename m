Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXE1USw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXE1USw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXE1USp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:18:45 -0400
Received: from keil-draco.com ([216.193.185.50]:50584 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750822AbXE1USo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:18:44 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Mon, 28 May 2007 16:18:40 -0400
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
Message-Id: <200705281618.40228.dhazelton@enter.net>
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

With likely(), unlikely() and noinline *not* defined as NOP's performance 
drops:

10000 run averages:
'Tiny LZO':
        Combined: 84.9292 usec
        Compression: 42.4646 usec
        Decompression: 42.4646 usec
'miniLZO':
        Combined: 61.3548 usec
        Compression: 43.5648 usec
        Decompression: 17.79 usec

However, I'm worried that my testbed code - likely the Perl script that 
actually loops the test code and collects its output - is somehow faulting, 
as the way that the Compression and Decompression code have the exact same 
value.

I'm going to toss some debugging output in the script and see if I can spot 
the problem.

DRH
