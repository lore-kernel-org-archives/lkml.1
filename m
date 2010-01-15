Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0AOKL0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077Ab0AOKLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:11:25 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53060 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab0AOKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:11:25 -0500
Date: Fri, 15 Jan 2010 15:40:56 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100115101056.GD26396@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com> <1263467289.4244.288.camel@laptop> <1263498366.4875.25.camel@localhost.localdomain> <1263546228.4244.343.camel@laptop> <20100115093831.GC26396@in.ibm.com> <1263549014.4244.374.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263549014.4244.374.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 10:50:14AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 15:08 +0530, Ananth N Mavinakayanahalli wrote:
> > On Fri, Jan 15, 2010 at 10:03:48AM +0100, Peter Zijlstra wrote:
> > > On Thu, 2010-01-14 at 11:46 -0800, Jim Keniston wrote:
> > > > 
> > > >  discussed elsewhere. 
> > > 
> > > Thanks for the pointer...
> > 
> > :-)
> > 
> > Peter,
> > I think Jim was referring to
> > http://sources.redhat.com/ml/systemtap/2007-q1/msg00571.html
> 
> That's a 2007 email from some obscure list... that's hardly something
> that can be referenced to without link.
> 
> As previously stated, I think poking at a process's address space is an
> utter no-go.

In which case we'll need to find a different solution to it. The gdb
style of 'breakpoint hit' -> 'put original instruction back in place' ->
single-step -> 'put back the breakpoint' would be a big limiter,
especially for multithreaded cases.

The design here is to have a small vma sufficiently high enough in
memory a-la vDSO that most apps won't reach, though there is still no
ironclad guarantee.

Ideally, we will need to single-step on a copy of the instruction, in the
user address space of the traced process.

Ideas?

Ananth
