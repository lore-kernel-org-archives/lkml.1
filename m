Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0AOOBE (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691Ab0AOOBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:01:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab0AOOBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:01:02 -0500
Date: Fri, 15 Jan 2010 09:00:42 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100115140042.GR4822@redhat.com>
References: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com> <1263467394.4244.291.camel@laptop> <1263509380.4875.35.camel@localhost.localdomain> <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb> <1263548124.4244.358.camel@laptop> <20100115131037.GP4822@redhat.com> <1263561930.4244.417.camel@laptop> <20100115133825.GQ4822@redhat.com> <1263563276.4244.426.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263563276.4244.426.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jan 15, 2010 at 02:47:56PM +0100, Peter Zijlstra wrote:
> [...]
> > I'm not sure, but it sounds like the part you're complaining about is
> > how utrace ultimately reports the trap to uprobes: i.e.,
> > utrace_get_signal()?  Is that the "insane amount of code"?
> 
> Well when tracing/profiling every instruction is too much. Having to
> needlessly raise a signal only to catch it again a short bit later
> sounds like obvious waste to me.

Well, I'm not in a position to argue line by line about the necessity
or the cost of utrace low level guts, but this may represent the most
practical engineering balance between functionality / modularity /
undesirably intrusive modifications.  Perhaps there exists a tool with
which one can confirm your worry about excess cost of this particular
piece.


> > > Furthermore it requires stopping and resuming tasks and nonsense like
> > > that, that's unwanted in many cases, just run stuff from the trap site
> > > and you're done.
> > 
> > I don't know what you mean exactly.  A trap already stopped task.
> > utrace merely allows various clients to inspect/manipulate the state
> > of the task at that moment.  It does not add any context switches or
> > spurious stop/resumue operations.
> 
> Srikar seemed to suggest it needed stop/resume.

You may be confusing breakpoint insertion/removal operations versus
breakpoint hits.


- FChE
