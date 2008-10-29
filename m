Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYJ2USX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYJ2USX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYJ2USG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:18:06 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59515 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbYJ2USE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:18:04 -0400
Date: Wed, 29 Oct 2008 22:16:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/11] ftrace: handle generic arch calls
Message-ID: <20081029201646.GA1816@cs181140183.pp.htv.fi>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com> <20081029190045.GC22105@uranus.ravnborg.org> <alpine.DEB.1.10.0810291517220.13214@gandalf.stny.rr.com> <20081029194956.GA22606@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081029194956.GA22606@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 08:49:56PM +0100, Sam Ravnborg wrote:
> On Wed, Oct 29, 2008 at 03:24:19PM -0400, Steven Rostedt wrote:
> > 
> > On Wed, 29 Oct 2008, Sam Ravnborg wrote:
> > > >  
> > > > +if ($arch eq "x86") {
> > > > +    if ($bits == 64) {
> > > > +	$arch = "x86_64";
> > > > +    } else {
> > > > +	$arch = "i386";
> > > > +    }
> > > > +}
> > > > +
> > > >  if ($arch eq "x86_64") {
> > > >      $section_regex = "Disassembly of section";
> > > >      $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> > > > 
> > > 
> > > This looks strange to my eyes.
> > > Why not do the more obvious:
> > > if ($arch eq "x86" && $bits == 64) {
> > > 
> > > The change above is like trying to stick to the old i386/x86_64
> > > notation.
> > 
> > Trying to fix it tells me my answer to why I did it his way ;-)
> > 
> > I have queued patches that will support other archs so x86 is not the
> > only arch that can be used here. But x86 is special, it seems to be the 
> > only arch (that I know of, correct me if I'm wrong) that can compile with
> > multiple archs defined: make ARCH=x86_64, make ARCH=i386, or
> > make ARCH=x86. All are legit.
> > 
> > Now how do we handle this. I've been fine for all my testing to do just 
> > x86_64 and i386 because a normal make of x86 will use automatically set
> > ARCH to i386 or x86_64 depending on the build.
> > 
> > But then Adrian Bunk pointed out that "make ARCH=x86" fails. Now I need to 
> > add a case for x86, but still allow for x86_64 or i386 being passed in.
> > 
> > Since x86 is the ambiguous case, I made it the one that would be converted 
> > to i386 or x86_64 since those could be passed in directly.
> The trick is usually to replace use of ARCH with SRCARCH.

That won't help - what he wants to know is whether he's on 32bit or
on 64bit.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

