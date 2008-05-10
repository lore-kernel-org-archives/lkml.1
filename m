Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYEJMam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYEJMam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 08:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYEJMac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 08:30:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYEJMac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 08:30:32 -0400
Date: Sat, 10 May 2008 14:37:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       John Reiser <jreiser@BitWagon.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
Message-ID: <20080510123744.GB19109@one.firstfloor.org>
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - kmemcheck can only warn for dynamic memory, whereas kmemcheck I
> believe will also work for local variables, static variables, etc.

I don't think that's true. valgrind can only detect uninitialized 
local variables in one special case (first use of the stack region).
But as soon as you reuse stack which is pretty common it won't 
be able to detect the next uninitialized use in a stack frame. 

Luckily the compilers do a reasonable job at detecting them at build time.

And static/global variables are never uninitialized in C.

-Andi
