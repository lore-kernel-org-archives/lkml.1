Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZLARKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZLARKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZLARK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:10:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54491 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbZLARKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:10:06 -0500
Date: Tue, 1 Dec 2009 18:09:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091201170954.GA4699@elte.hu>
References: <1259582952.20516.209.camel@laptop>
 <20091130123257.GB18879@linux.vnet.ibm.com>
 <1259584907.20516.246.camel@laptop>
 <20091130131928.GC18879@linux.vnet.ibm.com>
 <1259588232.20516.307.camel@laptop>
 <20091130150314.GA10331@redhat.com>
 <20091130151650.GA24316@elte.hu>
 <20091130152910.GB10331@redhat.com>
 <20091201161132.GA24897@elte.hu>
 <20091201170002.GD10331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201170002.GD10331@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Hi -
> 
> On Tue, Dec 01, 2009 at 05:11:32PM +0100, Ingo Molnar wrote:
>
> > Those facilities are not overlapping with kgdb though so my point 
> > doesnt apply to them. An in-kernel gdb server sure overlaps/extends 
> > kgdb though.
> 
> Only in name.  One is highly invasive, for debugging the kernel across 
> serial consoles.  The other is highly noninvasive, for debugging user 
> processes across normal userspace channels.  They both happen to talk 
> to gdb, but that's the end of the natural "overlap".
> 
> Even if kgdb was extended to be able to manage userspace, and if gdb 
> itself was extended to be able to use that same single channel, this 
> would still not duplicate the use scenario for an ordinary user 
> debugging his own processes.
> 
> (Plus, in the future where at least gdb is applied toward kernel+user 
> debugging, it is unlikely to be the case that this would need to be 
> done *over a single channel*.  A separate channel for kernel and 
> separate channels for userspace programs are no less likely.)

Well nothing that you mention here changes our obvious suggestion that 
an in-kernel gdb stub should obviously either be a kgdb extension, or a 
replacement of it. We dont want to separate facilities for the same 
conceptual thing: examining application state (be that in user-space and 
kernel-space).

> > Btw., perf does meet that definition: it functionally replaces all 
> > facilities that it overlaps/extends - such as Oprofile. [...]
> 
> (And they currently separately coexist.)

You didnt get my point apparently. Keeping the overlapped facility for 
compatibility (and general user inertia) is fine. Creating a new 
facility that doesnt do everything that the existing facility does, and 
not integrating it either, is not fine.

Which was both Peter's and my point really.

	Ingo
