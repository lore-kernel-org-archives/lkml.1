Return-Path: <linux-kernel-owner+w=401wt.eu-S938188AbXG3P7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938188AbXG3P7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbXG3P7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:59:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:12546 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbXG3P7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:59:46 -0400
Subject: Re: [PATCH -rt 1/9] preempt rcu: check for underflow
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070730092211.GA25640@elte.hu>
References: <20070730024534.369897977@mvista.com>
	 <20070730092211.GA25640@elte.hu>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 08:48:48 -0700
Message-Id: <1185810528.2636.17.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 11:22 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > +	/*
> > +	 * If our rcu_read_lock_nesting went negative, likely
> > +	 * something is wrong..
> > +	 */
> > +	WARN_ON(current->rcu_read_lock_nesting < 0);
> 
> have you actually caught any rcu locking problem this way? Double 
> unlocks should be caught by lockdep already, at a higher level.
> 
> in any case i've added a slightly different form of this change to the 
> -rt queue that will also check for counter overflows. But i'm not sure 
> we want to litter the code with trivial checks like this, so i'm keeping 
> it separate and if it does not trigger anything real i'll remove it.

I haven't caught anything with it, but this code would have made it much
easier to catch the single rcu unlock in sys_sched_yield() which was
silent in PREEMPT_RT, and hung !PREEMPT_RT ..

It's fine with me, if you have another method.

Daniel

