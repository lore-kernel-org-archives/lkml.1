Return-Path: <linux-kernel-owner+w=401wt.eu-S1765304AbXJQJaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765304AbXJQJaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbXJQJ3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:29:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38321 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbXJQJ3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:29:53 -0400
Subject: Re: [patch] sched: schedstat needs a diet
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071017072323.GB18044@elte.hu>
References: <b040c32a0710161337l24d61d45h61be0ded72b54a9f@mail.gmail.com>
	 <20071017072323.GB18044@elte.hu>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 11:29:47 +0200
Message-Id: <1192613387.27435.114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 09:23 +0200, Ingo Molnar wrote:
> * Ken Chen <kenchen@google.com> wrote:
> 
> > schedstat is useful in investigating CPU scheduler behavior.  Ideally, 
> > I think it is beneficial to have it on all the time.  However, the 
> > cost of turning it on in production system is quite high, largely due 
> > to number of events it collects and also due to its large memory 
> > footprint.
> > 
> > Most of the fields probably don't need to be full 64-bit on 64-bit 
> > arch.  Rolling over 4 billion events will most like take a long time 
> > and user space tool can be made to accommodate that.  I'm proposing 
> > kernel to cut back most of variable width on 64-bit system.  (note, 
> > the following patch doesn't affect 32-bit system).
> 
> thanks, applied.
> 
> note that current -git has a whole bunch of new schedstats fields in 
> /proc/<PID>/sched which can be used to track the exact balancing 
> behavior of tasks. It can be cleared via echoing 0 to the file - so 
> overflow is not an issue. Most of those new fields should probably be 
> unsigned int too. (they are u64 right now.)
> 

FWIW I can't see how this patch saves a _lot_ of space. The stats are
per domain or per rq, neither are things that have a lot of instances.

That said, I have no actual objection to the patch, just not getting it.


