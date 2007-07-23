Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXGWQlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXGWQlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762701AbXGWQlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:41:44 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:59325 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761519AbXGWQln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:41:43 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 22:13:01 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__
 __volatile__
In-Reply-To: <46A4D612.9050209@goop.org>
Message-ID: <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A4D612.9050209@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,


On Mon, 23 Jul 2007, Jeremy Fitzhardinge wrote:

> Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> >
> > [7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
> >
> > Another oddity I noticed in this file. The semantics of __volatile__
> > when used to qualify inline __asm__ are that the compiler will not
> > (1) elid, or, (2) reorder, or, (3) intersperse, our inline asm with
> > the rest of the generated code.
> >   
> 
> "asm volatile" does not mean that at all.  It only guarantees (1),


Actually, you're probably right about (2), but (3)?

>From the gcc manual:

<quote>

Similarly, you can't expect a sequence of volatile asm instructions to
remain perfectly consecutive. If you want consecutive output, use a
single asm. Also GCC will perform some optimizations across a volatile
asm instruction, GCC does not "forget everything" when it encounters a
volatile asm instruction the way some other compilers do.

</quote>

I'm reading "Similarly, you can't expect a sequence of volatile asm
instructions to remain perfectly consecutive" to mean they're talking
about something like:

asm volatile(...);
asm volatile(...);
asm volatile(...);

But "If you want consecutive output, use a single asm" probably means:

asm volatile(... multiple instructions here ...);

would actually ensure the code written in there would not be
interspersed ... at least that's how I read it.

[ BTW "Also GCC will perform some optimizations across a volatile
asm instruction ..." is exactly the kind of optimizations we must
allow the compiler to do, but that's not related to point at hand. ]


> and
> only then if the asm is ever reachable.

Yup, of course.

Satyam
