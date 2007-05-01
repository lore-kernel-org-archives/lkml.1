Return-Path: <linux-kernel-owner+w=401wt.eu-S1031698AbXEANLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031698AbXEANLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031700AbXEANLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:11:23 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:14779 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031698AbXEANLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EgE8h2sVpXW2dyxBI13r2j//vflm9ydzwRBfc1jjOIqVj3mpQt2bPjdin0N00/cOi6UF9/rst/Mvr4drCmHjsQkycc8epIfWaUoKhyAKLh+ky6c6bYjLwAFnK3NW83y3O4w3woRuA0KxO3PmhDnsFt5uldxqP6CnA78WuSglfo0=
Message-ID: <7b69d1470705010611y8f635a9pdc2f1dd6ec03700b@mail.gmail.com>
Date: Tue, 1 May 2007 08:11:20 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: condingstyle, was Re: utrace comments
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Roland McGrath" <roland@redhat.com>, "Christoph Hellwig" <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705011058330.27246@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061127165138.GA2991@lst.de>
	 <20070430040213.BF9901801A4@magilla.sf.frob.com>
	 <20070430091121.GC31397@infradead.org>
	 <20070430100917.439ebfc8.akpm@linux-foundation.org>
	 <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
	 <Pine.LNX.4.64.0705011058330.27246@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, 1 May 2007, Satyam Sharma wrote:
> > Actually, the latter style (one condition per line and the && or ||
> > operators appearing _before_ the conditions in subsequent lines)
> > is quite popular for multi-line compound conditions (well, I've seen this
> > in kernel/workqueue.c, kernel/stop_machine.c, etc at least, and also in
> > Linus' code, if I'm not mistaken). We also align subsequent lines to the
> > column of the condition belonging to the same "logical level" on the
> > previous line using _spaces_ (note that this is alignment, not indentation,
> > using spaces). The rationale is to make the operator prominent and thus make
> > the structure of a complex multi-line compound conditional expression more
> > readable and obvious at first glance itself. For example, consider:
> >
> >       if (veryverylengthycondition1 &&
> >               smallcond2 &&
> >               (conditionnumber3a ||
> >               condition3b)) {
> >               ...
> >       }
> >
> > versus
> >
> >       if (veryverylengthycondition1
> >           && smallcond2
> >           && (conditionnumber3a
> >               || condition3b)) {
> >               ...
> >       }
> >
> > ?
> >
> > Latter wins, doesn't it?
>
> ... because you forgot to align subsequent lines to the column of the
> condition belonging to the same "logical level" on the previous line.
>
> Consider this:
>
>         if (veryverylengthycondition1 &&
>             smallcond2 &&
>             (conditionnumber3a ||
>              condition3b)) {
>                 ...
>         }
>
> Gr{oetje,eeting}s,
>
>                                                 Geert


I still find the leading-operator style much more readable. The most
important thing in reading a long, complex conditional is
understanding the structure of the operators, not the operands.
Putting the operators at the front of the line emphasizes that
structure, especially since you can line the operators up to match the
logical indenting, whereas the trailing-operator style leaves the
operators scattered and hard to assemble into a logical structure.

However, there's a lot of difference of opinion on this (perhaps
rooted in differences in cognition and reading behavior). For me it's
not even close - expressions broken so the operators are at the head
of the line snap into focus and those with operators at the ends of
the lines look like undifferentiated goo. Since some of the style
guides I've seen do it the other way, I assume some people have the
opposite perception. I guess that's why indent offers options for
doing it either way...

scott
