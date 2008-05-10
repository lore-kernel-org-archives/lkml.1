Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYEJXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYEJXFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 19:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYEJXFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 19:05:24 -0400
Received: from gw.goop.org ([64.81.55.164]:43157 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYEJXFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 19:05:23 -0400
Message-ID: <48262A23.6030902@goop.org>
Date: Sun, 11 May 2008 00:05:07 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: John Reiser <jreiser@BitWagon.com>
CC: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <20080510123744.GB19109@one.firstfloor.org> <4825D8B4.3060600@goop.org> <20080510174841.GC31954@one.firstfloor.org> <4826095F.3070501@goop.org> <482613B6.2080301@BitWagon.com>
In-Reply-To: <482613B6.2080301@BitWagon.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Reiser wrote:
> The valgrind+uml patches added a callback, "I am switching stacks >NOW<."
>   
Hm, I never particularly liked that approach because unless you do the 
whole thing in assembly it was never certain that there wasn't a 
basic-block break between them (ie, atomic with respect to valgrind).  
For the kernel that may be possible, but I was thinking of the general 
case where you might want to use setjmp or something.

> If possible then it is better to tell an interpreter what is happening,
> rather than requiring that the interpreter [try to] figure it out.
>   

Matter of taste really, but I tend to disagree.  If you say something 
like "addresses A-B, C-D, E-F are stacks", then the stack pointer 
changing from the range A-B to C-D is a pretty clear indication of stack 
switch, regardless of the mechanism you use to do it.  Of course, an 
explicit hint prevents an accidental push/pop of 32k onto an 8K stack 
from being considered a stack switch, but unless you actually know where 
the stacks are, you can't warn about it or prevent it from 
validating/invalidating a pile of innocent memory.

    J
