Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbXE2NJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbXE2NJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXE2NJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:09:33 -0400
Received: from keil-draco.com ([216.193.185.50]:50933 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751990AbXE2NJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:09:32 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Tue, 29 May 2007 09:09:26 -0400
User-Agent: KMail/1.9.6
Cc: "Bret Towe" <magnade@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <dda83e780705281557raeb2769q73ec59249674e704@mail.gmail.com> <4cefeab80705282248pd595302v519b3ae6c6f41daa@mail.gmail.com>
In-Reply-To: <4cefeab80705282248pd595302v519b3ae6c6f41daa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705290909.26902.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 01:48:29 Nitin Gupta wrote:
> On 5/29/07, Bret Towe <magnade@gmail.com> wrote:
> > On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
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
> > > > (Using tester program from Daniel)
> > > >
> > > > Following compares this kernel port ('take 6') vs original miniLZO
> > > > code:
> > > >
> > > > 'TinyLZO' refers to this kernel port.
> > > >
> > > > 10000 run averages:
> > > > 'Tiny LZO':
> > > >        Combined: 61.2223 usec
> > > >        Compression: 41.8412 usec
> > > >        Decompression: 19.3811 usec
> > > > 'miniLZO':
> > > >        Combined: 66.0444 usec
> > > >        Compression: 46.6323 usec
> > > >        Decompression: 19.4121 usec
> > > >
> > > > Result:
> > > > Overall: TinyLZO is 7.3% faster
> > > > Compressor: TinyLZO is 10.2% faster
> > > > Decompressor: TinyLZO is 0.15% faster
> >
> > 10000 run averages:
> > 'Tiny LZO':
> >         Combined: 112.6642 usec
> >         Compression: 56.3321 usec
> >         Decompression: 56.3321 usec
> > 'miniLZO':
> >         Combined: 77.6642 usec
> >         Compression: 56.3416 usec
> >         Decompression: 21.3226 usec
> >
> > now the interesting bit I thought was the following
> > root@mini:/usr/src/lzo1x-test-4# ./fulltest
> > [test_lzo.c::compress (93)] run took 42 microseconds
> > [test_lzo.c::decompress (127)] run took 20 microseconds
> > root@mini:/usr/src/lzo1x-test-4# ./tinytest
> > [test.c::compress (91)] run took 44 microseconds
> > [test.c::decompress (117)] BUG: lzo1x_decompress has failed ( t == -6 )
> > [test.c::main (149)] BUG: Decompression routine failure
>
> Did you use x86 for above test? Maybe some problem with testing
> script? What data did you use for this test?
>
>
> - Nitin

Using any version of the test code below 5 on a non-LE system would result in 
this error. Those earlier versions couldn't handle BE systems because I was 
too lazy to define cpu_to_le16. (And yes, Nitin, that does appear to be the 
correct conversion to use)

DRH

