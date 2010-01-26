Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701Ab0AZQfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0AZQfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088Ab0AZQfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:35:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab0AZQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:35:16 -0500
Date: Tue, 26 Jan 2010 11:34:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Stezenbach <js@sig21.net>, Renzo Davoli <renzo@cs.unibo.it>,
       Mark Wielaard <mjw@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126163431.GA1658@infradead.org>
References: <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com> <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain> <20100125170254.GB22862@redhat.com> <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain> <1264451453.3028.59.camel@springer.wildebeest.org> <alpine.LFD.2.00.1001251236160.3574@localhost.localdomain> <20100126000237.GA15936@cs.unibo.it> <alpine.LFD.2.00.1001251605320.3574@localhost.localdomain> <20100126160811.GA3242@sig21.net> <alpine.LFD.2.00.1001260816000.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001260816000.3574@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 08:28:15AM -0800, Linus Torvalds wrote:
> I already said earlier that I'd be perfectly happy to merge utrace code, 
> as long as it was clear that I'm not merging a platform for crazy work. 
> IOW, the end result might be merging 99% of the code, but I want to set 
> peoples _expectations_ right. I'm not at all interested in merging stuff 
> that has various exported helper functions for people doing random things, 
> but I could happily merge stuff that cleans up internal implementation.

> Clean code makes things easier to improve, and maybe utrace cleans thigns 
> up. But defining new API's makes me very worried, and quite frankly, the 
> last thing I ever want to see is a new interface that out-of-tree modules 
> starr using for random hacking.

To be fair Roland and Oleg did a lot of work on improving ptrace support
that was an offsprint of utrace.  It would be great if the reamaining
architectures would catch up on beeing converted to it and getting rid
of the existing hairy arch ptrace code as much as possible.

I'm still not really set on utrace either, but the in-kernel gdbstub
Frank has started could be a real killer if it ever gets done up to
a fully usable state.  If it really requires all the utrace abstractions
that seem a bit overdone I'm not sure.  Might be a better idea to try to
get uprobes and the gdbstub in without it and see how much of the
abstraction will be needed anyway as a fallout, just without exporting
them to modules and thus actually making them published APIs.

