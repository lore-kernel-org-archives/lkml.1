Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbXELS0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbXELS0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXELS0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:26:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989AbXELS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:26:13 -0400
Date: Sat, 12 May 2007 11:25:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] Freezing of kernel threads
In-Reply-To: <200705122017.32792.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0705121120280.3986@woody.linux-foundation.org>
References: <200705122017.32792.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Rafael J. Wysocki wrote:
> 
> Of course, that would also require us to rewrite the freezer itself quite a
> bit, but IMO it's worthy of doing.
> 
> Thoughts?

I'd much prefer it. One of the reasons I hate the freezer so much is that 
it ends up affecting things it really has no business affecting. Why 
should a random kernel thread have to havecode NOT to care? So it makes 
much more sense to default to "I don't care about the freezer", and then 
people who do care can say so and add their own code.

That said, I also suspect that suspend should depend less on the freezer 
in the first place, and depend more on just shutting up specific actions.

The freezer is kind of a blunt instrument that just stops everything, 
without actually understanding *what* it stops. As a result (since it 
really doesn't know what it's doing), it ends up having all the issues 
with "ok, I don't know what I'm doing, but that guy says I shouldn't do 
it, so I won't".

Blunt instruments are often _easier_ (compare with the global kernel lock 
in SMP), but they end up being very inflexible and hard to get rid of 
later when you want to do something more intelligent. 

		Linus
