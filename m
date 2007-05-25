Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbXEYWQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbXEYWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXEYWQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:16:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:25966 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbXEYWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fBHC29yym8PhVhsZiYtq/OJmXFgmQA+A2dk26xQ7GIGO2SyONUjzKKs3Xn5+ncYm2rAFWdx8UbDRV6e4aSTTlZrE1yTHrrnv+XTVHqP7eQUrEAf8vV/2NeOaj6OEXy/UVb0FCr01SWgjjJN5THb4WhEFcCTvds4h7AOdCVyPXZQ=
Message-ID: <a781481a0705251516l5de0e95ayae45f7a65e25c8cf@mail.gmail.com>
Date: Sat, 26 May 2007 03:46:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn" standard.
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ralf Baechle" <ralf@linux-mips.org>
In-Reply-To: <4657589F.7050509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
	 <46572DAF.1000108@zytor.com>
	 <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
	 <46573B23.1090700@zytor.com>
	 <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>
	 <4657589F.7050509@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 5/26/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Robert P. J. Day wrote:
> >> ... and declare functions as:
> >>
> >> __noreturn f();
> >>
> >> ... which is the syntactially sane way of doing it.
> >
> > that may be, but keep in mind that gcc allows attributes to *follow*
> > the parameter list as well, and some people might prefer to do the
> > following:
> >
> >   f() __noreturn;
> >
> > that would fail badly if you defined __noreturn as you suggest.
>
> That's equally moronic that saying that "some people might prefer to
> write 'f() void;'", which is what it's *EXACTLY* equivalent to.  Yes,
> they might "prefer" it, but it's syntactically invalid and the compiler
> won't accept it.  As it shouldn't.
>
> __noreturn here takes the syntactic place of the return type, because
> that's what it IS.

But __attribute__((noreturn)) is simply a _function attribute_. Of course,
it is legal / valid only for functions with return-type void, so it does make
sense to combine both void and __attribute__((noreturn)) in the same
macro like you say. But that's not syntactically necessary. In fact,
grepping through the sources, a lot of people do prefer to place the
attribute _after_ the function declarator.

Anyway, I'm fine either way.

Thanks,
Satyam
