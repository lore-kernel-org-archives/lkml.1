Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYHYAwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYHYAwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 20:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYHYAwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 20:52:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbYHYAwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 20:52:31 -0400
Date: Sun, 24 Aug 2008 17:51:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Greaves <david@dgreaves.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <48B1B526.2030100@dgreaves.com>
Message-ID: <alpine.LFD.1.10.0808241734400.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241030060.3363@nehalem.linux-foundation.org> <48B1B526.2030100@dgreaves.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Aug 2008, David Greaves wrote:
> 
> Given that I'll manage at best 1 bisect/day with a reasonable chance of data
> corruption and hardware intermittency screwing it all up I thought it best to
> ask first in case there was another debug approach that could work.

Well, regardless, I think it would be good to fill in the hardware info, 
especially wrt CPU data and the exact SATA controller you have.

There's another regression for SATA cold/hot boot issues, and while that 
one looks very different, and is probably not really related, it's still a 
good idea to try to see if we can match them up. See

	Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11343
	Subject         : SATA Cold Boot Problems with 2.6.27-rc[23] on nVidia 680i
	Submitter       : Manny Maxwell <mannymax@mannymax.net>
	Date            : 2008-08-14 4:16 (10 days old)
	References      : http://marc.info/?l=linux-kernel&m=121868782917600&w=4

which actually has a patch, and which seems to work fine in 2.6.26 (so not 
only is failure pattern different, the point were it starts is different). 

But regardless of the big differences, it does seem to point to some 
weakness in SATA initialization. But is it limited to _that_ particular 
SATA controller, or just a few ones? Or a generic issue? Without more 
reports to really find a pattern, I don't think we have a clue, and the 
two may be _totally_ unrelated in all ways, but it would be good to at 
least report and log the information you have..

Oh, I just noticed that your dmesg _does_ mention sata_sil and sata_via, 
so we know which of two drivers it would be, at least. Not the nVidia one.

However, there's been tons of changes in soem core functions: both the 
reset handling and the wait-for-ready has changed and caused lots of churn 
across most drivers in between 2.6.25 and 2.6.26. 

> PS if anyone really is interested then I am happy to try the bisection once I've
> moved her to a new box; otherwise I'm happy to close this.

I think it would be good to try to bisect. It could be something that is 
really just limited to that particular machine (maybe it really is some 
flaky hardware that just triggers some timing changes), but more likely it 
isn't. So the more information, the better. So keep the thing open as long 
as somebody is willing to try to gather more info, by all means.

		Linus
