Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXE3RAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXE3RAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbXE3RAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:00:23 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:55338 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbXE3RAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fIWiTM6WVSAHUqBptxb/X447643Ua95wYGX0KHouhYLMqjWQoJ6uwqb5d5yjNHn8PKhL9EEQ02gDyol5IFkWwSyLo2vwCf9YEbduVeUZGv23BMyfMKNYoACyS/kCF+aDauw+qgoJaeXx+8kUlhowhvj+tZ6MM08SfsMvB+vNctM=
Message-ID: <a781481a0705301000r35e2dde7x8c90ba7b0497e4ef@mail.gmail.com>
Date: Wed, 30 May 2007 22:30:14 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [ofa-general] Re: dealing with gcc 'comparison is always false' warnings
Cc: linux-kernel@vger.kernel.org, openib-general@openib.org
In-Reply-To: <adaveeaqp8q.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
	 <adazm3mqqh3.fsf@cisco.com>
	 <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
	 <adaveeaqp8q.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry, the threading broke because the subject changed,
so I missed seeing this mail earlier. ]

On 5/30/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > However, gcc is _just as correct_. It is only crying about seeing a condition
>  > that the programmer could have written with some purpose in mind but which
>  > is being completely compiled away by it when generating the code because
>  > of it being a tautology / contradiction ...
>
> Well, OK, but there's lots of things gcc could warn about.  How about
>
>         while (1) { ...

Umm ... perhaps because gcc does not compile away any code for
such cases, but only the condition? Or because gcc knows this is
a common idiom in a *lot* of C code? I don't know (or care!) ... the
precise cases for which the warning is emitted would be known only
by reading gcc sources (which I have no intention of doing :-)

> By your argument gcc should warn that '1' always evaluates to true.

Note that my "argument" was about conditions that weren't as
simplistic as #if 0 or while (1) and that involved not merely 1 or 0,
but variables whose values might not be available at compile-time ...

> Or how about
>
> #if 0
>
> why shouldn't the preprocessor warn that the conditional is always false?

Perhaps because gcc knows programmers often use this common
method to disable some code?

I can't answer all these questions, of course (better ask the gcc folks),
but I don't care either. Clearly, none of the above are any reason why
gcc should *not* complain when it sees a _seemingly_ meaningful
condition conceivably written by the programmer with something in
mind but being completely optimized away by it.

[ BTW, perhaps the reason why the gcc folks did *not* put a warning
for while (1) or #if 0 is also because they know that programmers often
write such conditions with something meaningful in mind. ]

>  > No, shutting gcc up wouldn't be the right thing, IMHO. These warnings are
>  > a good reminder to the programmer to go and see if there is a real bug
>  > somewhere and if something really needs to be done with the code (could
>  > be simply to change the type of a variable to signed that was mistakenly
>  > declared unsigned, f.e.).
>
> OK, but suppose I looked at it and there's no bug.  Leaving the
> warning has a cost too: it hides useful warnings (that might be
> showing real bugs) in all the clutter.

Agreed, this warning emits a lot of false positives. But this warning isn't
enabled with -Wall either, or is it (now)? I remember the only way to
enable this was with -Wextra, and last I heard the top-level Makefile
did not specify that ... (?)

Satyam
