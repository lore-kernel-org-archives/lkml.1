Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYJCQXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYJCQXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYJCQXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:23:16 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59353 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbYJCQXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:23:15 -0400
Date: Fri, 3 Oct 2008 20:29:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] signal, procfs: lock_task_sighand() do not need rcu_read_lock()
Message-ID: <20081003162915.GA624@tv-sign.ru>
References: <48E5ED4D.4030102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E5ED4D.4030102@cn.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Lai Jiangshan wrote:
>
> lock_task_sighand() make sure task->sighand is being protected,
> so we do not need rcu_read_lock().
> [ exec() will get task->sighand->siglock before change task->sighand! ]
>
> But code using rcu_read_lock() _just_ to protect lock_task_sighand()
> only appear in procfs. (and some code in procfs use lock_task_sighand()
> without such redundant protection.)

Yes, the patch looks correct.

The initial implementaion of lock_task_sighand() did not take RCU lock,
that is why we still have the callers which call rcu_read_lock().
See 1406f2d321bae5ac5ff729dcb773336d9c05ec74.

Thanks!

Oleg.

