Return-Path: <linux-kernel-owner+w=401wt.eu-S933477AbZJFVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477AbZJFVnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933444AbZJFVnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:43:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:35362 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338AbZJFVnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:43:11 -0400
Subject: Re: Linux 2.6.32-rc3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 08:33:23 +1100
Message-Id: <1254864803.6035.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It doesn't help, for several reasons:
> 
>  - the step function of the Makefile change happens once per release, and 
>    if you compile anything but releases, you can never rely on just the 
>    revision. Was it a plain -rc, a plain release, or something in 
>    between? You'll never know, just looking at the 2.6.x.y thing.
> 
>    In other words, you fundamentally have three choices:
> 
>     (a) be confused. Adding an "-rc0" won't help. You'll still be confused 
> 	in between releases about exactly what you're running.

Well, thing is, it's not us who are confused in general, it's users who
do reports with confusing versions. Yes, I agree that anything but a
release warrants a proper commit ID, but that's exactly what I asked for
when I wanted -rc0 here :-)

IE. That the -only- kernel that is called "2.6.x" is the release,
everything else has some kind of -rc in front of it, which allows me to
bug the user for a commit ID and know right away that this isn't a
release kernel.

>     (b) use CONFIG_LOCALVERSION_AUTO=y
> 
> 	Now, if 'uname -r' says 2.6.31, then you _know_ it's exactly 
> 	2.6.31 and nothing else. If it's a few commits after 2.6.31, it 
> 	will say something like '2.6.31-1-g752015d', and you know that 
> 	it's one commit after 2.6.31, and you'll know _which_ commit it is!
> 
>     (c) Don't compile anything but releases. 
> 
>    Those are the choices. 

Sure, when doing the stuff ourselves. Again, the problem is user
reports. Being able to distinguish between a 2.6.x "release" kernel and
anything else would be of value, at least to me. For anything else, I
can say "heh, you've been compiling non-release stuff, you should be
able to get me a git commit ID.

Difference boils down to users falling into two categories: Those who
compile non-release stuff, and should be able to figure out what the ID
is or recompile with LOCAL_VERSION set propertly etc... and those who
don't, didn't always compile the kernel themselves, and fortunately in
-most- cases are only running a "release".
 
>  - An even _more_ fundamental reason: Linux development isn't linear. 
>    There is not one "first commit" after a release, and there never will 
>    be. Sure, there's a first commit that I do, but that has absolutely 
>    zero relevance.

it would be easy enough for you to push a change to the Makefile just
after you tag a release and before you merge anything else.

>    Learn this. Until you do, you'll be confused, and you'll show your 
>    confusion by saying "I want a 2.6.n+1-rc0". You'll _also_ show your 
>    confusion by things like "I was bisecting a bug that happened between 
>    2.6.30 and 2.6.31, and suddenly git was asking me to test a kernel that 
>    said it was version 2.6.29-rc1 - so I stopped bisecting because git was 
>    confused".
> 
> Who was confused? Was it git, or was it the person who thought that the 
> Makefile version could be consistent in a non-linear world?
> 
> So no. I'm not going to do -rc0. Because doing that is _stupid_. And until 
> you understand _why_ it's stupid, it's pointless talking about it, and 
> when you _do_ understand that it's stupid, you'll agree with me.

I disagree. I understand the linearity problem. My point isn't about
having the Makefile provide with any kind of precise "pointer" into that
tree for non-release, but really only to differenciate a release from
anything else.

I know for somebody who uses git everyday, the concept of release even
becomes a bit fuzzy, but there's a lot of folks out there who really
don't see anything else :-) 

Cheers,
Ben.
 
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


