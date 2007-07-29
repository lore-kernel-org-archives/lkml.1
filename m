Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXG2INm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXG2INm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 04:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760078AbXG2INb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 04:13:31 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:42530 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXG2IN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 04:13:29 -0400
Message-ID: <46AC4B97.5050708@gmail.com>
Date: Sun, 29 Jul 2007 10:11:03 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: david@lang.hm, Daniel Hazelton <dhazelton@enter.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	<20070727030040.0ea97ff7.akpm@linux-foundation.org>	<1185531918.8799.17.camel@Homer.simpson.net>	<200707271345.55187.dhazelton@enter.net>	<46AA3680.4010508@gmail.com>	<Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm>	<46AAEDEB.7040003@gmail.com>	<Pine.LNX.4.64.0707280138370.32476@asgard.lang.hm>	<46AB166A.2000300@gmail.com> <20070728122139.3c7f4290@the-village.bc.nu>
In-Reply-To: <20070728122139.3c7f4290@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2007 01:21 PM, Alan Cox wrote:

>> It is. Prefetched pages can be dropped on the floor without additional
>> I/O.
> 
> Which is essentially free for most cases. In addition your disk access 
> may well have been in idle time (and should be for this sort of stuff)

Yes. The swap-prefetch patch ensures that the machine (well, the VM) is very 
idle before it allows itself to kick in.

> and if it was in the same chunk as something nearby was effectively free 
> anyway.
> 
> Actual physical disk ops are precious resource and anything that mostly 
> reduces the number will be a win - not to stay swap prefetch is the right
> answer but accidentally or otherwise there are good reasons it may
> happen to help.
> 
> Bigger more linear chunks of writeout/readin is much more important I 
> suspect than swap prefetching.

Yes, I believe this might be an important point. Earlier I posted a dumb 
little VM thrasher:

http://lkml.org/lkml/2007/7/25/85

Contrived thing and all, but what it does do is show exactly how bad seeking 
all over swap-space is. If you push it out before hitting enter, the time it 
takes easily grows past 10 minutes (with my 768M) versus sub-second (!) when 
it's all in to start with.

What are the tradeoffs here? What wants small chunks? Also, as far as I'm 
aware Linux does not do things like up the granularity when it notices it's 
swapping in heavily? That sounds sort of promising...

>> good overview of exactly how broken -mm can be at times. How many -mm users 
>> use it anyway? He himself said he's not convinced of usefulness having not 
> 
> I've been using it for months with no noticed problem. I turn it on
> because it might as well get tested. I've not done comparison tests so I
> can't comment on if its worth it.
> 
> Lots of -mm testers turn *everything* on because its a test kernel.

Okay.

Rene.

