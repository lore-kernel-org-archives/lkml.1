Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXJBLvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXJBLvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXJBLu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:50:59 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3483 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXJBLu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:50:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 02 Oct 2007 11:50:54.0786 (UTC) FILETIME=[7D1B5220:01C804EA]
Content-class: urn:content-classes:message
Subject: Re: yield API
Date: Tue, 2 Oct 2007 07:50:39 -0400
Message-ID: <Pine.LNX.4.61.0710020733270.16314@chaos.analogic.com>
In-Reply-To: <20071002064620.GA26638@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: yield API
Thread-Index: AcgE6n0kM04N9JDBTjCSfV9KV5pL+Q==
References: <20071001173159.GB2492@elte.hu> <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com> <20071002064620.GA26638@elte.hu>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "David Schwartz" <davids@webmaster.com>, <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Oct 2007, Ingo Molnar wrote:

>
> * David Schwartz <davids@webmaster.com> wrote:
>
>>> These are generic statements, but i'm _really_ interested in the
>>> specifics. Real, specific code that i can look at. The typical Linux
>>> distro consists of in execess of 500 millions of lines of code, in
>>> tens of thousands of apps, so there really must be some good, valid
>>> and "right" use of sched_yield() somewhere in there, in some
>>> mainstream app, right? (because, as you might have guessed it, in
>>> the past decade of sched_yield() existence i _have_ seen my share of
>>> sched_yield() utilizing user-space code, and at the moment i'm not
>>> really impressed by those examples.)
>>
>> Maybe, maybe not. Even if so, it would be very difficult to find.
>> Simply grepping for sched_yield is not going to help because
>> determining whether a given use of sched_yield is smart is not going
>> to be easy.
>
> sched_yield() has been around for a decade (about three times longer
> than futexes were around), so if it's useful, it sure should have grown
> some 'crown jewel' app that uses it and shows off its advantages,
> compared to other locking approaches, right?
>
> For example, if you asked me whether pipes are the best thing for
> certain apps, i could immediately show you tons of examples where they
> are. Same for sockets. Or RT priorities. Or nice levels. Or futexes. Or
> just about any other core kernel concept or API. Your notion that
> showing a good example of an API would be "difficult" because it's hard
> to determine "smart" use is not tenable i believe and does not
> adequately refute my pretty plain-meaning "it does not exist" assertion.
>
> If then this is one more supporting proof for the fundamental weakness
> of the sched_yield() API. Rarely are we able to so universally condemn
> an API: real-life is usually more varied and even for theoretically
> poorly defined APIs _some_ sort of legitimate use does grow up.
>
> APIs that are not in any real, meaningful use, despite a decade of
> presence are not really interesting to me personally. (especially in
> this case where we know exactly _why_ the API is used so rarely.) Sure
> we'll continue to support it in the best possible way, with the usual
> kernel maintainance policy: without hurting other, more commonly used
> APIs. That was the principle we followed in previous schedulers too. And
> if anyone has a patch to make sched_yield() better than it is today, i'm
> of course interested in it.
>
> 	Ingo

But sched_yield() on Linux never did what the majority of
programmers assumed it would do (give up the CPU to some
runnable processes for the rest of the time-slice). Instead,
it just appeared to spin in the kernel. Therefore, those
who needed a sched_yield(), just used usleep().

Whether or not there is a POSIX definition of sched_yield(),
there is a need for something that will give up the CPU
and not busy-wait. There are many control applications
where state-machines are kept in user-mode code. The code
waits for an event. It shouldn't be spinning, wasting
CPU time, when the kernel can be doing file and network
I/O with the wasted CPU cycles.

So, just because sched_yield() doesn't work as expected,
is not the reason to get rid of it.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
