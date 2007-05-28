Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbXE1Ipp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbXE1Ipp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761117AbXE1IoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:44:07 -0400
Received: from keil-draco.com ([216.193.185.50]:50576 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761993AbXE1IoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:44:05 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Date: Mon, 28 May 2007 04:43:55 -0400
User-Agent: KMail/1.9.6
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Richard Purdie" <richard@openedhand.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com> <200705280418.07538.dhazelton@enter.net> <4cefeab80705280137v178a449fl391b99b6804a75f2@mail.gmail.com>
In-Reply-To: <4cefeab80705280137v178a449fl391b99b6804a75f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705280443.56152.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 04:37:04 Nitin Gupta wrote:
> On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> > Test code for this version (take 4) of the minimized LZO1X (from the
> > liblzo v2) is complete.
> >
> >
> > I don't see a significant slow-down comparing the complete liblzo2 to
> > this minimized code on my system (Pentium M 1.73GHz, 1GB Ram, Kubuntu
> > Feisty (stock Kubuntu kernel)). Rather, I see the opposite. This *might*
> > have been caused by the dynamic linking (or similar) so rather than rely
> > on simply doing "time xxx" I actually put checks around the calls to the
> > compress/decompress functions themselves.
> >
> > ('Tiny LZO' is what I call Nitins extremely small implementation of
> > lzo1x_[de]compress)
> >
> > Output of the provided "test" script:
> > 10 run averages:
> > 'Tiny LZO':
> >         Combined: 113.2 usec
> >         Compression: 77.4 usec
> >         Decompression: 35.8 usec
> > 'liblzo2':
> >         Combined: 140.7 usec
> >         Compression: 94 usec
> >         Decompression: 46.7 usec
> >
> > (The "Combined" average is the average time taken for a
> > compress+decompress)
> >
> > TODO:
> > -Implement userspace version of likely/unlikely
> > -Implement cpu_to_le16 so code functions on BE systems
> >
> > DRH
>
> As you mentioned in your mail, you are using lzo1x_1_11_compress()
> which is slower than what I ported (which is same as what is exported
> by miniLZO). So, can you please test with the version ported  - this
> is found in lzo/src/lzo1x_1.c (or in minilzo.c).
> Also, can you please use 'take 5' for your next testing?
>
> Thanks,
> Nitin

Will do.  (that's DBITS=15, correct?)

However, when I averaged it 100 times, lzo1x_1_11_compress() showed better 
speed than your implementation - about 1.5% faster. The *unsafe* 
decompressor, however, only shows about a 1.2% speed advantage over the safe 
decompressor.

DRH

