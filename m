Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYLPQFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYLPQFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYLPQFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:05:05 -0500
Received: from smtp02.uc3m.es ([163.117.176.132]:53074 "EHLO smtp02.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbYLPQFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:05:04 -0500
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200812161604.mBGG4qT10889@inv.it.uc3m.es>
Subject: Re: time_is_after_jiffies misnomer
In-Reply-To: From (env: ptb) at "Dec 16, 2008 04:17:30 pm"
To: hannes@cmpxchg.org
Date: Tue, 16 Dec 2008 17:04:52 +0100 (MET)
CC: "linux kernel" <linux-kernel@vger.kernel.org>
X-Anonymously-To: 
Reply-To: ptb@inv.it.uc3m.es
X-message-flag: Had your Outlook virus, today?  
	http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
Reply-By: Sat, 1 Apr 2006 14:21:08 -0700
X-Mailer: ELM [version 2.4ME+ PL66 (25)]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:N SM:2
X-imss-tmaseResult: TT:1 TS:-19.8566 TC:1F TRN:28 TV:5.5.1026(16344.000)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Also sprach ptb:"
> "Also sprach Johannes Weiner:"
> > 'foo jiffies'?
> 
> ?? What does that mean? Yes, "the current time is later than foo
> jiffies", is what I wrote.  I don't understand why you query it. What I
> wrote is a perfectly normal english sentence.

Light dawns. Perhaps you think "jiffies" is a meaningless word that
happens to be the name of a variable that measures elapsed time.

It's not. "jiffy" is a "short moment of time" in english, and "jiffies"
is its plural. Like "augenblick" in german, but a bit longer
("augenblick" probably translates as "moment", or "instant", literally,
"eyeblink").  "In a jiffy" is an english phrase meaning "soon!".  It's
close to an "instant" but of vaguer extent.

So the variable called "jiffies" measures the number of elapsed
jiffies.

Like a variable called "hours" that measures the number of elapsed
hours.

"foo jiffies" is no stranger than "foo hours" or "foo minutes" or "foo
seconds". That's why I was puzzled that you queried it!

> It's poor english. Yes, to an english speaker
> 
>    time_is_after_jiffies(foo)
> 
> looks like
> 
>    the current time is later than foo jiffies
> 
> Look at the two:
> 
>    the current time is later than foo jiffies
>                  |   |  |           `/.
>                time_is_after_jiffies(foo)


See it now? 

Imagine that you had a macro called


   time_is_after_hours

then 

  time_is_after_hours(12)


would mean to an english speaker

  the current time is later than midday

I.e.

  the current time is later than 12h
               |    |   |        .|'
              time_is_after_hours(12)

Unfortunately the kernel's "time_is_after_hours(12)" macro means
mathematically what we would express in english as "the current time is
BEFORE 12h".  Ouch.

The kernel's 

     time_is_after_jiffies(500)

macro mathematically means

    the current value of the jiffies variable is LESS THAN 500

!! That's the other way round from the way that an english speaker
would read the macro name as meaning! So the semantics and the name
contradict each other.

Clear now?

Peter
