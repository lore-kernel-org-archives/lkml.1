Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbXGWRkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbXGWRkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbXGWRkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:40:45 -0400
Received: from gw.goop.org ([64.81.55.164]:58510 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbXGWRko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:40:44 -0400
Message-ID: <46A4E7E3.8090105@goop.org>
Date: Mon, 23 Jul 2007 10:39:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in> <46A4D612.9050209@goop.org> <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hi Jeremy,
>
>
> On Mon, 23 Jul 2007, Jeremy Fitzhardinge wrote:
>
>   
>> Satyam Sharma wrote:
>>     
>>> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>>>
>>> [7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
>>>
>>> Another oddity I noticed in this file. The semantics of __volatile__
>>> when used to qualify inline __asm__ are that the compiler will not
>>> (1) elid, or, (2) reorder, or, (3) intersperse, our inline asm with
>>> the rest of the generated code.
>>>   
>>>       
>> "asm volatile" does not mean that at all.  It only guarantees (1),
>>     
>
>
> Actually, you're probably right about (2), but (3)?
>
> From the gcc manual:
>
> <quote>
>
> Similarly, you can't expect a sequence of volatile asm instructions to
> remain perfectly consecutive. If you want consecutive output, use a
> single asm. Also GCC will perform some optimizations across a volatile
> asm instruction, GCC does not "forget everything" when it encounters a
> volatile asm instruction the way some other compilers do.
>
> </quote>
>
> I'm reading "Similarly, you can't expect a sequence of volatile asm
> instructions to remain perfectly consecutive" to mean they're talking
> about something like:
>
> asm volatile(...);
> asm volatile(...);
> asm volatile(...);
>
> But "If you want consecutive output, use a single asm" probably means:
>
> asm volatile(... multiple instructions here ...);
>
> would actually ensure the code written in there would not be
> interspersed ... at least that's how I read it.
>   

I'm not quite sure what your point is.  The paragraph you quoted is
pretty explicit in saying that volatile doesn't prevent an "asm
volatile" from being interspersed with other code, and the example just
before that is explicit in talking about how to use dependencies to
control the ordering of asm volatiles with respect to surrounding code. 
In fact nothing in that section precludes asm volatiles from being
reordered with respect to each other either; you just have to make sure
your dependency constraints are all correct.

    J
