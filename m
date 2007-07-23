Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbXGWIvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbXGWIvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXGWIu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:50:58 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:65436 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXGWIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eFFEDHJA8VDKftmjjOkTMovIMGLpcyl0LFDpp9eNUR0tKOnRL4aT/MJe96R5bU9pcnJNbZHVgAvNcMQUSIFcmU1RT6FTTU2C8ggJq0+LPwjMWq1KS+Xs9wBhEY9bLC0VJR0RUI/ePXgcU4v37cGvgRpVj/plYCmKbjfyia0OALo=
Message-ID: <a781481a0707230150u21ba14bfme7bbff92d4705d20@mail.gmail.com>
Date: Mon, 23 Jul 2007 14:20:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] AFS: Fix file locking
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46A4539D.9060100@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
	 <20070717175017.8b8a8976.akpm@linux-foundation.org>
	 <469DABA5.9070706@yahoo.com.au>
	 <20070719204102.7b82692d.akpm@linux-foundation.org>
	 <46A04129.1020900@yahoo.com.au>
	 <alpine.LFD.0.999.0707201835070.27249@woody.linux-foundation.org>
	 <46A4539D.9060100@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/23/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Linus Torvalds wrote:
> >
> > On Fri, 20 Jul 2007, Nick Piggin wrote:
> >
> >>So you did. Then to answer that, yes it could be faster because there are
> >>stupid volatiles sprinkled all over the bitops code so you could easily
> >>end up having to do more loads. Does it make a real difference? Unlikely,
> >>but David loves counting cycles :)
> >
> >
> > I thought we long long since removed the volatiles. They are buggy and
> > horrible, and we really want to let the compiler combine multiple
> > test-bits, and if they matter that implies locking is buggy or something
> > worse..
> >
> > Ie we'd *want*
> >
> >       if (test_bit(x, y) || test_bit(z,y))
> >
> > to be rewritten by the compiler as testing bits x/z at the same time.
>
> Yep. We'd also want __set_bit(x, y); __set_bit(z, y); and such to be
> combined.
> >
> > But now I'm too scared to look.
>
> Not a chance :) Even the asm-generic "reference" implementation ratifies
> the volatile crapiness. Would you take a patch?

Coincidentally, I'm working on a cleanup of the bitops code just now --
I stumbled upon a lot of varied bogosity in there :-) Intend to send it
out in a couple of hours, probably.

Satyam
