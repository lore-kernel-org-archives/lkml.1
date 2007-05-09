Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbXEIWbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbXEIWbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbXEIWbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:31:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:3534 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXEIWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BSGIPrOqxAAivezslIpek1tjDYNpdzwxvyQfvjNKBNPDR9HadEHoILyIwWn6O+dgrpSaftNfT3uq5c34nJAUwjrzQVtp5tp2GbAOv2GZxXck4JM74VKLHXGPkpRA7nOplhSqH99Xw9yELsn9K/IP8h44FM+5h5SsemeDz60xIxU=
Message-ID: <a781481a0705091531x6d4174abmf181371e43bfaffe@mail.gmail.com>
Date: Thu, 10 May 2007 04:01:12 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful" document
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <9a8748490705091445y65ec74bcpbb9251d9184f481a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25493.1178744744@lwn.net>
	 <9a8748490705091445y65ec74bcpbb9251d9184f481a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 09/05/07, Jonathan Corbet <corbet@lwn.net> wrote:
> > OK, here's an updated version of the volatile document - as a plain text
> > file this time.  It drops a new file in Documentation/, but might it be
> > better as an addition to CodingStyle?
> >
> IMHO this is better as a sepperate document rather than an adition to
> CodingStyle. The use of volatile is not a style issue, it's a
> correctness issue, so it doesn't belong in the CodingStyle document.

Yes, definitely.

> > diff -ruNp linux-2.6/Documentation/volatile.txt volatile/Documentation/volatile.txt
>
> Might I suggest a different filename: volatile-considered-harmful.txt

Yes, I feel it's important to have a filename that strongly states the
dim view its contents take on its subject (the "volatile" type
qualifier in this case). Sort of like stable-api-nonsense.txt vs
stable-api.txt

> > --- linux-2.6/Documentation/volatile.txt        1969-12-31 17:00:00.000000000 -0700
> > +++ volatile/Documentation/volatile.txt 2007-05-09 14:56:40.000000000 -0600
> > @@ -0,0 +1,127 @@
> > +Why the "volatile" type class should not be used
> > +------------------------------------------------
> > +
> > +The C Programming Language, Second Edition (copyright 1988, still known as
> > +"the new C book") has the following to say about the volatile keyword:
> > +
> > +       The purpose of volatile is to force an implementation to suppress
> > +       optimization that could otherwise occur.  For example, for a
> > +       machine with memory-mapped input/output, a pointer to a device
> > +       register might be declared as a pointer to volatile, in
> > +       order to prevent the compiler from removing apparently redundant
> > +       references through the pointer.
> > +
> > +C programmers have often taken volatile to mean that the variable could be
> > +changed outside of the current thread of execution; as a result, they are
>
> you write: "... that the variable could be changed outside of the
> current thread of execution ..."
>
> I suggest: "... that the variable could be changed outside of the
> current thread of execution - a sort of simple atomic variable ..."

I'm not so sure here. Why would any C programmer (worth his weight in
salt) think that volatile objects are automatically _atomic_? At
worst, the mistake someone might make would be to _implement_ locking
primitives using volatile. "that the variable could be changed outside
of the current thread of execution" sounds sufficient to me, and after
all, that is exactly what volatile hints to the compiler.

> > +For most code, none of the above justifications for volatile
> > +apply.  As a result, the use of volatile is likely to be seen as a
> > +bug and will bring additional scrutiny to the code.  Developers who are
> > +tempted to use volatile should take a step back and think about
> > +what they are truly trying to accomplish.
> > +
>
> Suggested addition :
>
> Patches that remove volatile from current code (provided there's a
> good explanation of why the volatile can be removed and how the bug it
> was hiding has been dealt with) are a good thing.
>
> Friends don't let friends use volatile.

Yes, this addition would be nice :-)
