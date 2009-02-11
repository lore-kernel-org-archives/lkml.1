Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZBKPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZBKPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZBKPYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:24:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46168 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbZBKPYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:24:01 -0500
Date: Wed, 11 Feb 2009 16:23:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pengfei Hu <hpfei.cn@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Using module private memory to simulate microkernel's memory
	protection
Message-ID: <20090211152342.GA16550@elte.hu>
References: <a5f59d880902100542x7243b13fuf40e7dd21faf7d7a@mail.gmail.com> <20090210141405.GA16147@elte.hu> <a5f59d880902110604g40cf17b5w92431f60e6f16fa4@mail.gmail.com> <20090211145525.GB10525@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211145525.GB10525@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Pengfei Hu <hpfei.cn@gmail.com> wrote:
> 
> > >
> > > Hm, are you aware of the kmemcheck project?
> > >
> > >        Ingo
> > >
> > 
> > Frankly, I only know this project's name. Just when I nearly finished
> > this patch, I browsed http://git.kernel.org/ first time. I am only a
> > beginner in Linux kernel. Maybe I should first discuss before write
> > code. But I think it is not too late.
> > 
> > Can you tell me more about this project? I realy appreciate it.
> 
> Sure:

More info: kmemcheck was written by Vegard Nossum (and released more than
a year ago) and it uses similar principles as your patch: it enforces
memory usage constraints via pagetable access bits.

More description about kmemcheck can be found in the following LWN article:

  http://lwn.net/Articles/260068/

I think your idea of limiting execution to individual modules could perhaps
be combined with kmemcheck. It's the same general principle.

The difference is that your patch calls back from the page fault handler and
modifies the monitored pte's to present, brings in a TLB and then it modifies
it to not present. So the page can be accessed up until the TLB gets flushed.

Kmemcheck uses debug traps to execute a single instruction, and thus gets
finer grained control of what is visible to a task.

	Ingo
