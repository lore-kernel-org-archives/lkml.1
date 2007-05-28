Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXE1PGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXE1PGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXE1PGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:06:46 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:44316 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbXE1PGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aBHVRKVmee7oJnnW5+P0oSdKnagUnXIVb3YQh+fn6RTMuDDV71uY6n91tQ13sGWRS0QBb1d8PYQagaNbT9R897sxW/OvuOT4nRbd6Fo/ZPIdmf3YnfSKcj3jI356Uk6dazxHR3xx3/56zlmveLHDwlefghZ1lMfoWcUbBuk/SeA=
Message-ID: <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
Date: Mon, 28 May 2007 20:36:44 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <200705281049.48679.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
	 <200705281049.48679.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> On Monday 28 May 2007 10:40:31 Nitin Gupta wrote:
> > Hi,
> >
> > Attached is tester code used for testing.
> > (developed by Daniel Hazelton -- modified slightly to now use 'take 6'
> > version for 'TinyLZO')
> >
> > Cheers,
> > Nitin
> >
>
> <snip>
> I haven't tested with version 6, but after removing the LZO_CHECK_MPOS_NON_DET
> macro from the 'take 5' code and replacing the open-coded byte-for-byte
> copies with calls to memcpy:
>

I did memcpy() changes in some initial post (take '2', I think). That
caused some _correctness_ issue in de/compressor code -- Bret's test
could not succeed on ppc machine. After going back to byte-by-byte
copying, his tests were successful.

So, it's better not to include such changes now or test on all
supported archs if you really want to do so :)

> 10000 run averages:
> 'Tiny LZO':
>         Combined: 57.4691 usec
>         Compression: 39.8837 usec
>         Decompression: 17.5854 usec
> 'miniLZO':
>         Combined: 64.0484 usec
>         Compression: 46.0604 usec
>         Decompression: 17.988 usec
>
> which means:
> Overall TinyLZO is 10.2% faster
> TinyLZO compresses 13.4% faster
> TinyLZO decompresses 2.23% faster
>
> -Benchmark run a a Pentium-M 1.73GHz, 1GB Ram
> With the speed-up seen with just the removal of the LZO_CHECK_MPOS_NON_DET I
> wasn't sure that changing the open-coded copy to a call to memcpy() was going
> to have a big impact on the code, but it does appear to have has several
> percentage points of difference.

Yes, memcpy() changes have potential of giving significant perf gain
but I am not too sure if memcpy() will be good if we want to copy just
few bytes (which is the case at many times in de/compressor). Also, at
some places, memcpy() changes are not trival and have actually caused
correctness issues as mentioned above.

So, before this change, it will be good if it gets merged in mainline
and tested, at least for correctness, on all supported achs. All the
while, we will have a good feeling that there is still a good scope
for perf improvement :)


Cheers,
Nitin
