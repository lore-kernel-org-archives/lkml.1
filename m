Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbYDTSTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbYDTSTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYDTSTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:19:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44444 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYDTSTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:19:38 -0400
Message-ID: <480B8932.1090308@firstfloor.org>
Date: Sun, 20 Apr 2008 20:19:30 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <20080420133857.GB26536@1wt.eu> <480B50F1.8040309@firstfloor.org> <20080420164133.GB20694@logfs.org> <480B7B1E.7010707@firstfloor.org> <20080420174249.GC20694@logfs.org>
In-Reply-To: <20080420174249.GC20694@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Sun, 20 April 2008 19:19:26 +0200, Andi Kleen wrote:
>> But these are SoC systems. Do they really run x86?
>> (note we're talking about an x86 default option here)
>>
>> Also I suspect in a true 16MB system you have to strip down
>> everything kernel side so much that you're pretty much outside
>> the "validated by testers" realm that Adrian cares about.
> 
> Maybe.  I merely showed that embedded people (not me) have good reasons
> to care about small stacks. 

Sure but I don't think they're x86 embedded people. Right now there
are very little x86 SOCs if any (iirc there is only some obscure rise
core) and future SOCs will likely have more RAM.

Anyways I don't have a problem to give these people any special options
they need to do whatever they want.  I just object to changing the
default options on important architectures to force people in completely
different setups to do part of their testing.


 Whether they care enough to actually spend
> work on it - doubtful.
> 
>>> When dealing in those dimensions, savings of 100k are substantial.  In
>>> some causes they may be the difference between 16MiB or 32MiB, which
>>> translates to manufacturing costs.  In others it simply means that the
>>> system can cache 
>> If you need the stack you don't have any less cache foot print.
>> If you don't need it you don't have any either.
> 
> This part I don't understand.

I was just objecting to your claim that small stack implies smaller
cache foot print. Smaller stacks rarely give you smaller cache foot
print in my kernel coding experience:

First some stack is always safety and in practice unused. It won't
be in cache.

Then typically standard kernel stack pigs are just too large
buffers on the stack which are not fully used. These also
don't have much cache foot print.

Or if you have a complicated call stack the typical fix
is to move parts of it into another thread. But that doesn't
give you less cache footprint because the cache foot print
is just in someone else's stack. In fact you'll likely
have slightly more cache foot print from that due to the
context of the other thread.

In theory if you e.g. convert a recursive algorithm
to iterative you might save some cache foot print, but I don't
think that really happens in kernel code.

-Andi
