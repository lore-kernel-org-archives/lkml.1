Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbXCLWvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbXCLWvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbXCLWvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:51:09 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:41733 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXCLWvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ICfQpVO1bK+tSeEcfEfIwPnLE+G+jZ1G4nfWZV8b+J+KXpWNLHNy53wpRJQd0F077VqxW0IipDbSjxlZbKcR+8Iqee+ZMluxIPYX8Gdp28w1Y2aOtQiry2QdMGpwQrZ5+njD7Y00mJgEqbwejYMdjTBZPNfEuAVIQ7GSi2gH7Bg=
Message-ID: <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
Date: Tue, 13 Mar 2007 09:51:07 +1100
From: "Con Kolivas" <kernel@kolivas.org>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1173732344.6431.54.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
	 <1173732344.6431.54.camel@Homer.simpson.net>
X-Google-Sender-Auth: b68f4ab74321be76
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/07, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2007-03-13 at 07:38 +1100, Con Kolivas wrote:
> > On Tuesday 13 March 2007 07:11, Mike Galbraith wrote:
> > >
> > > Killing the known corner case starvation scenarios is wonderful, but
> > > let's not just pretend that interactive tasks don't have any special
> > > requirements.
> >
> > Now you're really making a stretch of things. Where on earth did I say that
> > interactive tasks don't have special requirements? It's a fundamental feature
> > of this scheduler that I go to great pains to get them as low latency as
> > possible and their fair share of cpu despite having a completely fair cpu
> > distribution.
>
> As soon as your cpu is fully utilized, fairness looses or interactivity
> loses.  Pick one.

That's not true unless you refuse to prioritise your tasks
accordingly. Let's take this discussion in a different direction. You
already nice your lame processes. Why? You already have the concept
that you are prioritising things to normal or background tasks. You
say so yourself that lame is a background task. Stating the bleedingly
obvious, the unix way of prioritising things is via nice. You already
do that. So moving on from that...

Your test case you ask "how can I maximise cpu usage". Well you know
the answer already. You run two threads. I won't dispute that.

The debate seems to be centered on whether two tasks that are niced +5
or to a higher value is background. In my opinion, nice 5 is not
background, but relatively less cpu. You already are savvy enough to
be using two threads and nicing them. All I ask you to do when using
RSDL is to change your expectations slightly and your settings from
nice 5 to nice 10 or 15 or even 19. Why is that so offensive to you?
nice 5 is 75% the cpu of nice 0. nice 10 is 50%, nice 15 is 25%, nice
19 is 5%.If you're so intent on defining nice 5 as background would it
be a matter of me just modifying nice 5 to be 25% instead? I suspect
your answer will be no because then you'll argue that you shouldn't
nice at all, but it should be interesting to see your response. You
seem to be advocating that the scheduler does everything and we need
to implement some complex flag instead. I don't believe that's the
right thing to do at all. So I offer you some options.

1. Be happy with changing your nice from 5 to15. I still don't think
this is in any way unreasonable.
2. Wait for me to fix -niced tasks behaviour and -nice your X. I plan
to implement this change anyway, not necessarily for X.
3. Have me redefine what nice 5 is, and tell me what percentage cpu
you think is right.
4. Any combination of the above.

Please don't pick 5.none of the above. Please try to work with me on this.

--
-ck
