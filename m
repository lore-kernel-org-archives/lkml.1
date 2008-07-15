Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbYGOBIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbYGOBIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYGOBIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:08:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbYGOBIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:08:34 -0400
Date: Mon, 14 Jul 2008 21:08:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
In-Reply-To: <m13amg9fl0.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.58.0807142105390.2955@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com>
 <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
 <20080711121655.05810822.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
 <20080711153740.b86acadd.akpm@linux-foundation.org> <m13amg9fl0.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 11 Jul 2008, Eric W. Biederman wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > Well that's an interesting question and it has come up before.  There
> > are times when the kernel wants to display a process identifier at
> > least in a printk.  Oopses are one prominent example.
> >
> > Perhaps we do need a way of doing this in a post-pid-namespace-world.
> > Presumably it would be of the form "pidns-identifier:pid", and just
> > plain old "pid" if no pid namespaces are in operation, for some
> > back-compatibility where possible.
> >
> > Eric, any thoughts?
>
> I don't quite know what we are doing here.  Is this a /proc or /sysfs file?

Actually it is a /debug (or /sys/mount/debug if you prefer) file.

>
> After a long series of discussion on semantics what we came up with
> was that the pid namespaces are hierarchical and that a struct pid
> will have a numerical identifier in each pid namespace.  Which means
> that for printing pids in the case of printks especially for oops
> reports we can just go with pid number in the init_pid_ns.  Which is
> the classic system wide pid.
>
> In every other case I know besides printk we are delivering the data to an
> application, and that application is running in a pid namespace
> therefore we really want to figure out the pid namespace and give it the
> information.
>
> For filesystem interfaces (besides proc which provides a natural split)
> the classic answer is to capture namespaces at mount time.  And display
> the data in the filesystem relative to the namespaces we captured.

I'd be interested in knowing who would want namespaces in traces. I've
basically only used tracing to see "what's happening in the kernel here?".
Where I only use the pid to differentiate between the tasks I know are
running.

Hence, tracing is much like printk. Does it really matter with these
outputs. But ftrace is pluggable, pid namespaces may matter in future
plugins.

-- Steve

