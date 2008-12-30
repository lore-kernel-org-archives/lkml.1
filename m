Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYL3IWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYL3IWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYL3IWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:22:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbYL3IWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:22:07 -0500
Date: Tue, 30 Dec 2008 09:21:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] RCU: Don't include unnecessary headers, allow
	kmemtrace w/ tracepoints.
Message-ID: <20081230082153.GB17629@elte.hu>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro> <20081230074952.GA5482@elte.hu> <20081230075337.GA9594@elte.hu> <20081230081445.GC10635@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230081445.GC10635@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Tue, Dec 30, 2008 at 08:53:37AM +0100, Ingo Molnar wrote:
> > hm, there are quite a few such dependencies it appears, for example:
> > 
> > In file included from init/do_mounts_initrd.c:4:
> > include/linux/fs.h: In function 'alloc_secdata':
> > include/linux/fs.h:2214: error: implicit declaration of function 'get_zeroed_page'
> > include/linux/fs.h:2214: error: 'GFP_KERNEL' undeclared (first use in this function)
> > include/linux/fs.h:2214: error: (Each undeclared identifier is reported only once
> > include/linux/fs.h:2214: error: for each function it appears in.)
> > include/linux/fs.h: In function 'free_secdata':
> > include/linux/fs.h:2219: error: implicit declaration of function 
> > 'free_page'
> > In file included from include/linux/slab.h:13,
> >                  from include/linux/percpu.h:6,
> >                  from include/linux/percpu_counter.h:14,
> >                  from include/linux/ext2_fs_sb.h:21,
> >                  from include/linux/ext2_fs.h:70,
> >                  from init/do_mounts_initrd.c:6:
> > 
> > config attached.
> > 
> > 	Ingo
> 
> Hm, that's weird, I was also testing on a 2.6.28-based tree. And I don't 
> see any reference to RCU headers in this error message. My guess is some 
> code assumes a certain header provides some definitions it isn't 
> required to.
> 
> I'll checkout your tree and have a look.

note: you'll need to apply your patch ontop of tip/master, i moved it out 
of tip/master for now due to the build breakage. Let me know if you cannot 
reproduce the problem, i'll then figure out what's going on.

	Ingo
