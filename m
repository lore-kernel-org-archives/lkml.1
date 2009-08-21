Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbZHUQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbZHUQ4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZHUQ4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:56:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbZHUQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:55:59 -0400
Date: Fri, 21 Aug 2009 12:55:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
In-Reply-To: <20090821162822.GA20898@elte.hu>
Message-ID: <alpine.DEB.2.00.0908211253080.30182@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org> <20090821143525.GH11098@elte.hu> <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com> <20090821145406.GA3659@elte.hu> <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0908211204490.30182@gandalf.stny.rr.com> <20090821162822.GA20898@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Aug 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Fri, 21 Aug 2009, Steven Rostedt wrote:
> > > 
> > > OK, I found the bug. There's a dependency missing.
> > > 
> > > $ make localyesconfig
> > >   HOSTCC  scripts/basic/fixdep
> > >   HOSTCC  scripts/basic/docproc
> > >   HOSTCC  scripts/basic/hash
> > > using config: '/boot/config-2.6.27.25-78.2.56.fc9.x86_64'
> > > /bin/sh: line 8: scripts/kconfig/conf: No such file or directory
> > > make[1]: *** [localyesconfig] Error 127
> > > make: *** [localyesconfig] Error 2
> > > 
> > > Thus the script failed to run. But the sed command that converts the '=m' 
> > > to '=y' still ran. This gives us a distro config with all modules 
> > > converted to built in!
> > 
> > Funny that localmodconfig does not have this bug.
> 
> ... add to that i dont use modules much so i probably hit that 
> localyesconfig bug ;-)
> 
> btw: mind adding localrandconfig too? It would be a perfect tool to 
> randomize all configs except a 'must have' core set of options.
> 
> ( Or is this already possible via some existing kconfig feature? I
>   remember having seen something related, did that ever get
>   upstream? A quick grep in scripts/ shows nothing but i might have
>   missed it.)

OK, I'll add that to my todo list. Note, it the local config is only as 
good as the starting .config. That is, it never touches =y settings, 
because it only uses loaded modules as a base. Thus if something is set to 
=y it will always be set to =y.

What would you have in mind. Just randomly enabling modules? If we enable 
a "y" config then the next local*config will still keep that set.

-- Steve

