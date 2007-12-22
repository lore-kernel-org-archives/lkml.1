Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXLVMgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXLVMgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 07:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbXLVMgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 07:36:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43232 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLVMgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 07:36:10 -0500
Date: Sat, 22 Dec 2007 13:37:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222123705.GA14767@one.firstfloor.org>
References: <20071221120908.GA15926@elte.hu> <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222100326.GF26157@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> could be offered on SLUB too.

Sure (I argued that in a earlier mail in fact), but it doesn't make
sense to fake into the old slabinfo format.

> 
> 'top' isnt critical functionality either like udev, and the ABI does not 
> only cover 'critical' functionality. A utility suddenly not working 
> gives Linux a pretty amateurish feeling. Should we tell users/admins: 
> "Hehe, gotcha! Didnt you know /proc/slabinfo was not an ABI? Poor sob. 
> If you want your stuff to continue working, use Windows next time around 
> or what. Sheesh, what do these people want!' ;-)

While I sympatise with this point in practice non critial ABIs change
regularly (and sometimes even critical ones like sched_yield ...) 

> 
> the rule is very simple: unless you have really, really, really, REALLY 
> good reasons, just dont break stuff.

Removing an interface that exposes lots of internal details when you
rewrite the subsystem and those internal details all change seems
like a good reason to me.

Besides the original interface was broken anyways. The version
number was one of the interface worst ideas ever imho and slabtop's handling 
of it quite dumb. The better way would have been to always add new 
fields and never remove old ones. Hopefully the new /sys based interface
will be better.

-Andi

