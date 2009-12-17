Return-Path: <linux-kernel-owner+w=401wt.eu-S935093AbZLQK0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbZLQK0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761424AbZLQK0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:26:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZLQK0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:26:41 -0500
Subject: Re: [PATCH 2/2] perf lock: Fix output of tracing lock events
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20091217100922.GA23778@elte.hu>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1261041885.27920.110.camel@laptop>  <20091217100922.GA23778@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 11:26:14 +0100
Message-ID: <1261045574.27920.179.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 11:09 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > >  	TP_STRUCT__entry(
> > > +		__field(struct lockdep_map *, lockdep_addr)
> > >  		__field(unsigned int, flags)
> > >  		__string(name, lock->name)
> > >  	),
> > 
> > I feel a bit awkward explicitly leaking kernel pointers like that. All this 
> > is accessible by root only (for now) so its not too harmfull, but sitll.
> 
> What would you suggest as a 'natural lock class key'? The name? It might not 
> be unique enough.
> 
> Other kernel objects like tasks, cpus, inodes, pages all have some natural key 
> that isnt a kernel pointer - but locks are a bit special.

Well, yeah, that's the problem, and we use the pointer for exactly this
purpose inside the kernel too, its just that its a blatant data leak
when we expose it to userspace like that.

On the other hand, adding some ID generation just so we can expose it
seems silly too.

Why do we need to have instance resolution?

