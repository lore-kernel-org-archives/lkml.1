Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbXE1OuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbXE1OuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXE1OuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:50:01 -0400
Received: from keil-draco.com ([216.193.185.50]:50223 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753418AbXE1OuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:50:00 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Mon, 28 May 2007 10:49:48 -0400
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
In-Reply-To: <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281049.48679.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 10:40:31 Nitin Gupta wrote:
> Hi,
>
> Attached is tester code used for testing.
> (developed by Daniel Hazelton -- modified slightly to now use 'take 6'
> version for 'TinyLZO')
>
> Cheers,
> Nitin
>

<snip>
I haven't tested with version 6, but after removing the LZO_CHECK_MPOS_NON_DET 
macro from the 'take 5' code and replacing the open-coded byte-for-byte 
copies with calls to memcpy:

10000 run averages:
'Tiny LZO':
        Combined: 57.4691 usec
        Compression: 39.8837 usec
        Decompression: 17.5854 usec
'miniLZO':
        Combined: 64.0484 usec
        Compression: 46.0604 usec
        Decompression: 17.988 usec

which means:
Overall TinyLZO is 10.2% faster
TinyLZO compresses 13.4% faster
TinyLZO decompresses 2.23% faster

-Benchmark run a a Pentium-M 1.73GHz, 1GB Ram
With the speed-up seen with just the removal of the LZO_CHECK_MPOS_NON_DET I 
wasn't sure that changing the open-coded copy to a call to memcpy() was going 
to have a big impact on the code, but it does appear to have has several 
percentage points of difference. (Though I am unsure about the speed increase 
with the decompression - I didn't touch that file when making this set of 
changes. I'm going to make the memcpy() changes to 'take 6' and see if the 
speed-up holds true)

DRH
