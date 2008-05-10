Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYEJRSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYEJRSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 13:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbYEJRRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 13:17:54 -0400
Received: from gw.goop.org ([64.81.55.164]:47575 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbYEJRRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 13:17:53 -0400
Message-ID: <4825D8B4.3060600@goop.org>
Date: Sat, 10 May 2008 18:17:40 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       John Reiser <jreiser@BitWagon.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <20080510123744.GB19109@one.firstfloor.org>
In-Reply-To: <20080510123744.GB19109@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>  - kmemcheck can only warn for dynamic memory, whereas kmemcheck I
>> believe will also work for local variables, static variables, etc.
>>     
>
> I don't think that's true. valgrind can only detect uninitialized 
> local variables in one special case (first use of the stack region).
> But as soon as you reuse stack which is pretty common it won't 
> be able to detect the next uninitialized use in a stack frame. 
>   

It tracks changes to the stack pointer, and any memory below it is 
considered uninitialized.  But, yes, if you mean that if you use the 
variable (or slot) once in a function, then again later, it will still 
be considered initialized.  But that's no different from any other memory.

    J
