Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXE1Pzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXE1Pzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbXE1Pz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:55:27 -0400
Received: from keil-draco.com ([216.193.185.50]:50345 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756536AbXE1Pz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:55:26 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Mon, 28 May 2007 11:55:14 -0400
User-Agent: KMail/1.9.6
Cc: "Adrian Bunk" <bunk@stusta.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <20070528153055.GN3899@stusta.de> <4cefeab80705280847q62d68ebavd74c5a9d425de0f6@mail.gmail.com>
In-Reply-To: <4cefeab80705280847q62d68ebavd74c5a9d425de0f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281155.14466.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 11:47:55 Nitin Gupta wrote:
> On 5/28/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Mon, May 28, 2007 at 08:10:31PM +0530, Nitin Gupta wrote:
> > > Hi,
> > >
> > > Attached is tester code used for testing.
> > > (developed by Daniel Hazelton -- modified slightly to now use 'take 6'
> > > version for 'TinyLZO')
> > >
> > > Cheers,
> > > Nitin
> > >
> > > On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > >> (Using tester program from Daniel)
> > >>
> > >> Following compares this kernel port ('take 6') vs original miniLZO
> > >> code:
> > >>
> > >> 'TinyLZO' refers to this kernel port.
> > >>
> > >> 10000 run averages:
> > >> 'Tiny LZO':
> > >>        Combined: 61.2223 usec
> > >>        Compression: 41.8412 usec
> > >>        Decompression: 19.3811 usec
> > >> 'miniLZO':
> > >>        Combined: 66.0444 usec
> > >>        Compression: 46.6323 usec
> > >>        Decompression: 19.4121 usec
> > >>
> > >> Result:
> > >> Overall: TinyLZO is 7.3% faster
> > >> Compressor: TinyLZO is 10.2% faster
> > >> Decompressor: TinyLZO is 0.15% faster
> >
> > So your the compressor of your version runs 10.2% faster than the
> > original version.
> >
> > That's a huge difference.
> >
> > Why exactly is it that much faster?
> >
> > cu
> > Adrian
>
> I am not sure on how to account for this _big_ perf. gain but from
> benchmarks I see that whenever I remove unncessary casting from tight
> loops I get perf. gain of 1-2%. For e.g. open coding
> LZO_CHECK_MPOS_NON_DET macro with all unnecessary casting removed,
> gave perf. gain of ~2%. Similarly, I found many other places where
> such casting was unnecessary.

This is my guess as well. Though performance will likely drop when I make the 
noinline macro mean something. (This may be offset by figuring out a way to 
make likely() and unlikely() also have a meaningful effect in userspace).

This benchmark should be run on BE machines, but I'm still trying to figure 
out a way to open-code a *fast* and *reliable* version of cpu_to_le16.

Suggestions for the above bits will always be appreciated.
 
> These changes have been tested on x86, amd64, ppc. Testing of 'take 6'
> version is yet to be done - this will confirm that I didn't
> reintroduce some error.

I don't see that 'take 6' has had too much changed from 'take 4', although I 
haven't do a full comparison.

DRH
