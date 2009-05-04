Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZEDOqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZEDOqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZEDOqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:46:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZEDOqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:46:37 -0400
Date: Mon, 4 May 2009 10:46:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 7/7] kconfig: search for a config to base the
 local(mod|yes)config on
In-Reply-To: <1241440086.7620.4877.camel@twins>
Message-ID: <alpine.DEB.2.00.0905041043330.12811@gandalf.stny.rr.com>
References: <20090430185022.122124349@goodmis.org>  <20090430185223.792841532@goodmis.org>  <87fxflgj2q.fsf@basil.nowhere.org> <1241440086.7620.4877.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 4 May 2009, Peter Zijlstra wrote:

> On Mon, 2009-05-04 at 14:15 +0200, Andi Kleen wrote:
> > Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > > Here's the list and order of search:
> > >
> > >   /proc/config.gz
> > >   /boot/vmlinuz-`uname -r`
> > >   vmlinux  # local to the directory
> > >   /lib/modules/`uname -r`/kernel/kernel/configs.ko
> > >   kernel/configs.ko
> > >   kernel/configs.o
> > >   .config
> > 
> > 
> > That seems like the wrong order. ./.config should always be first for
> > compatibility. 
> > 
> > That order would completely wreck all my build scripts, and I suspect
> > others too.
> 
> Quite, except that I hardly ever have a ./.config since I make extensive
> use of O=foo

I'm fine with using .config as first choice (that is what the script 
originally did) but I wanted to make it as easy for non developers as 
possible. Taking from /proc or /boot was most likely the best to give a 
minimal boot environment.

But I can see why .config is probably the best choice for having the most 
power with the tool. It is how you can always force it to do something you 
want, and is the most logical place to expect the script to read from.

I'll update it.

Thanks,

-- Steve

