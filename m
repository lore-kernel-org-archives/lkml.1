Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbZC0SJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbZC0SJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZC0SJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:09:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbZC0SJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:09:36 -0400
Date: Fri, 27 Mar 2009 11:05:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090327171955.78662c1e@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <20090327171955.78662c1e@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Alan Cox wrote:
> 
> The kernel cannot tell them apart, while fsync/close() as a pair allows
> the user to correctly indicate their requirements.

Alan. Repeat after me: "fsync()+close() is basically useless for any app 
that expects user interaction under load".

That's a FACT, not an opinion.

> For an event driven app you really want some kind of threaded or async
> fsync then close

Don't be silly. If you want data corruption, then you make people write 
threaded applications. Yes, you may work for Intel now, but that doesn't 
mean that you have to drink the insane cool-aid. Threading is HARD. Async 
stuff is HARD. 

We kernel people really are special. Expecting normal apps to spend the 
kind of effort we do (in scalability, in error handling, in security) is 
just not realistic. 

> Agreed - which is why close should not happen to do an fsync(). That's
> their problem for writing code thats specific to some random may happen
> behaviour on certain Linux releases - and unfortunately with no obvious
> cheap cure.

I do agree that close() shouldn't do an fsync - simply for performance 
reasons.

But I also think that the "we write meta-data synchronously, but then the 
actual data shows up at some random later time" is just crazy talk. That's 
simply insane. It _guarantees_ that there will be huge windows of times 
where data simply will be lost if something bad happens.

And expecting every app to do fsync() is also crazy talk, especially with 
the major filesystems _sucking_ so bad at it (it's actually a lot more 
realistic with ext2 than it is with ext3).

So look for a middle ground. Not this crazy militant "user apps must do 
fsync()" crap. Because that is simply not a realistic scenario.

			Linus
