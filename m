Return-Path: <linux-kernel-owner+w=401wt.eu-S1763211AbXJOKTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763211AbXJOKTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 06:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbXJOKTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 06:19:46 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:39908 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbXJOKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:19:45 -0400
Message-ID: <47133E44.3070708@aitel.hist.no>
Date: Mon, 15 Oct 2007 12:17:40 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
References: <20071012082534.GB1962@ff.dom.local> <470F337A.9090205@aitel.hist.no> <20071012091213.GC1962@ff.dom.local> <470F6C43.4090905@aitel.hist.no> <20071012132929.GA4013@ff.dom.local>
In-Reply-To: <20071012132929.GA4013@ff.dom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Fri, Oct 12, 2007 at 02:44:51PM +0200, Helge Hafting wrote:
> ...
>   
>> The point is that we _trust_ intel when they says "this will work".
>> Therefore, we can use the optimizations. It was never about
>> legal matters. If we didn't trust intel, then we couldn't
>> use their processors at all.
>>     
>
> But there was nothing about trust. Usually you don't trust somebody
> but somebody's opinions. The problem is there was no valid opinion,
> or this opinion has been changed now (no reason to not trust yet...).
>   
"Trusting people or their opinions" is only about use of the
english language, and not that intersting to bring up here.
Surely you know that lots of people here have english as
a secondary language only. Intersting for me to know, but
probably not for everybody else.

>> We couldn't take the chance before. It was not documented
>> to work, verification by testing would not be trivial at all for
>> this case.
>> Linux is about "stability first, then performance".
>> Now we _know_ that we can have this optimization without
>> compromising stability. Nobody knew before!
>>     
>
> So, you think this would be the first or the least credibly
> verified undocumented feature used in linux? Then, it seems
> I can try to install this linux on my laptop at last! (...
> And, I can trust you, it will not break anything...?)
>   
I never claimed that linux will work on your laptop, so no:
You can't take my word for that, because I never gave it!
It is well known that some laptops don't work with linux,
I have no idea if yours will work, I don't even know what kind it is.

I told you the reasoning behind using _this particular optimization_,
the same does _not_ apply to everything else. If you think every
kernel decision is made the same way, then you are mistaken.
Things don't work that way.
First, several people are involved - they think differently.
Second, "what kind of tricks to use" is not an all-or-nothing
approach. If linux were to use every undocumented trick
that might or might not work, then linux would fail on
lots of hardware. It would not be useful.
If linux took the other approach and never used any "tricks",
then  it'd be slow and boring.

Some things are much easier to test - you construct a testcase
or just build a test kernel and benchmark it. If all is ok, then
the "trick" is useable. Some cases are a clear win for lots of
machines, and the possible failure cases involves
very rare hardware. So it might get used. Some tricks have
a failure mode that is rare but completely obvious when it happens.
So it gets used, and "troublesome hardware" is added to a blacklist
as needed.

Some "tricks" however, are hard to figure out without docs.
There may be no good way to test. The tricks
may cause instability that will be very hard to track down, and this could
happen on a wide range of hardware. So such don't get used, until
adequate documentation appear. In this case, it seems like intel,
who make and design the processors in question and therefore
know them well enough, provided such documentation. That
makes a previously dubious optimization safe.

Helge Hafting


