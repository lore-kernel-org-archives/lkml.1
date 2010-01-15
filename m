Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0AONZh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526Ab0AONZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:25:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0AONZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:25:36 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <20100115131037.GP4822@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb>
	 <1263548124.4244.358.camel@laptop>  <20100115131037.GP4822@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 14:25:30 +0100
Message-ID: <1263561930.4244.417.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 08:10 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> > > > Then we can ditch the whole utrace muck as I see no reason to want to
> > > > use that, whereas the ubp (given a sane name) looks interesting.
> > > 
> > > Assuming you meant what you write, perhaps you misunderstand the
> > > layering relationship of these pieces.  utrace underlies uprobes and
> > > other process manipulation functionality, present and future.
> > 
> > Why, utrace doesn't at all look to bring a fundamental contribution to
> > all that. If there's a proper kernel interface to install probes on
> > userspace code (ubp seems to be mostly that) then I can use perf/ftrace
> > to do the rest of the state management, no need to use utrace there.
> 
> > You can hardly force me to use utrace there, can you?
> 
> utrace is not a form of punishment inflicted upon the undeserving.  It
> is a service layer that uprobes et alii are built upon.  You as a
> potential uprobes client need not also talk directly to it, if you
> wish to reimplement task-finder-like services some other way.

I said I wanted to, I think the whole task orientation of user-space
probing is wrong, its about text mappings.

But yes, I think that for most purposes utrace is a punishment, its way
too heavy, I mean, trap, generate a signal, catch the signal, that's
like an insane amount of code to jump through in order to get that trap.

Furthermore it requires stopping and resuming tasks and nonsense like
that, that's unwanted in many cases, just run stuff from the trap site
and you're done.

Yes you can do this with utrace, and I'm not going to stop people from
using utrace for his, I'm just saying I'm not going to.

