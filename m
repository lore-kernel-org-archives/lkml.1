Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbXE1W5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbXE1W5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXE1W5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:57:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:10100 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXE1W5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P59I+UR6NXIQzD9aP7JnreIYxSICLQyXDGG+ZHwgJBweVRXAe2Rm8ngVhckenRzeTRYiWdVbmwh+lrDAmGne4cXHkF7DbZ7w1vicMOxyg/ILrH3q0AwXnwApiFRyVcspHo5wQvm3wf3Hm18hc3qUN+jYLgqFK2mnc1wEbQrF+og=
Message-ID: <dda83e780705281557raeb2769q73ec59249674e704@mail.gmail.com>
Date: Mon, 28 May 2007 15:57:04 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> Hi,
>
> Attached is tester code used for testing.
> (developed by Daniel Hazelton -- modified slightly to now use 'take 6'
> version for 'TinyLZO')
>
> Cheers,
> Nitin
>
> On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > (Using tester program from Daniel)
> >
> > Following compares this kernel port ('take 6') vs original miniLZO code:
> >
> > 'TinyLZO' refers to this kernel port.
> >
> > 10000 run averages:
> > 'Tiny LZO':
> >        Combined: 61.2223 usec
> >        Compression: 41.8412 usec
> >        Decompression: 19.3811 usec
> > 'miniLZO':
> >        Combined: 66.0444 usec
> >        Compression: 46.6323 usec
> >        Decompression: 19.4121 usec
> >
> > Result:
> > Overall: TinyLZO is 7.3% faster
> > Compressor: TinyLZO is 10.2% faster
> > Decompressor: TinyLZO is 0.15% faster
> >
>
>

10000 run averages:
'Tiny LZO':
        Combined: 112.6642 usec
        Compression: 56.3321 usec
        Decompression: 56.3321 usec
'miniLZO':
        Combined: 77.6642 usec
        Compression: 56.3416 usec
        Decompression: 21.3226 usec

now the interesting bit I thought was the following
root@mini:/usr/src/lzo1x-test-4# ./fulltest
[test_lzo.c::compress (93)] run took 42 microseconds
[test_lzo.c::decompress (127)] run took 20 microseconds
root@mini:/usr/src/lzo1x-test-4# ./tinytest
[test.c::compress (91)] run took 44 microseconds
[test.c::decompress (117)] BUG: lzo1x_decompress has failed ( t == -6 )
[test.c::main (149)] BUG: Decompression routine failure
