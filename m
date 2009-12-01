Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZLARpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZLARpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZLARpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:45:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbZLARpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:45:43 -0500
Date: Tue, 1 Dec 2009 12:45:34 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091201174534.GE10331@redhat.com>
References: <20091130123257.GB18879@linux.vnet.ibm.com> <1259584907.20516.246.camel@laptop> <20091130131928.GC18879@linux.vnet.ibm.com> <1259588232.20516.307.camel@laptop> <20091130150314.GA10331@redhat.com> <20091130151650.GA24316@elte.hu> <20091130152910.GB10331@redhat.com> <20091201161132.GA24897@elte.hu> <20091201170002.GD10331@redhat.com> <20091201170954.GA4699@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201170954.GA4699@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -  

> > Only in name.  One is highly invasive, for debugging the kernel across 
> > serial consoles.  The other is highly noninvasive, for debugging user 
> > processes across normal userspace channels.  They both happen to talk 
> > to gdb, but that's the end of the natural "overlap".
> [...]

> Well nothing that you mention here changes our obvious suggestion that 
> an in-kernel gdb stub should obviously either be a kgdb extension, or a 
> replacement of it.

Help me out here: by "kgdb extension" do you imagine "something new
that an unprivileged user can use to debug his own process"?  Or do
you imagine a new userspace facility that single-steps the kernel? 


> We dont want to separate facilities for the same conceptual thing:
> examining application state (be that in user-space and
> kernel-space).

This seems like a shallow sort of consistency.  kgdb was added after
ptrace existed -- why not extend ptrace instead to target the kernel?
After all, it's "examining application state".  The answer is that it
doesn't make a heck of a lot of sense.


> > > Btw., perf does meet that definition: it functionally replaces all 
> > > facilities that it overlaps/extends - such as Oprofile. [...]
> > 
> > (And they currently separately coexist.)
> 
> You didnt get my point apparently. Keeping the overlapped facility for 
> compatibility (and general user inertia) is fine. Creating a new 
> facility that doesnt do everything that the existing facility does, and 
> not integrating it either, is not fine.

oprofile and perfctr are closer in concept than kgdb and ptrace, yet
AFAIK perfctr doesn't "interface" to oprofile, except perhaps to the
extent of resolving contention over the underlying physical resources.
In any case this is not a great analogy.


- FChE
