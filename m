Return-Path: <linux-kernel-owner+w=401wt.eu-S934613AbXGRRSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbXGRRSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbXGRRSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:18:31 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:33456 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761557AbXGRRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:18:30 -0400
Message-ID: <469E4B1A.8050807@gmail.com>
Date: Wed, 18 Jul 2007 19:17:14 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <469D7D1B.4050909@gmail.com> <20070718165402.GK11115@waste.org>
In-Reply-To: <20070718165402.GK11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2007 06:54 PM, Matt Mackall wrote:

> You can expect the distribution of file sizes to follow a gamma
> distribution, with a large hump towards the small end of the spectrum
> around 1-10K, dropping off very rapidly as file sizes grow.

Okay.

>> Not too sure then that 8K wouldn't be something I'd want, given fewer 
>> pagefaults and all that...
> 
> Fewer minor pagefaults, perhaps. Readahead already deals with most of
> the major pagefaults that larger pages would.

Mmm, yes.

> Anyway, raising the systemwide memory overhead by up to 15% seems an 
> awfully silly way to address the problem of not being able to allocate a
> stack when you're down to your last 1 or 2% of memory!

Well, I've seen larger pagesizes submerge in more situations, specifically 
in allocation overhead -- ie, making the struct page's fit in lowmem for 
hugemem x86 boxes was the first I heard of it. But yes, otherwise (also) 
mostly database loads which obviously have moved to 64-bit since.

Pagecache tail-packing seems like a promising idea to deal with the downside 
of larger pages but I'll admit I'm not particularly sure how many _up_ sides 
to them are left on x86 (not -64) now that's becoming a legacy architecture 
(and since you just shot down the pagefaults thing).

Rene.
