Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbXKNTqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbXKNTqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbXKNTpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:45:55 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:2641 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXKNTpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:45:54 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 14:45:54 EST
Message-ID: <473B4FE5.7000601@hp.com>
Date: Wed, 14 Nov 2007 14:43:33 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>	<20071015114738.6b5a25c7.akpm@linux-foundation.org>	<20071015161315.4fe18e07@bree.surriel.com>	<20071015141236.62b075c6.akpm@linux-foundation.org>	<473B18BA.5000709@hp.com>	<20071114091451.d4b110db.akpm@linux-foundation.org>	<20071114171805.GA20959@elte.hu> <20071114095151.43c5e576@laptopd505.fenrus.org>
In-Reply-To: <20071114095151.43c5e576@laptopd505.fenrus.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 14 Nov 2007 18:18:05 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>     
>>> ooh, more performance testing.  Thanks
>>>
>>>       
>>>>     * The overwriter task (on an 8GiB file), average over 10 runs:
>>>>           o 2.6.24 - 300.88226 seconds
>>>>           o 2.6.24 + Arjan's patch - 403.85505 seconds
>>>>
>>>>     * The read-a-different-kernel-tree task, average over 10 runs:
>>>>           o 2.6.24 - 46.8145945549 seconds
>>>>           o 2.6.24 + Arjan's patch - 39.6430601119 seconds
>>>>
>>>>     * The large-linear-read task (on an 8GiB file), average over
>>>> 10 runs: o 2.6.24 - 290.32522 seconds
>>>>           o 2.6.24 + Arjan's patch - 386.34860 seconds
>>>>         
>>> These are *large* differences, making this a very signifcant
>>> patch. Much care is needed now.
>>>       
>> and the numbers suggest it's mostly a severe performance regression. 
>> That's not what i have expected - ho hum. Apologies for my earlier 
>> "please merge it already!" whining.
>>     
>
> that's.. not automatic; it depends on what the right thing is :-(
> What for sure changes is that who gets to do IO changes. Some of the
> tests we ran internally (we didn't publish yet because we saw REALLY
> large variations for most of them even without any patch) show for
> example that "dbench" got slower. But.. dbench gets slower when things
> get more fair, and faster when things get unfair. What conclusion you
> draw out of that is a whole different matter and depends on exactly
> what the test is doing, and what is the right thing for the OS to do in
> terms of who gets to do the IO.
>
> THis makes the patch more tricky than the one line change suggests, and
> this is also why I haven't published a ton of data yet; it's hard to
> get useful tests for this (and the variation of the 2.6.23+ kernels
> makes it even harder to do anything meaningful ;-( )
>
>
>   
I'd also like to point out here that the run-to-run deviation was indeed 
quite large for both the unpatched- and patched-kernels, I'll report on 
that information with the next set of results...

Alan
