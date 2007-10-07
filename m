Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXJGN0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXJGN0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 09:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXJGN0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 09:26:43 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60655 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXJGN0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 09:26:42 -0400
To: junwang1234@gmail.com, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Sleeping in RCU list traversal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1191784307.3618.8.camel@localhost.localdomain>
In-Reply-To: <1191784307.3618.8.camel@localhost.localdomain>
Message-Id: <200710072226.EJF51558.LFVHJOStFOOFMQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 7 Oct 2007 22:26:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for pointing out.

Jun WANG wrote:
> >rcu_read_lock();
> >list_for_each_rcu(p, ...) {
> >   ptr = list_entry(p, struct ..., list);
> >   /* Grab a reference to "ptr". */
> >   rcu_read_unlock();
> >   my_task_that_may_sleep(ptr);
> >   rcu_read_lock();
> >   /* Drop a reference to "ptr". */
> > }
> > rcu_read_unlock();
> 
> In Document/RCU/whatisRCU.txt
> Note that the value returned by rcu_dereference() is valid
> 	only within the enclosing RCU read-side critical section.
Excuse me, but I think "p" is used only between rcu_read_lock() and rcu_read_unlock().
Is it illegal to use "ptr" after rcu_read_unlock() if "ptr" is obtained before rcu_read_unlock() ?

Regards.

