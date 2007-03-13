Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbXCMVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbXCMVsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbXCMVso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:48:44 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755AbXCMVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:48:44 -0400
Date: Tue, 13 Mar 2007 14:39:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [RFC/PATCH 00/59] Make common x86 arch area for i386 and x86_64
In-Reply-To: <1173820919.28042.3.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
References: <1173820919.28042.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Mar 2007, Steven Rostedt wrote:
> 
> What we have currently is a bunch of hacks.  Seems that people can't make
> up their mind to what to do.

I don't mind the patches, but I'd be a lot happier if it also was a stated 
intention to actually make it be buildable as "x86", the same way that the 
separate 32-bit and 64-bit POWER architectures were merged into just one 
architecture that could be built either way.

For the POWER merge, we had (and probably still have) legacy platforms 
that could only be built the old way (ie if you needed to build for 
certain legacy 32-bit targets, you still needed to use the "ppc" 
architecture, so I'm not saying that it has to all be converted, but I 
think that we should at least *aim* for unifying 32-bit and 64-bit x86.

The "32-bit code has legcay issues" thing that Andi complained about (eg 
there's no guarantee of a HPET on 32-bit x86) doesn't really change the 
fact that yes, we have to support those legacy issues *anyway*, and 64-bit 
x86 certainly has its set of issues already too.

We've started to notice that the i386 build gets broken now that most 
developers tend to have newer CPU's and run mostly on x86-64 (and yes, 
that's me too), and while I don't think unifying things will guarantee 
that doesn't happen in the future, it will hopefully at least help make it 
not get much *worse*.

As it is, the build environment has to know to pass in "-m32/-m64" 
anyway..

		Linus
