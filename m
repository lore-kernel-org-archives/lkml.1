Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbZJFOVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbZJFOVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbZJFOVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:21:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932689AbZJFOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:21:09 -0400
Date: Tue, 6 Oct 2009 07:18:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dirk Hohndel <hohndel@infradead.org>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Oct 2009, Dirk Hohndel wrote:
> On Mon, 2009-10-05 at 21:57 -0400, Len Brown wrote:
>
> > This could be clarified if you update Makefile on the 1st commit
> > after 2.6.X is frozen to simply be 2.6.Y-merge or 2.6.Y-rc0
> > or something.  Anything but 2.6.X.
> 
> I have seen this request many times and it seems to make perfect sense.

No. It makes perfect sense just because the people who think so don't 
think things through.

It doesn't help, for several reasons:

 - the step function of the Makefile change happens once per release, and 
   if you compile anything but releases, you can never rely on just the 
   revision. Was it a plain -rc, a plain release, or something in 
   between? You'll never know, just looking at the 2.6.x.y thing.

   In other words, you fundamentally have three choices:

    (a) be confused. Adding an "-rc0" won't help. You'll still be confused 
	in between releases about exactly what you're running.

    (b) use CONFIG_LOCALVERSION_AUTO=y

	Now, if 'uname -r' says 2.6.31, then you _know_ it's exactly 
	2.6.31 and nothing else. If it's a few commits after 2.6.31, it 
	will say something like '2.6.31-1-g752015d', and you know that 
	it's one commit after 2.6.31, and you'll know _which_ commit it is!

    (c) Don't compile anything but releases. 

   Those are the choices. 

 - An even _more_ fundamental reason: Linux development isn't linear. 
   There is not one "first commit" after a release, and there never will 
   be. Sure, there's a first commit that I do, but that has absolutely 
   zero relevance.

   Learn this. Until you do, you'll be confused, and you'll show your 
   confusion by saying "I want a 2.6.n+1-rc0". You'll _also_ show your 
   confusion by things like "I was bisecting a bug that happened between 
   2.6.30 and 2.6.31, and suddenly git was asking me to test a kernel that 
   said it was version 2.6.29-rc1 - so I stopped bisecting because git was 
   confused".

Who was confused? Was it git, or was it the person who thought that the 
Makefile version could be consistent in a non-linear world?

So no. I'm not going to do -rc0. Because doing that is _stupid_. And until 
you understand _why_ it's stupid, it's pointless talking about it, and 
when you _do_ understand that it's stupid, you'll agree with me.

			Linus
