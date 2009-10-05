Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZJETjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZJETjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZJETjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:39:32 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:51707 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbZJETjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jSBlJRui+kPISfSWFjpV24Bznf/b/us/IOTbRASlLda2OO8zJhvmIbMthr7Jq5cKk3
         Fx42PBD0rFbSC8EIHqe8re5nvXiy3Gfpe0NVPz1mwQum6iEBbAC2E8+Y9njwc8PhCp1h
         AVztVrxns8NXahJ2LszMmyb+ikL8UqoXVozlk=
Date: Mon, 5 Oct 2009 21:38:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
Message-ID: <20091005193850.GC6071@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005191829.GA6071@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 09:18:31PM +0200, Frederic Weisbecker wrote:
> On Sun, Oct 04, 2009 at 01:21:52AM -0400, Masami Hiramatsu wrote:
> > Hmm, # is widely used for comment, including some kernel pseudo
> > file interfaces, kprobe_events too. Comments are useful if a
> > probe list is restored from a file.
> >
> 
> 
> Right, let's think about something else.
> 
> 
> > For accessing local variables, kprobe-tracer needs to support *at least*
> > below variables:
> > - Registers
> > - Stack address (if a register points stack address, this isn't needed)
> 
> 
> Ok.
> Well, thinking more about the % sign, we shouldn't worry about
> format confusion, since it's a commonly used character for registers,
> we can take it for them: %rax, %rbx, etc. (is that what you did
> in this patch? I don't remember exactly...)
> 
> And for addresses: @addr
> 
> 
> > Below special vars are complementary aliases.
> > - Function arguments
> 
> 
> 
> For the function arguments, I guess we don't need to worry
> anymore about r0, r1, etc... but we can deal with the true var
> name, without any kind of prefixes.


Sorry, as you pointed out, it's better to keep the same syntax for
both perf probe and ftrace, but having perf probe able to support
variable name.

Hence the following that don't collide: varname, arg(n)


> 
> > - Return value
> 
> 
> 
> What about %return ?
> 
> As return values are usually stored in a register (at least in Arm
> and x86, I don't know about the others), the % prefix fits well for
> that.
> 
> 
> > - Return address
> 
> 
> What about @return :-) ?
> 
> That said we shouldn't worry about that in perf, since we can
> take snapshots of the backtraces, like in some other perf events.
> 



But we need to worry about it because we want to share the ftrace syntax.
So yeah, why not @return ?

