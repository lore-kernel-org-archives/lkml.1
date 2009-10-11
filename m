Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbZJKMWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbZJKMWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZJKMWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:22:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZJKMWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:22:09 -0400
Date: Sun, 11 Oct 2009 08:21:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091011122129.GA16701@infradead.org>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere> <20091006152106.GA6490@infradead.org> <20091011085345.GE14995@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011085345.GE14995@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 10:53:45AM +0200, Ingo Molnar wrote:
> And you were full of it back then and you are full of it now as well.

Beeing nice today, eh? :)

> Of course tools/perf/ can be dependent on the kernel source, as long as 
> it's all exposed cleanly. Runtime exposure of information is better of 
> course in many cases, but there's a balance to be stricken.
> 
> We already have deep and good dependencies between kernel code and 
> tools/perf: for example we use the kernel's list.h and lib/rbtree.c in 
> perf and those facilities are God-sent over user-space crap that for 
> example Glist is.

Re-using code is no problem at all.  If you look at typical lowlevel
userspace code written by kernel developers you'll notice that they
usually use the kernel data structures, too.  And yeah, glib is
quite horrible.

The problem is run-time depdency on the kernel it was built with.  It's
not practival or desirable to have one perf binary per kernel version.

> I tend to agree that softirq names might make sense to expose runtime as 
> well, but that is totally independent of your _idiotic_ argument that 
> this issue somehow talks against perf being part of the kernel source.

It is directly related.  If you ship perf as part of the kernel source
these kinds of thing slip in easily, just because people don't think
about it enough.  If you have a separate source tree it's much more
clear that you can't depend on internal implementation details.

