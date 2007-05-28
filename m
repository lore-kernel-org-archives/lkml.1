Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbXE1PsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbXE1PsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXE1PsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:48:04 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:41226 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbXE1PsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JD4j8Ao9KaIu10ql46OAUjuXsU1E46gD7CELd58lMlJTpkFCVB3RxPfBUipNxZ6x0MzSWynePnJDHytXdT25ECyCpVLT7OIBaJgz/It8Ma0Rwsohf5jN7nYgLfC1bSxlTxP9c7EsCoxf35vwtav0Y1HJW8Sg3CeRF4Al1Wyxt3s=
Message-ID: <4cefeab80705280847q62d68ebavd74c5a9d425de0f6@mail.gmail.com>
Date: Mon, 28 May 2007 21:17:55 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <20070528153055.GN3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
	 <20070528153055.GN3899@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Mon, May 28, 2007 at 08:10:31PM +0530, Nitin Gupta wrote:
> > Hi,
> >
> > Attached is tester code used for testing.
> > (developed by Daniel Hazelton -- modified slightly to now use 'take 6'
> > version for 'TinyLZO')
> >
> > Cheers,
> > Nitin
> >
> > On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> >> (Using tester program from Daniel)
> >>
> >> Following compares this kernel port ('take 6') vs original miniLZO code:
> >>
> >> 'TinyLZO' refers to this kernel port.
> >>
> >> 10000 run averages:
> >> 'Tiny LZO':
> >>        Combined: 61.2223 usec
> >>        Compression: 41.8412 usec
> >>        Decompression: 19.3811 usec
> >> 'miniLZO':
> >>        Combined: 66.0444 usec
> >>        Compression: 46.6323 usec
> >>        Decompression: 19.4121 usec
> >>
> >> Result:
> >> Overall: TinyLZO is 7.3% faster
> >> Compressor: TinyLZO is 10.2% faster
> >> Decompressor: TinyLZO is 0.15% faster
>

> So your the compressor of your version runs 10.2% faster than the
> original version.
>
> That's a huge difference.
>
> Why exactly is it that much faster?
>
> cu
> Adrian

I am not sure on how to account for this _big_ perf. gain but from
benchmarks I see that whenever I remove unncessary casting from tight
loops I get perf. gain of 1-2%. For e.g. open coding
LZO_CHECK_MPOS_NON_DET macro with all unnecessary casting removed,
gave perf. gain of ~2%. Similarly, I found many other places where
such casting was unnecessary.

These changes have been tested on x86, amd64, ppc. Testing of 'take 6'
version is yet to be done - this will confirm that I didn't
reintroduce some error.

- Nitin
