Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZBWWRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZBWWRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZBWWRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:17:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZBWWRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:17:34 -0500
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20090223183220.GE19739@mit.edu>
References: <20090220172241.GF24538@elte.hu>
	 <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com>
	 <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com>
	 <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com>
	 <1235406159.4645.366.camel@laptop> <20090223171032.GA2566@redhat.com>
	 <alpine.DEB.2.00.0902231228420.18221@gandalf.stny.rr.com>
	 <20090223183220.GE19739@mit.edu>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 23:16:59 +0100
Message-Id: <1235427419.4645.959.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 13:32 -0500, Theodore Tso wrote:
> On Mon, Feb 23, 2009 at 12:31:31PM -0500, Steven Rostedt wrote:
> > > The impression that this is somehow different with tracepoints is
> > > mistaken.  Tracepoints are *exactly* as "ABI-like" as markers.
> > 
> > I disagree with this point. markers are text strings that will eventually 
> > appear to userspace. trace points need translation. A trace point can be 
> > modified at any time and should never mess up user apps.
> > 
> > You may have a hook to a trace point that provides user apps a text based 
> > output. If the trace point changes, this hook may break. But the tracer 
> > maintainer of that hook will be responsible for that change, not the 
> > maintainer of the code the tracepoint existed in.
> 
> So stupid question time --- exactly who is supposed to write and
> maintain trnaslation code; the "hook"?  What trace points have done is
> added an extra layer of indirection, but in order for someone to
> actually make *use* of the have the trace point, someone has to
> maintain the "hook".

That just means we have to make it easier to write/generate this glue,
no? If we had function argument debug data (see below) we could generate
a generic tracepoint hook.

> I'm sorry I've offended Peter with the ext4 trace_mark() hooks, but
> it's what I could forsee needing if someone wants reports a wierd sh*t
> bug in ext4 and I wanted to be able to be able to extract debugging
> information without forcing them to patch and recompile the kernel,
> and in the ideal world, without even needing to reboot the kernel.
> (If we had usable and reliable debuginfo information, in most cases
> I'd be able simply use access to function parameters as replacements
> for trace_mark().)

We're working on adding arguments to the function/graph tracer, it would
fit all your above requirements and doesn't need any source modification
to boot.

Furthermore, most of it is upstream.

> I've had to debug problems in the field on customer machines where
> installing a new kernel was a big deal (as in, you get a window to
> reboot the machine every 24 hours, and the problem is so complex you
> can't replicate it anywhere *but* the production environment).  It's
> also been the case that more than once I've seen wierd behaviour on my
> laptop, and being able to peer inside it to see what is going on
> easily and conveniently is a major win.

Yeah, I know, the function graph tracer is brilliant that way. It even
provides information on the rest of the system and requires no
additional patches or big lumps of userspace.

> Finally, whether or not the text string is an ABI really depends on
> the tools.  Given that the string is self describing, it's only an ABI
> if the tools are stupid.  

>  This really isn't rocket science....

It isn't, yet how many scripts/programs have you seen that failed at the
above?


