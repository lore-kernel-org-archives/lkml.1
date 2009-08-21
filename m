Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZHUUe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZHUUe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932551AbZHUUeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:34:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbZHUUeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:24 -0400
Date: Fri, 21 Aug 2009 16:34:22 -0400 (EDT)
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
In-Reply-To: <alpine.DEB.2.00.0908211601000.30182@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0908211631420.30182@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org> <20090821143525.GH11098@elte.hu> <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com> <20090821145406.GA3659@elte.hu> <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0908211204490.30182@gandalf.stny.rr.com> <20090821162822.GA20898@elte.hu> <alpine.DEB.2.00.0908211253080.30182@gandalf.stny.rr.com> <20090821195131.GE5356@elte.hu> <alpine.DEB.2.00.0908211601000.30182@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Aug 2009, Steven Rostedt wrote:

> 
> On Fri, 21 Aug 2009, Ingo Molnar wrote:
> > > OK, I'll add that to my todo list. Note, it the local config is 
> > > only as good as the starting .config. That is, it never touches =y 
> > > settings, because it only uses loaded modules as a base. Thus if 
> > > something is set to =y it will always be set to =y.
> > > 
> > > What would you have in mind. Just randomly enabling modules? If we 
> > > enable a "y" config then the next local*config will still keep 
> > > that set.
> > 
> > Why - isnt local*config picking up environmental (currently running 
> > kernel) properties? I.e. it would always set those things that are 
> > needed - and randomize the rest. Have i misunderstood how it works?
> 
> Yes, this is a simple script. The only thing it does to find out what is 
> configured is run "lsmod". Others have tried (in vain) to be able to look 
> into things like lspci and lsusb to figure out what options to enable, 
> just to end up with something so complex that it doesn't work.

Just to make this clearer. Since the script only uses lsmod to figure out 
what options are configured, only touching "=m" options is safe. There's 
no good way to know if a "=y" option can be disabled, so I just leave them 
as is. Unfortunatly, once you run localyesconfig, the script will stop 
modifying it, since there are no more "=m" options, nor will you have 
modules listed in "lsmod".

-- Steve

