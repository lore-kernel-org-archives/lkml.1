Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbXEUNoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbXEUNoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEUNoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:44:05 -0400
Received: from mx12.go2.pl ([193.17.41.142]:36260 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755548AbXEUNoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:44:04 -0400
Date: Mon, 21 May 2007 15:50:48 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Robert P\. J\. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Documentation/memory-barriers.txt: various fixes
Message-ID: <20070521135048.GB4050@ff.dom.local>
References: <20070521094224.GB1695@ff.dom.local> <7846.1179749390@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7846.1179749390@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 01:09:50PM +0100, David Howells wrote:
> Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > I think at least some of these fixes are justified.
> 
> Yeah.  I think you're right in most cases, but not all.  See below.
> 
> David
> ---
> 
> > @@ -265,8 +265,8 @@
> > ...
> >  Such enforcement is important because the CPUs and other devices in a system
> > -can use a variety of tricks to improve performance - including reordering,
> > -deferral and combination of memory operations; speculative loads; speculative
> > +can use a variety of tricks to improve performance - including: reordering,
> > +deferral and combination of memory operations, speculative loads, speculative
> 
> I disagree.  The colon looks wrong here.  If you say it out load, there's no
> break in the flow between "including" and "reordering".  I also think that
> semicolons are correct as there needs to be a bigger pause between "loads" and
> "speculative" than between "reordering" and "deferral".

OK! I didn't even expect you should consult this with me. I'm simply
not used to see such enumerating with ";", unless in separate lines.
This could be only my problem of course...

> 
> > @@ -300,7 +300,7 @@
> > ...
> > -     load will be directed), a data dependency barrier would be required to
> > +     load will be directed), the data dependency barrier would be required to
> 
> I think that should be "a".

I could only guess (it's a magic to me) - so, if it doesn't matter
"A data ..." begins this paragraph...

> 
> > @@ -457,8 +457,8 @@
> > ...
> > -But! CPU 2's perception of P may be updated _before_ its perception of B, thus
> > +But (!) CPU 2's perception of P may be updated _before_ its perception of B,
> 
> That's a matter of taste, I think.  However, if my solution is chosen, there
> should be an extra space after "But!".  Hmmm... actually, I think you're wrong
> because the "But!" isn't quite part of the following sentence.

It seems logical, but it's also quite unusual, so the reader (only me?) 
could be more interested in orthography than in the subject...

> 
> > @@ -602,21 +602,21 @@
> >  
> >  This sequence of events is committed to the memory coherence system in an order
> >  that the rest of the system might perceive as the unordered set of { STORE A,
> > -STORE B, STORE C } all occurring before the unordered set of { STORE D, STORE E
> > -}:
> > +STORE B, STORE C } - all occurring before the unordered set of { STORE D, STORE
> > +E }:
> 
> Hmmm.  I don't think that a dash is correct here.  I think it changes the
> meaning, by changing the way the elements are grouped.

Sure. But on the other hand such long questions probably are broken
somewhere with pauses when reading...

> 
> >  	|       |   wwwwwwwwwwwwwwww }   <--- At this point the write barrier
> >  	|       |       +------+     }        requires all stores prior to the
> > -	|       |  :    | E=5  |     }        barrier to be committed before
> > -	|       |  :    +------+     }        further stores may be take place.
> > +	|       |  :    | E=5  |     }        barrier to be committed, before
> > +	|       |  :    +------+     }        further stores may take place
> 
> That's partly wrong.  The operative term is "committed before".
> 
> However "may be take" -> "may take" is correct.
> 
> > @@ -644,7 +644,7 @@
> >  
> >  	+-------+       :      :                :       :
> >  	|       |       +------+                +-------+  | Sequence of update
> > -	|       |------>| B=2  |-----       --->| Y->8  |  | of perception on
> > +	|       |------>| B=2  |-----       --->| Y->8  |  | perception on
> 
> I think this changes the meaning to one I don't want.  But I'm not entirely
> sure.  In a way the two concepts "update of perception" and "update perception"
> are different things.  I think this can be argued either way.

So, what can I say...

> 
> > @@ -1143,14 +1143,14 @@
> > ...
> > -Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
> > -equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
> > +Therefore, from (1), (2) and (4) the UNLOCK followed by the unconditional LOCK
> > +is equivalent to a full barrier, but the LOCK followed by the UNLOCK is not.
> 
> I think this should be "a" not "the".  I'm not talking about any locks in
> particular.

OK. But it's strange - usually I see too much "the".

> 
> > -A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
> > +The LOCK followed by the UNLOCK may not be assumed to be full memory barrier
> 
> Again "a" not "the".
> 
> > @@ -1239,7 +1239,7 @@
> > ...
> > -Then there is no guarantee as to what order CPU #3 will see the accesses to *A
> > +Then there is no guarantee, as to what order CPU 3 will see the accesses to *A
> 
> There shouldn't be a comma there.

I cannot even remember when I've inserted it. I thought only about "#' here.

> 
> > @@ -1375,7 +1375,7 @@
> > ...
> > -operate without the use of a lock if at all possible.  In such a case
> > +operate without the use of the lock if at all possible.  In such a case
> 
> That should definitely be "a" not "the".  There is no specific lock mentioned
> to be definite about.
> 
> > @@ -1396,10 +1396,10 @@
> > ...
> > - (1) read the next pointer from this waiter's record to know as to where the
> > -     next waiter record is;
> > + (1) read the list.next pointer from this waiter's record to know as to where
> > +     the next waiter record is;
> 
> That's unimportant, and also assumes that "list.next" exists and will exist in
> all implementations.

I thought the "next" isn't synonymous enough, but OK.

> 
> > @@ -1423,7 +1423,7 @@
> > ...
> > -stack before the up*() function has a chance to read the next pointer.
> > +stack before the up_*() function has a chance to read the next pointer.
> 
> That's unimportant as we're clearly talking about rwsems.  However, to be
> consistent, this should probably be up_xxx().
> 
> > @@ -1659,16 +1660,16 @@
> > ...
> >       Whether these are guaranteed to be fully ordered and uncombined with
> > -     respect to each other on the issuing CPU depends on the characteristics
> > +     respect to each other on the issuing CPU - depends on the characteristics
> 
> That dash is definitely wrong.  The sentence is of the form "Whether X is/are Y
> depends on Z".
> 
> >       However, intermediary hardware (such as a PCI bridge) may indulge in
> > -     deferral if it so wishes; to flush a store, a load from the same location
> > +     deferral if it wishes so; to flush a store, a load from the same location
> 
> I disagree on that one.  I would say the former, but not the latter.
> 
> 
> Anyway, thanks for the review!  Any change in your patch I haven't mentioned is
> one I'm okay with.

I'll try to resend this yesterday with only agreed changes.

Thanks for the review of the review & regards,
Jarek P.
