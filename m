Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXB1CvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXB1CvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 21:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXB1CvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 21:51:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:20294 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXB1CvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 21:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mAG0CsW3271k81Gj1ewZouUzOmgKoN1vI6LUikXM5Fa95xAXXNFlsHXet0mruQSFFlwEcoFoDkK3RTH0ZrmX8Xj7TFGZOUu1Mkq8e3iiUkTgIHEABhYXZyW2tVNusku9Z07MtK+OzK+0dbTMZ1Vc4TLC3jvKuhbS64Z+0uo6D4g=
Message-ID: <29495f1d0702271851k30d2bf68qf3e23ca4c9d9153d@mail.gmail.com>
Date: Tue, 27 Feb 2007 18:51:06 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: SMP performance degradation with sysbench
Cc: "Rik van Riel" <riel@redhat.com>,
       "Lorenzo Allegrucci" <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <45E4E780.8010109@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172425476.5489.11.camel@odyssey.lan>
	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
	 <29495f1d0702271727w358cc9o644c4017d50634a9@mail.gmail.com>
	 <45E4E780.8010109@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Nish Aravamudan wrote:
> > On 2/26/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >
> >> Rik van Riel wrote:
> >> > Lorenzo Allegrucci wrote:
> >> >
> >> >> Hi lkml,
> >> >>
> >> >> according to the test below (sysbench) Linux seems to have scalability
> >> >> problems beyond 8 client threads:
> >> >> http://jeffr-tech.livejournal.com/6268.html#cutid1
> >> >> http://jeffr-tech.livejournal.com/5705.html
> >> >> Hardware is an 8-core amd64 system and jeffr seems willing to try more
> >> >> Linux versions on that machine.
> >> >> Anyway, is there anyone who can reproduce this?
> >> >
> >> >
> >> > I have reproduced it on a quad core test system.
> >> >
> >> > With 4 threads (on 4 cores) I get a high throughput, with
> >> > approximately 58% user time and 42% system time.
> >> >
> >> > With 8 threads (on 4 cores) I get way lower throughput,
> >> > with 37% user time, 29% system time 35% idle time!
> >> >
> >> > The maximum time taken per query also increases from
> >> > 0.0096s to 0.5273s. Ouch!
> >> >
> >> > I don't know if this is MySQL, glibc or Linux kernel,
> >> > but something strange is going on...
> >>
> >> Like you, I'm also seeing idle time start going up as threads increase.
> >>
> >> I initially thought this was a problem with the multiprocessor scheduler,
> >> because the pattern is exactly like some artificat in the load balancing.
> >>
> >> However, after looking at the stats, and testing a couple of things, I
> >> think it may not be after all.
> >>
> >> I've reproduced this on a 8-socket/16-way dual core Opteron. So far what
> >> I am seeing is that MySQL is having trouble putting enough load into the
> >> scheduler.
> >
> >
> > Here are some graphs from the 4-socket/8-way Xeon box (no SMT, no MC
> > in .config) I posted about earlier.
> >
> > transactions.png resembles Nick's results pretty closely, in that a
> > drop-off occurs, at the same # of threads, too. That seems weird to
> > me, but I haven't thought about it too closely. Shouldn't Nick's be
> > dropping off closer to 16 threads (that would be 1 per core, then,
> > right?)
>
> I don't think it is exactly a matter of processes >= cores, but rather
> just a general problem at higher concurrency.

Ok, thanks for the clarification.

-Nish
