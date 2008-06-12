Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYFLFTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYFLFTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYFLFTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:19:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:45600 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYFLFTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:19:20 -0400
Date: Thu, 12 Jun 2008 14:18:28 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [PATCH -mm] add a helper function to test if an object is on
 the stack
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080610225236.5d698871.akpm@linux-foundation.org>
References: <1213150485-25584-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080610225236.5d698871.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080612141311O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 22:52:36 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 11 Jun 2008 11:14:45 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > lib/debugobjects.c has a function to test if an object is on the
> > stack. The block layer and ide needs it (they need to avoid DMA
> > from/to stack buffers). This patch moves the function to
> > include/linux/sched.h so that everyone can use it.
> > 
> > lib/debugobjects.c uses current->stack but this patch uses a
> > task_stack_page() accessor, which is a preferable way to access to
> > stack.
> > 
> 
> Seems reasonable.
> 
> > ---
> >  include/linux/sched.h |    7 +++++++
> >  lib/debugobjects.c    |    4 +---
> >  2 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 4efb39b..799bbdd 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1978,6 +1978,13 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
> >  
> >  #endif
> >  
> > +static inline int object_is_on_stack(void *obj)
> > +{
> > +	void *stack = task_stack_page(current);
> 
> Are we sure that this will work if !defined __HAVE_THREAD_FUNCTIONS?

If !defined __HAVE_THREAD_FUNCTIONS, we use the following macro in
sched.h:

#define task_stack_page(task)	((task)->stack)

So it works.
