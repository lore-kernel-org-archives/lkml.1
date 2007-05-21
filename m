Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbXEUMKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbXEUMKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbXEUMJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:09:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbXEUMJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:09:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070521094224.GB1695@ff.dom.local>
References: <20070521094224.GB1695@ff.dom.local>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/memory-barriers.txt: various fixes
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Mon, 21 May 2007 13:09:50 +0100
Message-ID: <7846.1179749390@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski <jarkao2@o2.pl> wrote:

> I think at least some of these fixes are justified.

Yeah.  I think you're right in most cases, but not all.  See below.

David
---

> @@ -265,8 +265,8 @@
> ...
>  Such enforcement is important because the CPUs and other devices in a system
> -can use a variety of tricks to improve performance - including reordering,
> -deferral and combination of memory operations; speculative loads; speculative
> +can use a variety of tricks to improve performance - including: reordering,
> +deferral and combination of memory operations, speculative loads, speculative

I disagree.  The colon looks wrong here.  If you say it out load, there's no
break in the flow between "including" and "reordering".  I also think that
semicolons are correct as there needs to be a bigger pause between "loads" and
"speculative" than between "reordering" and "deferral".

> @@ -300,7 +300,7 @@
> ...
> -     load will be directed), a data dependency barrier would be required to
> +     load will be directed), the data dependency barrier would be required to

I think that should be "a".

> @@ -457,8 +457,8 @@
> ...
> -But! CPU 2's perception of P may be updated _before_ its perception of B, thus
> +But (!) CPU 2's perception of P may be updated _before_ its perception of B,

That's a matter of taste, I think.  However, if my solution is chosen, there
should be an extra space after "But!".  Hmmm... actually, I think you're wrong
because the "But!" isn't quite part of the following sentence.

> @@ -602,21 +602,21 @@
>  
>  This sequence of events is committed to the memory coherence system in an order
>  that the rest of the system might perceive as the unordered set of { STORE A,
> -STORE B, STORE C } all occurring before the unordered set of { STORE D, STORE E
> -}:
> +STORE B, STORE C } - all occurring before the unordered set of { STORE D, STORE
> +E }:

Hmmm.  I don't think that a dash is correct here.  I think it changes the
meaning, by changing the way the elements are grouped.

>  	|       |   wwwwwwwwwwwwwwww }   <--- At this point the write barrier
>  	|       |       +------+     }        requires all stores prior to the
> -	|       |  :    | E=5  |     }        barrier to be committed before
> -	|       |  :    +------+     }        further stores may be take place.
> +	|       |  :    | E=5  |     }        barrier to be committed, before
> +	|       |  :    +------+     }        further stores may take place

That's partly wrong.  The operative term is "committed before".

However "may be take" -> "may take" is correct.

> @@ -644,7 +644,7 @@
>  
>  	+-------+       :      :                :       :
>  	|       |       +------+                +-------+  | Sequence of update
> -	|       |------>| B=2  |-----       --->| Y->8  |  | of perception on
> +	|       |------>| B=2  |-----       --->| Y->8  |  | perception on

I think this changes the meaning to one I don't want.  But I'm not entirely
sure.  In a way the two concepts "update of perception" and "update perception"
are different things.  I think this can be argued either way.

> @@ -1143,14 +1143,14 @@
> ...
> -Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
> -equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
> +Therefore, from (1), (2) and (4) the UNLOCK followed by the unconditional LOCK
> +is equivalent to a full barrier, but the LOCK followed by the UNLOCK is not.

I think this should be "a" not "the".  I'm not talking about any locks in
particular.

> -A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
> +The LOCK followed by the UNLOCK may not be assumed to be full memory barrier

Again "a" not "the".

> @@ -1239,7 +1239,7 @@
> ...
> -Then there is no guarantee as to what order CPU #3 will see the accesses to *A
> +Then there is no guarantee, as to what order CPU 3 will see the accesses to *A

There shouldn't be a comma there.

> @@ -1375,7 +1375,7 @@
> ...
> -operate without the use of a lock if at all possible.  In such a case
> +operate without the use of the lock if at all possible.  In such a case

That should definitely be "a" not "the".  There is no specific lock mentioned
to be definite about.

> @@ -1396,10 +1396,10 @@
> ...
> - (1) read the next pointer from this waiter's record to know as to where the
> -     next waiter record is;
> + (1) read the list.next pointer from this waiter's record to know as to where
> +     the next waiter record is;

That's unimportant, and also assumes that "list.next" exists and will exist in
all implementations.

> @@ -1423,7 +1423,7 @@
> ...
> -stack before the up*() function has a chance to read the next pointer.
> +stack before the up_*() function has a chance to read the next pointer.

That's unimportant as we're clearly talking about rwsems.  However, to be
consistent, this should probably be up_xxx().

> @@ -1659,16 +1660,16 @@
> ...
>       Whether these are guaranteed to be fully ordered and uncombined with
> -     respect to each other on the issuing CPU depends on the characteristics
> +     respect to each other on the issuing CPU - depends on the characteristics

That dash is definitely wrong.  The sentence is of the form "Whether X is/are Y
depends on Z".

>       However, intermediary hardware (such as a PCI bridge) may indulge in
> -     deferral if it so wishes; to flush a store, a load from the same location
> +     deferral if it wishes so; to flush a store, a load from the same location

I disagree on that one.  I would say the former, but not the latter.


Anyway, thanks for the review!  Any change in your patch I haven't mentioned is
one I'm okay with.

David
