Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYH1Npe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYH1Npe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYH1Np0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:45:26 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:42202 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753137AbYH1NpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:45:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hWiPmKMPUO1Bii00suBpCG3KRSkIf+ox68aWOCZc9UCrNznyBeBLEtXaFrbBZiRmjwl3WYlLBkBIOn9UezYjCb6CCecfMXtdraQrQsuELszQtDt4nADOCSLmXQyzDKDi/G8wRy1lj7ew2BuSeVEJariO8+QhYRS8tLNHK0c9imI=  ;
X-YMail-OSG: mjh5PDoVM1mhReLx.nPWsz2qDQJN45U9.tIAFC6Rfp88P7pJDwiUq7F68K34KkGw0n3PYCQd0Lc.6rtDtPCchFSAM7DJh6Sk2RYA3sBXZylxOoVxwnKGrORDEK_0xlMFXlw6Gudr2jfIgdylwOJvTdwH
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Thu, 28 Aug 2008 23:45:16 +1000
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808282203.48396.nickpiggin@yahoo.com.au> <20080828130708.GA19672@elte.hu>
In-Reply-To: <20080828130708.GA19672@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808282345.16564.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 23:07, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > There is no customer issue and there is no handwaving about
> > compliance;
>
> well, the reason i'm asking is that i cannot for anything in the world
> imagine you being so upset about _anything_ but something that involves
> benchmark runs ;-)

;) Well yes as you know I'm not actively doing much scheduler work for
a while now. Luckily there are a lot of really good people who probably
do a better job on it than me anyway, so on the whole I'm quite happy
with it.

But ironically that's also why I hadn't raised my concerns earlier... I
simply was not aware of the change. So I wish I had participated in the
discussion earlier, but that's life, so I have to raise my concern now.


> And what does SCHED_FIFO RT policy scheduling have to do with
> performance and benchmarks? Nothing usually in the real world, except
> for this little known fact: a common 'tuning' for TPC database
> benchmarks is to run all DB threads as SCHED_FIFO to squeeze the last
> 0.1% of performance out of the setup.
>
> So - and i'm taking an educated guess here - is SCHED_FIFO+TPC
> performance perhaps one of the factors that played a role in you
> initiating this thread? If yes then it's obviously an incredibly broken
> use of SCHED_FIFO and we can add the sysctl tuning to the long list of
> dozens of other tunings that happen before a TPC run anyway.
>
> Hm?

To address this concern: no, it is not tpc ;) Actually I don't know a
thing about how tpc except what scant information can basically be
gained on the list (disclaimer: I probably could find out more under
NDA, but I don't care to).

No, there is no customer behind the scenes and nor do I have a use
case myself. I really would have told you about it by now.

I'm concerned because I honestly think there is a risk of breaking
systems. I also think that in this problem space, people often care
about guard bands and worst case scenarios so even if the app does
not do a cpu hogging polling loop or cooperative scheduling or
anything like that, then I think it is risky to add this source of
uncertianty.

The other issue is that the old behaviour (and, dare I say it,
specification) is quite straightforward. At least it is simpler and thus
I guess easier to analyze than this behaviour with the added caveat.

I realise that as Linux gets better at this, people are wanting to use
-rt programs like audio mixing on their desktops and for that kind of
thing, throttling is probably often the desired behaviour. So I can
see why it was implemented. I just think it is a nasty surprise to
have this behaviour by default in the kernel.

I hope I explained myself better now. I was not being too constructive
when I was getting heated.

What I would like to see is maybe a new SCHED_ policy or two which can
be defined basically as rt-with-throttle which some apps could use. I
also think the sysctl to throttle it is a fine idea. And for desktop
installations there is probably a much stronger argument for it. But I
disagree with having it default from kernel.org like this.

