Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYGVLwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYGVLwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYGVLwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:52:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYGVLwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:52:42 -0400
Date: Tue, 22 Jul 2008 07:51:01 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
Message-ID: <20080722115101.GB9508@redhat.com>
References: <1216676595.3433.80.camel@localhost.localdomain> <y0mprp68zg9.fsf@ton.toronto.redhat.com> <1216698788.3433.116.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216698788.3433.116.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Jul 21, 2008 at 10:53:08PM -0500, James Bottomley wrote:
> [...]
> > - You disprefer systemtap's use of an established, non-deprecated API
> >   for placing kernel probes.  [...]
>
> You mean embedding half a megabyte of symbols simply so you can avoid
> the inconvenience of using a kernel API? yes, I think it's ...
> suboptimal.

It has been explained already that the symbol table you saw in
stap-symbols.h has nothing to do with the kprobe addressing issue.

http://www.gossamer-threads.com/lists/linux/kernel/947365#957365


> > - You argue that symbols+offset kprobing is better.  We can see that,
> >   in some sense, but ...
> > 
> > - I explain that we are used to final address calculating, as we'll
> >   have to do that regardless for user-space probes.  Plus we need to
> >   work with kernels that predate the symbol+offset kprobe api
> >   extension.  So this change would not simplify systemtap in any way.
> >   You do not respond.
> 
> There is no current userspace infrastructure, since utrace still isn't
> in the kernel, so you're predicating this argument on an event which
> hasn't happened.

We exercise professional foresight.  And the backward compatibility
issue remains even without that.


> Even assuming utrace is accepted, embedding the symbol table of
> every user space process in the probes is still daft.  [....]

It would take space, no question, though we're not talking about
"every" process, just designated ones.

> For instance, the obvious way to me of doing this would be to map
> the user space stack into the systemtap runtime and unwind it from
> there instead of vectoring it into the kernel.

Please elaborate.  What does mapping a stack into the runtime mean?
Do you mean to suggest having the userspace program unwind itself?  Or
relying on the userspace programs' possibly-paged-out unwind data?
That would be intrusive.


> > - I offer _stext+offset (for the kernel) and (.text*)+offset (for
> >   modules) kprobes: basically to use the "better" symbol+offset
> >   kprobes api, but use the same single reference addresses we already
> >   do, and leaving just the final addition to the kernel.  You do not
> >   respond materially.
> 
> I thought this and subsequent emails addressed the points pretty well:
> 
> http://marc.info/?l=linux-kernel&m=121632572409118

No, they didn't.  Every time I explained about how it does work, you
just claimed "not", without even a single worked-out substantiating
example.


> [...]
> >   - storage of all that new file name data in permanent unswappable
> >     kernel data (>>100kB, if done simply prefixing local symbol names
> >     file file names).
> 
> I'd check my facts before making assertions.  The kernel symbol table is
> stored in a compressed form that actually eliminates most of these
> repetitions.

A careful reader will notice the "if" in my sentence.  Anyway, that
or a superior compression scheme could apply to systemtap's various
tables too.


> >   - possible further complications related to filename string matching
> 
> Any substantiation of that?

We have had reported problems with differences between kernels
hand-built with long absolute source path names versus the smallest
"kernel/foo.c" names.  If such canonicalization takes place but
inconsistently by the different tools, we will have a problem.


> [...]
> > In total, this path would end up with both systemtap and the kernel
> > more complex, larger and a bit slower too.
> 
> Really?  I count the reduction of the probe modules from 500kb to 50kb a
> worthwhile saving.  

The red clupea harengus again.

> I don't even see where anything became larger.

Even with ksymtab compression, there is still new data to be stored in
the kernel, and it is extra for each systemtap probe datum.


> > Does that still seem an acceptable cost, just to get systemtap to
> > change its preferred kprobes api?

> [no answer]

Indeed.


- FChE
