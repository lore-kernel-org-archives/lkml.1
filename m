Return-Path: <linux-kernel-owner+w=401wt.eu-S1161244AbXAZUGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161244AbXAZUGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161234AbXAZUGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:06:52 -0500
Received: from raven.upol.cz ([158.194.120.4]:43659 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbXAZUGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:06:51 -0500
Date: Fri, 26 Jan 2007 20:14:51 +0000
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070126201451.GA14946@flower.upol.cz>
References: <200701151624.18033.rob@landley.net> <200701251438.03213.rob@landley.net> <20070125211802.GC10907@flower.upol.cz> <200701261247.22374.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701261247.22374.rob@landley.net>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 12:47:20PM -0500, Rob Landley wrote:
> On Thursday 25 January 2007 4:18 pm, Oleg Verych wrote:
> 
> > > As I said, I'm not particularly interested in a more intrusive solution 
> > > solving a problem I haven't actually seen.  I don't see any obvious reason 
> > > why it wouldn't work, and yes it would probably also solve my problem, but
> > > I still don't see why you think it's "better" than the three byte fix.
> > 
> > Ehhh. "I'm not guilty" issue. Well, fine ;)
> 
> "guilty"?
> 
> You attempted to hijack my simple observation ("awk is the standard name, gawk 
> is not") into an attempt to replace susv3 standard utilities with extra shell 
> script.  This is a separate agenda, and I have _no_ idea why you think I'm 
> obligated to pursue it for you.
> 
> The motivation for my patch is taht circa 2.6.12 I didn't need gawk on my 
> system to build; the need for it cropped up fairly recently.  This is A) an 
> artificial requirement, B) a regression, C) trivial to fix.
> 
> I could also teach busybox awk to be called as "gawk", but awk is the standard 
> name and gawk is not, and gawk can already be called as awk.  The _clean_ 
> thing to do is send a patch to get Linux to use the standard name, which I 
> did.  This is the minimally intrusive change, and since gawk's install 
> creates an awk symlink it shouldn't affect any existing systems.
> 
> That's what I did.  I am simply not interested in your attempts to do 
> something else, in hopes of fixing a problem I haven't seen and which I'm not 
> convinced actually exists.

IMHO every embedded developer besides size cares about speed and
reducing complexity of simple things. Yes, this is orthogonal to that,
you want to say to me.

Only thing i wanted to have as reasult is ack or nack on my patch.
Everything else is outside LKML.

> > If your current system is IA-32, or you have access to one, would you
> > like to test scripts/makelst for me, as i'm seeing `bc' there. But my 
> > system have not one, i would like to replace it with shell or awk or
> > whatever. TIA.
> 
> According to Posix and SUSv3, a development environment can be expected to 
> have bc:
> http://www.opengroup.org/onlinepubs/009695399/utilities/bc.html
> 
> Would you like to try the one in busybox?

In Debian's version it has no `bc', while native `bc' is producing
crap like that:
,-*- bash -*-
|olecom@flower:~$ printf "%u" $(( -1 )) ; echo
|18446744073709551615
|olecom@flower:~$ echo -1 | bc
|-1
|olecom@flower:~$ printf "%u" $(( 0xFF )) ; echo
|255
|olecom@flower:~$ echo FF | bc
|99
|olecom@flower:~$ echo F | bc
|15
|olecom@flower:~$
`-*-

i can't understand the result... I think linux/scripts/makelst may be
updated to have sh's version of address calculation ;)

> The minimal development environment I can build a working system in is 7 
> packages: linux, gcc, binutils, make, busybox, uClibc, bash.  This is not 
> theoretical: I have actually done this, and I was building systems under this 
> as far back as 2003.  (I became busybox maintainer after spending 2 years 
> upgrading busybox to make this _work_.  I started by rewriting sed.  I didn't 
> _know_ sed at the time, but binutils ./configure used some rather advanced 
> sed scripts to build, so I fixed it.  It works now.)

I'm glad. All i can say in this context: do you know `dash' shell.
It's pretty much OK for not interactive use, small, fast, POSIX
compliant (or should be ;).

> I'm using this to get a minimal native environment on non-x86 target 
> platforms, to minimize the amount of cross compiling I have to do when 
> bootstrapping a new platform.  (I submitted an OLS tutorial proposal on this, 
> although I dunno if they're interested.)

Goodluck!

____
