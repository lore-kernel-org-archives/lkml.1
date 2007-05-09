Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbXEIWsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbXEIWsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758582AbXEIWrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:47:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:25190 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbXEIWr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cQZn2j0d5m1aMgnqQRM36BdqcoixgVrd6Nwhtr0k8qao/XhDo4oKZ/mgqHRnk34tGN68viuQxqCy/LpdBq0/SYHyUYyaUwdomSwCTWF/b9Z6iFlCC5cvro8nLIRwE7h8o/6C9DsbVsrWBHZsAuTvUO4cnJjzQErVCvgc379Ru8o=
Message-ID: <9a8748490705091547s7a9c6358qabd6b83251f1a449@mail.gmail.com>
Date: Thu, 10 May 2007 00:47:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful" document
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <a781481a0705091531x6d4174abmf181371e43bfaffe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25493.1178744744@lwn.net>
	 <9a8748490705091445y65ec74bcpbb9251d9184f481a@mail.gmail.com>
	 <a781481a0705091531x6d4174abmf181371e43bfaffe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 5/10/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > On 09/05/07, Jonathan Corbet <corbet@lwn.net> wrote:
<snip>
> > > +"the new C book") has the following to say about the volatile keyword:
> > > +
> > > +       The purpose of volatile is to force an implementation to suppress
> > > +       optimization that could otherwise occur.  For example, for a
> > > +       machine with memory-mapped input/output, a pointer to a device
> > > +       register might be declared as a pointer to volatile, in
> > > +       order to prevent the compiler from removing apparently redundant
> > > +       references through the pointer.
> > > +
> > > +C programmers have often taken volatile to mean that the variable could be
> > > +changed outside of the current thread of execution; as a result, they are
> >
> > you write: "... that the variable could be changed outside of the
> > current thread of execution ..."
> >
> > I suggest: "... that the variable could be changed outside of the
> > current thread of execution - a sort of simple atomic variable ..."
>
> I'm not so sure here. Why would any C programmer (worth his weight in
> salt) think that volatile objects are automatically _atomic_? At

I honestly don't really know, but I've encountered that confusion a
few times. Both from friends who (for some reason) believed that and
from documents on the web that implied it, aparently it's a common
confusion - a few examples:

    http://lists.freebsd.org/pipermail/freebsd-perl/2004-June/000124.html
        "... volatile (atomic) fixes the problem. ..."

    http://blogs.msdn.com/ricom/archive/2006/04/28/586406.aspx
        "That's the point of the volatile keyword. It makes sure that
the line "dict = d;" is atomic."

    http://forum.java.sun.com/thread.jspa?threadID=5126877&start=0
        "A volatile variable is also guaranteed to be read or written
as an atomic operation ..."  (yes, this link talks about Java, which I
don't know, but if java volatile means atomic, that might explain why
some people assume the same for C).

In any case, it's not an uncommon belief, so I just thought it made
sense to also make that little note.


> worst, the mistake someone might make would be to _implement_ locking
> primitives using volatile. "that the variable could be changed outside
> of the current thread of execution" sounds sufficient to me, and after
> all, that is exactly what volatile hints to the compiler.
>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
