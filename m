Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbXE3FUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbXE3FUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXE3FT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:19:57 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:61491 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXE3FT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Plu1DNq2VxL536Ew7VHDvyHhpl0rn5Uevl3Eww5BeI6j+YpVCTjTLkUUgpYJ6L+3iRuHm2Zdq81iGvlCuTnDHXFi/zDgMDcZ58DUrH/1Ae0EfOz24l69KQ/4pTYaNRGIlUogpR5bVzR/wX0TNfTDOIDP1jXpUmWRw8rxp41441o=
Message-ID: <4cefeab80705292219x31956353r308b0ed0a052071@mail.gmail.com>
Date: Wed, 30 May 2007 10:49:45 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: "Bret Towe" <magnade@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <200705291932.04255.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <dda83e780705281553s67ace88at60f6ab28b198a832@mail.gmail.com>
	 <4cefeab80705282258p570c649aja5a60b82f63c2440@mail.gmail.com>
	 <200705291932.04255.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> I just noticed a bug in my testbed/benchmarking code. It's fixed, but I
> decided to compare version 6 of the code against the *unsafe* decompressor
> again. The results of the three runs I've put it through after changing it to
> compare against the unsafe decompressor were startling. `Tiny's` compressor
> is still faster - I've seen it be rated up to 3% faster. The decompressor,
> OTOH, when compared to the unsafe version (which is the comparison that
> started me on this binge of hacking), is more than 7% worse. About 11% slower
> on the original test against a C source file, and about 6% slower for random
> data.

Unsafe vs safe is within 10%. Its okay.

> However, looking at the numbers involved, I can't see a reason to keep
> the unsafe version around - the percentages look worse than they are - from 1
> to 3 microseconds.

Not just numbers. Most of applications cannot afford to use unsafe
versions anyway (like fs people).

(well, the compressed-cache people might want those extra
> usecs - but the difference will never be noticeable anywhere outside the
> kernel)
>
> DRH
>

compressed cache people require every single percent of that
performance. For now, ccaching is not ready for mainline (many things
need to be done). So, till then I will keep off the unsafe version. If
ever compressed caching is on its way to mainline _then_ I will try
and add back the unsafe version. But I see no other project that
really cares about unsafe version so it's okay to keep it off.


- Nitin
