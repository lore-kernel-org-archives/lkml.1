Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbXBJB40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbXBJB40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXBJB40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:56:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:2047 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbXBJB4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:56:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cQgVU35mzZoGTRkkO96Ob8/9X1DidxN8U+P/eg71kfCCkpfnk0ngozABXrWVKDbOTzoSPlR2RUu0+J2Bybtd3WChE8WI3i6j8Ls08x2IWylSc4TR/JiNEKRnEQkBKdLdMewrIdwmT+AwtmGLF9UQUgNIse1VYoTRsJuyykTx450=
Message-ID: <2375c9f90702091756l4cddfc63r68b5a318457f13d8@mail.gmail.com>
Date: Sat, 10 Feb 2007 09:56:24 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kfifo: overflow of unsigned integer
In-Reply-To: <20070209003732.03012671.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2375c9f90702080107v7088f835h7cdf5373d36d3c14@mail.gmail.com>
	 <20070208013845.542ad7b0.akpm@linux-foundation.org>
	 <2375c9f90702080416s54664351q3df54e80459c63af@mail.gmail.com>
	 <20070209003732.03012671.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/9, Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 8 Feb 2007 20:16:55 +0800 "Cong WANG" <xiyou.wangcong@gmail.com> wrote:
>
> > 2007/2/8, Andrew Morton <akpm@linux-foundation.org>:
> > > On Thu, 8 Feb 2007 17:07:28 +0800 "Cong WANG" <xiyou.wangcong@gmail.com> wrote:
> > >
> > > > Kfifo is a ring-buffer in kernel which can be used as a lock-free way
> > > > for concurrent read/write when there are only one producer and one
> > > > consumer. Details of its design can be found in kernel/kfifo.c and
> > > > include/linux/kfifo.h.
> > > >
> > > > You will find that the 'in' and 'out' fields of 'struct kfifo' are
> > > > both represented as 'unsigned int' and in most cases 'in' is larger
> > > > than 'out' and their difference will NOT be  over 'size'.
> > > >
> > > > Now the problem is that 'in' will be *smaller* than 'out' when 'in'
> > > > overflows and 'out' doesn't (Yes, this may occur quietly.). This is
> > > > NOT what we expect, though it may not cause any serious problems if we
> > > > carefully use kfifo*() functions. And this is really a bug.
> > >
> > > You seem to be saying that it's not a bug, but it's a bug.
> > >
> > > Exactly what goes wrong?
> >
> > I wrote a module on my machine to test this bug. And when the overflow
> > occurs, I cann't put any data into the fifo even though it is not
> > full.
>
> Why did you remove the mailing list?  Please don't do that.

Sorry. I used the poor 'reply'.

>
> I can't find any bug.
>
> I converted the code so that it'll run in userspace:
>
> http://userweb.kernel.org/~akpm/kfifo.c
> http://userweb.kernel.org/~akpm/kfifo.h
>
> Please see if you can reproduce the problem with that setup and then let's
> see if we can understand what's going on, and fix it.
>
>

Thanks for your work. And you are right.

I think the OLD /proc API which I used in my module confused my eyes.
I got completely lost by that. OLD /proc API is very bad, isn't it?

BTW, can you tell me which way do you use to exchange information
between user-space and kernel-space when debugging the kernel?

Thanks again! And have a nice day!
