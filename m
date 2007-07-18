Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXGRWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXGRWSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXGRWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:18:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbXGRWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:18:12 -0400
Message-ID: <469E9180.3050906@zytor.com>
Date: Wed, 18 Jul 2007 15:17:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Matt Mackall <mpm@selenic.com>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org> <469E7709.9070801@zytor.com> <20070718210452.GG3898@one.firstfloor.org>
In-Reply-To: <20070718210452.GG3898@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>
>> However, compressed size reductions as an abstract thing is useful for
>> this market.  Just not these particular ones.  The first thing to get
>> there is probably an LZMA-based compressor instead of gzip.
> 
> That would need more memory again.
> 

Actually, even with a 64K dictionary size (for which point the
decompression runtime memory requirements are comparable to gzip) LZMA
beats both gzip -9 and bzip2 -9 quite handily:

Reference (this is an i386 kernel):

-rwxrwxr-x 1 hpa hpa 5607558 Jul 18 15:04 vmlinux.bin*
-rw-rw-r-- 1 hpa hpa 2658275 Jul 18 15:04 vmlinux.bin.bz2
-rw-rw-r-- 1 hpa hpa 2760849 Jul 18 15:04 vmlinux.bin.gz

Pure LZMA with dictionary sizes from 2^16 to 2^24:

-rw-rw-r-- 1 hpa hpa 2380983 Jul 18 15:14 d16.7z
-rw-rw-r-- 1 hpa hpa 2317458 Jul 18 15:15 d18.7z
-rw-rw-r-- 1 hpa hpa 2284746 Jul 18 15:15 d20.7z
-rw-rw-r-- 1 hpa hpa 2264001 Jul 18 15:15 d22.7z
-rw-rw-r-- 1 hpa hpa 2263185 Jul 18 15:15 d24.7z

LZMA with BCJ precompression:

-rw-rw-r-- 1 hpa hpa 2236070 Jul 18 15:14 d16bcj.7z
-rw-rw-r-- 1 hpa hpa 2167873 Jul 18 15:15 d18bcj.7z
-rw-rw-r-- 1 hpa hpa 2134541 Jul 18 15:15 d20bcj.7z
-rw-rw-r-- 1 hpa hpa 2112987 Jul 18 15:15 d22bcj.7z
-rw-rw-r-- 1 hpa hpa 2111917 Jul 18 15:15 d24bcj.7z

> Better just write less bloated code. Perhaps mandatory bloatometer
> runs during -rc*s for kernels with minimal config with public code pig shame lists
> similar to the regression lists are useful. Anyone volunteering?
> 
> I suspect there is also much more low hanging fruit of this around.

Most likely.

> I don't think eliminating cpuid is a step forward though; that's
> just madness.

Agreed, especially given the invasiveness of the patch.

	-hpa
