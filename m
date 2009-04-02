Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbZDBHfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbZDBHfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZDBHez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:34:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40310 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZDBHez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:34:55 -0400
Date: Thu, 2 Apr 2009 09:36:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
Message-ID: <20090402073636.GZ11935@one.firstfloor.org>
References: <49CC08A2.5030602@redhat.com> <20090401133654.GB18677@elte.hu> <49D37584.50208@redhat.com> <873acsm8qp.fsf@basil.nowhere.org> <49D3D3B4.4060702@redhat.com> <20090401221540.GX11935@one.firstfloor.org> <49D3F713.1000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3F713.1000502@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 07:21:55PM -0400, Masami Hiramatsu wrote:
> Andi Kleen wrote:
> > On Wed, Apr 01, 2009 at 04:51:00PM -0400, Masami Hiramatsu wrote:
> >> Andi Kleen wrote:
> >>> Masami Hiramatsu <mhiramat@redhat.com> writes:
> >>>> I agreed. Fortunately, Jim Keniston and I wrote an x86 instruction
> >>>> decoder :-) which has been made originally for uprobe andd kprobes
> >>>> jump-optimizer.
> >>>>
> >>>> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
> >>> An alternative would be to adapt the x86 interpreter in KVM.
> >>> I thought for some time that that one should be available in 
> >>> a more generic form in a library.
> >> As far as I can see, KVM's instruction emulator is incomplete
> > 
> > That's fine for you -- you only care about a subset of instructions
> > anyways, don't you?
> 
> Actually, (in my case) I just need to decode non-FPU instructions,

What does it have to do with the FPU?  I don't think the KVM
one is aimed at those either.

> because I'd like to check whether kprobe is on the instruction
> boundary.
> 
> However, KVM's insn decoder can't decode some elemental
> instructions, and instruction flags are incorrect.

What flags?  EFLAGS? 

> I had written instruction decoder based on it, but the result
> was so awful!

What were the problems?

Did you report the problems to the KVM maintainers?

I still think it would be better to have a single good
decoder than a multitude of different ones tailored to specific
cases. 

> So soon, I had to rewrite it based on Intel's manual entirely :-(

Ok then perhaps KVM could benefit from your work too?

> > do nothing. I looked at it some time ago for doing instruction
> > length checking for some application, but that application
> > then disappeared. The main obstacle with making it a library 
> > is that some KVM specific dependencies have crept in that would
> > need to be abstracted again, but I don't think it would need a lot of 
> > effort,
> 
> Sorry, but I don't think so. Current KVM's decoder is much more
> focusing on preparing instructions emulation. It requires
> vcpu setup, fetching operators and so on. I think it needs to
> diet their code (or well splitting from emulator).

the vcpu stuff can be all dummies. If you look at the original
Xen version of it before it forked it was better isolated there.
The other stuff that crept in in the KVM version could be also
fixed.


> Anyway, I don't stick with my decoder. If they can provide more
> generic interfaces, I'd be happy to use it. :-)

I suspect "they" would need some help.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
