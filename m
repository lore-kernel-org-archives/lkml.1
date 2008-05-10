Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbYEJNXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbYEJNXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 09:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYEJNWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 09:22:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:64031 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbYEJNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 09:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TZGUPM3EeEwS2FYovYyyqy68RYKZF9wU3jq8TE4Q7KveaAx4ChvxnzCadglY+CJhx21haxULQsU8aUq3S85nxey07g6M9tI4urUErZVvXBMH2UUXlfNvEKi4u5kjgtXGg8rdm8wQNbE6acssS1C89aHUNwb8LfYbXA9iJCVdL5M=
Message-ID: <e2e108260805100622n52e4e555p73ffadc5b882b6df@mail.gmail.com>
Date: Sat, 10 May 2008 15:22:51 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [ANNOUNCE] kmemcheck v7
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "John Reiser" <jreiser@bitwagon.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Josh Aune" <luken@omner.org>,
       "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <20080510123744.GB19109@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F630AE.7050801@gmail.com>
	 <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>
	 <482565A5.8010503@cs.helsinki.fi>
	 <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com>
	 <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
	 <20080510123744.GB19109@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 2:37 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>  - kmemcheck can only warn for dynamic memory, whereas kmemcheck I
>> believe will also work for local variables, static variables, etc.
>
> I don't think that's true. valgrind can only detect uninitialized
> local variables in one special case (first use of the stack region).
> But as soon as you reuse stack which is pretty common it won't
> be able to detect the next uninitialized use in a stack frame.

As long as the compiler is not told to optimize the compiled code,
Valgrind's memcheck tool is able to detect uninitialized local
variables. Valgrind a.o. tracks all updates of the stack pointer. If
the stack pointer is increased, the memory range between the old and
the new stack pointer is marked as undefined. This works as long as
gcc doesn't optimize away individual stack pointer updates. (I'm one
of the Valgrind developers.)

Bart.
