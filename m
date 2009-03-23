Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbZCWUpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbZCWUpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZCWUpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:45:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbZCWUpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:45:40 -0400
Date: Mon, 23 Mar 2009 13:39:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
In-Reply-To: <20090323202503.GD18774@redhat.com>
Message-ID: <alpine.LFD.2.00.0903231334500.3030@localhost.localdomain>
References: <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com>
 <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321214852.GA5262@redhat.com> <20090322120811.GD19826@elte.hu> <20090323202503.GD18774@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Mar 2009, Frank Ch. Eigler wrote:
> > I have CONFIG_DEBUG_INFO turned off in 99.9% of my kernel builds, 
> > because it slows down the kernel build times significantly: [...]
> 
> OK, 15% longer time.

It's way more than that if you don't have tons of memory and excessive 
amounts of CPU power.

> > 2)
> > 
> > When the kernel build becomes IO-bound [...]
> >   without:   870.36 user 292.79 system 3:32.10 elapsed  548% CPU
> >   with:      929.65 user 384.55 system 8:28.70 elapsed  258% CPU
> 
> OK, lots of network traffic.

This is the _normal_ situation for a debug info build.  If it's not 
network traffic (distcc), it's just disk IO. Have you tried it on a 
laptop? Ingo is not the only one that turns off DEBUG_INFO in disgust. 
It's totally useless for any sane kernel developer - the costs are 
excessive.

Adn that's totally ignoring the disk usage of multiple debug info kernels.

> Note that this backs away from earlier claims that we can make do
> without debuginfo, or that the compiler can't be trusted to build the
> stuff.  We all agree it'd be nice if made it better and made a little
> less.

Gaah. I'd wish you all agreed that DEBUG_INFO is just TOTALLY UNREALISTIC.

			Linus
