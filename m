Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbXCRFZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbXCRFZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXCRFZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:25:32 -0400
Received: from 1wt.eu ([62.212.114.60]:1240 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXCRFZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:25:31 -0400
Date: Sun, 18 Mar 2007 06:24:40 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: William Lee Irwin III <wli@holomorphy.com>, Avi Kivity <avi@argo.co.il>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070318052439.GT943@1wt.eu>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com> <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 06:32:29PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 17 Mar 2007, William Lee Irwin III wrote:
> > 
> > One issue this raises is prioritizing users on a system, threads within
> > processes, jobs within users, etc.
> 
> Doing some "classing" even by just euid might be a good idea. It would 
> actually catch X automatically most of the time, because the euid of the X 
> server is likely to be root, so even for the "trivial" desktop example, it 
> would kind of automatically mean that X would get about 50% of CPU time 
> even if you have a hundred user clients, just because that's "fair" by 
> euid.

Warning: all these ideas seem interesting for desktop, but are definitely
not for servers. I found RSDL to be excellent on servers, compared to
mainline in which some services are starving under load. I can understand
that on the desktop people want some unfairness, and I like the pgrp idea
for instance. But this one will certainly fail on servers, or make the
admins get grey hair very soon.

Maybe we're all discussing the problem because we have reached the point
where we need two types of schedulers : one for the desktop and one for
the servers. After all, this is already what is proposed with preempt,
it would make sense provided they share the same core and avoid ifdefs
or unused structure members. Maybe adding OPTIONAL unfairness to RSDL
would help some scenarios, but in any case it is important to retain
the default fairness it provides.

> Dunno. I guess a lot of people would like to then manage the classes, 
> which would be painful as hell. 

Sure ! I wouldn't like people to point the finger on Linux saying "hey
look, they can't write a good scheduler so you have to adjust the knobs
yourself!". I keep in mind that Solaris' scheduler is very good, both
fair and interactive. FreeBSD was good (I haven't tested for a long time).
We should manage to get something good for most usages, and optimize
later for specific uses.

Regards,
Willy

