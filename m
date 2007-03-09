Return-Path: <linux-kernel-owner+w=401wt.eu-S1767394AbXCIQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767394AbXCIQuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767392AbXCIQuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:50:24 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36648 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767394AbXCIQuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:50:21 -0500
Date: Fri, 9 Mar 2007 10:50:17 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Sam Vilain <sam@vilain.net>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070309165017.GF5948@sergelap.austin.ibm.com>
References: <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com> <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com> <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <45EF793C.1000700@vilain.net> <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com> <45EF83CB.9080903@vilain.net> <6599ad830703080110i33405501tb12bf8e58bf829c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703080110i33405501tb12bf8e58bf829c9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 3/7/07, Sam Vilain <sam@vilain.net> wrote:
> >
> >Ok, they share this characteristic with namespaces: that they group
> >processes.

Namespaces have a side effect of grouping processes, but a namespace is
not defined by 'grouping proceses.'  A container is, in fact, a group of
processes.

> > So, they conceptually hang off task_struct.  But we put them
> >on ns_proxy because we've got this vague notion that things might be
> >better that way.
> 
> Remember that I'm not the one pushing to move them into ns_proxy.
> These patches are all Srivatsa's work. Despite that fact that they say
> "Signed-off-by: Paul Menage", I'd never seen them before they were
> posted to LKML, and I'm not sure that they're the right approach.
> (Although some form of unification might be good).

The nsproxy container subsystem could be said to be that unification.
If we really wanted to I suppose we could now always mount the nsproxy
subsystem, get rid of tsk->nsproxy, and always get thta through it's
nsproxy subsystem container.  But then that causes trouble with being
able to mount a hierarachy like

	mount -t container -o ns,cpuset

so we'd have to fix something.  It also slows things down...

> >>> about this you still insist on calling this sub-system specific stuff
> >>> the "container",
> >>>
> >> Uh, no. I'm trying to call a *grouping* of processes a container.
> >>
> >
> >Ok, so is this going to supplant the namespaces too?
> 
> I don't know. It would be nice to have a single object hanging off the
> task struct that contains all the various grouping pointers. Having

The namespaces aren't grouping pointers, they are resource id tables.

I stand by my earlier observation that placing namespace pointers and
grouping pointers in the same structure means that pointer will end up
pointing to itself.

> something that was flexible enough to handle all the required
> behaviours, or else allowing completely different behaviours for
> different subsets of that structure, could be the fiddly bit.
> 
> See my expanded reply to Eric' earlier post for a possible way of
> unifying them, and simplifying the nsproxy and container.c code in the
> process.

Doesn't ring a bell, I'll have to look around for that...

> >
> >  - resource groups (I get a strange feeling of d?j? v? there)
> 
> Resource groups isn't a terrible name for them (although I'd be

I still like 'rug' for resource usage groups :)

-serge
