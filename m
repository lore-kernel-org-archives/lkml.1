Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZKLPyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZKLPyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZKLPyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:54:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:1753 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZKLPyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RtYf5yOLTdr0e/yhuZOh6rrAfnKO/G4lD/DWSd+V2crlj/chLBvj+jDbK8DLcdW8V0
         XK5NZ52+f55qxoCNOMu+mkuAIJqV/WG+RQwCuh8EJll68JyF2RTDmoTyMHDVgWpGi8k2
         wdYjzy1IJdbOneIcO8r2SjdfyOKP4VWJYYbek=
Date: Thu, 12 Nov 2009 16:54:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 5/6] hw-breakpoints: Arbitrate access to pmu following
	registers constraints
Message-ID: <20091112155413.GE5237@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-6-git-send-email-fweisbec@gmail.com> <19186.45014.502448.698606@cargo.ozlabs.ibm.com> <1257713781.13611.284.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257713781.13611.284.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 07:56:21AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2009-11-05 at 21:58 +1100, Paul Mackerras wrote:
> > Frederic Weisbecker writes:
> > 
> > > Allow or refuse to build a counter using the breakpoints pmu following
> > > given constraints.
> > 
> > As far as I can see, you assume each CPU has HBP_NUM breakpoint
> > registers which are all interchangeable and can all be used either for
> > data breakpoints or instruction breakpoints.  Is that accurate?
> > 
> > If so, we'll need to extend it a bit for Power since we have some CPUs
> > that have one data breakpoint register and one instruction breakpoint
> > register.  In general on powerpc the instruction and data breakpoint
> > facilities are separate, i.e. we have no registers that can be used
> > for either.
> 
> Additionally, we have more fancy facilities that I don't see exposed at
> all through this interface (we are building an ad-hoc ptrace based
> interface today so that gdb can make use of them) and we have one guy
> with crazy constraints that we don't know yet how to deal with:
> 
> Among others features:
> 
>  - Pairing of two data or instruction breakpoints to create a ranges
> breakpoint
>  - Data value compare option
>  - Instruction value compare option



Yeah. The current generic interface is a draft. I'll try to write
something generic enough to fit in every archs needs.
This is needed before we expose its perf interface to userpace
anyway.

 
> And now the crazy constraints:
> 
>  - On one embedded core at least we have a case where the core has 4
> threads, but the data (4) and instruction (2) breakpoint registers are
> shared. The 'enable' bits are split so a given data breakpoint can be
> enabled only on some HW threads but that's about it.
> 
> I'm not sure if there's a realistic way to handle the later constraint
> though other than just not allowing use of the HW breakpoint function on
> those cores at all.
> 
> Ben.


Yeah this latter one is tricky. Not sure how to handle it either.
How are these hw-threads considered by the kernel core? As different
cpu?

