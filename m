Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab0AOOkv (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0AOOku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:40:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0AOOkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:40:49 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <20100115142213.GS4822@redhat.com>
References: <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb>
	 <1263548124.4244.358.camel@laptop> <20100115131037.GP4822@redhat.com>
	 <1263561930.4244.417.camel@laptop> <20100115133825.GQ4822@redhat.com>
	 <1263563276.4244.426.camel@laptop> <20100115140042.GR4822@redhat.com>
	 <1263564403.4244.430.camel@laptop>  <20100115142213.GS4822@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 15:40:36 +0100
Message-ID: <1263566436.4244.435.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 09:22 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> > > Well, I'm not in a position to argue line by line about the necessity
> > > or the cost of utrace low level guts, but this may represent the most
> > > practical engineering balance between functionality / modularity /
> > > undesirably intrusive modifications. 
> > 
> > How intrusive and non-modular is installing a DIE_INT3 notifier?
> 
> I'm not sure about all the reasons pro/con, but it looks like
> installing such a systemwide hook would force every userspace
> breakpoint or kprobe event machine wide to pass through the
> hypothetical uprobes layer, whether or not applicable to a current
> task.

Well, we'll have to pass through the global die notifier anyway, but a
quick per task filter sounds like a good idea, we can do that by keeping
a per-task count of the number of uprobes in use.

Then the uprobe code can avoid the lookup if there are no task users and
no global users.

The advantage of this construct is that is easily allows for global
users, whereas a utrace based one doesn't.



