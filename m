Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZCAKkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZCAKkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 05:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZCAKj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 05:39:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36627 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZCAKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 05:39:54 -0500
Date: Sun, 1 Mar 2009 19:37:36 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090225002852.5ef5b869.akpm@linux-foundation.org>
References: <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org>
Message-Id: <20090228161050.6FC9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 25 Feb 2009 09:11:18 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Tue, 24 Feb 2009 23:08:56 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > > Gad, what a lot of stuff.
> > > > > 
> > > > > Use strncpy_from_user()?
> > > > > 
> > > > > Use strstrip()?
> > > > > 
> > > > > Why do we care about leading and trailing whitespace - user error!
> > > > 
> > > > This is because i want:
> > > > 
> > > >  cat available_events > set_event
> > > > 
> > > > to work.
> > > 
> > > :(
> > > 
> > > Why on earth do we keep on putting all these pretty-printers 
> > > and pretty-parsers into the kernel?  I mean, how hard is it 
> > > for userspace to read a text file, do some basic substitutions 
> > > and print it out again?
> > 
> > Note that there's no mandatory user-space component here - the 
> > final destination is the kernel developer's eyes in 90% of the 
> > cases. These traces get pasted into email, etc. etc.
> > 
> > So leading spaces, meaningful formatting and general hands-on 
> > usability is important. [ I know, it's a strange concept in the 
> > kernel, we tend to have a perversion for the most unusable and 
> > most inconsistent user interfaces ;-) ]
> > 
> > It's also a balancing act. We dont want to put all of TeX into 
> > the kernel obviously. Nor do we want the default to be the 
> > opposite end of the spectrum: to output raw binary records. So 
> > we find some middle ground. That middle ground is inluenced by 
> > the developers using this stuff.
> > 
> 
> <For the enty enth pissing-in-the-wind time>
> 
> A better approach would be to design simple, robust kernel interfaces
> which make sense and which aren't made all complex by putting the user
> interface in kernel space.  And to maintain corresponding userspace
> tools which manipulate and present the IO from those kernel interfaces.
> 
> But we don't do that, because userspace is hard, because we don't have
> a delivery process.  But nobody has even tried!  We can do this - it
> starts with `mkdir -p userspace/ktrace'.
> 
> Probably it's already too late for ktrace though - that hole is already
> dug.
> 
> 
> Last time I pissed in this wind I got fobbed off with some stupid "put
> it in util-linux" answer.  But of course we won't do that, because it's
> MUCH harder and slower and more complex than just patching the kernel
> tree.  So nothing happened.  Again.
> 
> And please let's not all sit here busily thinking up improbable reasons
> why it can't possibly work.  We're clever!  We can do this sort of
> thing!  If problems arise, we fix them!
> 


> The only extant example I can think of is getdelays.c, and that was a
> totally half-assed effort with no infrastructural support at all.  But
> quite a lot of people use it, and patches occasionally come in for it,
> no problems.

<just offtopic>

I think getdelays.c should move to "userspace/delayacct".
it's definitly not document.
(slabinfo too)

Documentation directory should only have documentation and example.



