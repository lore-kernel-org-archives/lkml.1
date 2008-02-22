Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbYBVQnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbYBVQnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYBVQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:43:34 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbYBVQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:43:33 -0500
Date: Fri, 22 Feb 2008 08:43:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
In-Reply-To: <p73lk5d89ra.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.1.00.0802220827520.19896@woody.linux-foundation.org>
References: <47BDE731.60801@goop.org> <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org> <47BDEA5E.4070800@goop.org> <alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org> <p73lk5d89ra.fsf@bingen.suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Feb 2008, Andi Kleen wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> >
> > (*) I keed, I keed. Of *course* I'll have to fix things like this in the 
> > future too. But hopefully not quite as often.
> 
> The pragmatic solution would be to just fix the scripts to accept From
> everywhere @)

I worry about that. We've actually had to tighten up the scripts over time 
to not assign meaning to things, because people put various things in the 
free-form descriptions, and it's really bad to corrupt the description.

This isn't a problem with things like "Signed-off-by:" etc tags, because 
they have no automated meaning and don't really change the commit itself, 
but the "From:"/"Date:"/"Subject:" markers at the head of the message 
really do have real meaning, and get removed from the commit message and 
instead get put into the SCM headers.

So I'd rather have the rules be very strict and not cause any surprises, 
than have loose rules and then occasionally an email has a "From:" in the 
middle and my scripts get all confused.

It's not a *huge* problem, and my gut feel is that it's getting rarer as 
people learn. Rigth now we have about 86,000 commits in the mainline git 
history, and 807 (less than 1%) of those have a 'From:' in the message. 
And in many cases, that "From:" was at the head, so there are simply 
people who do not *use* the standard scripts and making the scripts accept 
it everywhere wouldn't have helped anyway!

And in the great majority of cases - at least the ones I looked at - 
authorship actually got attributed correctly. And in some of the cases, 
the "From:" really *was* part of the message, and removing it would have 
been wrong. See for example 22e78fafbdf84883f70eb4944cf658fc23c4a1f4 where 
the From: was about an email exchange (it gave the rigth author anyway, 
but without that line the commit message would have made less sense).

There are a few other cases with "From:" in the middle, where the From: 
doesn't mean authorship (but attributes fixes to the patch, for example). 
It's admittedly fairly rare, but it shows that it happens (I found 
something like four occurrences of that before I got too bored).

			Linus
