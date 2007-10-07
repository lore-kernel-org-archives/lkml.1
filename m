Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXJGQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXJGQ4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXJGQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:56:38 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64514 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbXJGQ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:56:37 -0400
To: junwang1234@gmail.com, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Sleeping in RCU list traversal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1191784307.3618.8.camel@localhost.localdomain>
	<200710072226.EJF51558.LFVHJOStFOOFMQ@I-love.SAKURA.ne.jp>
	<1191796640.3045.25.camel@localhost.localdomain>
In-Reply-To: <1191796640.3045.25.camel@localhost.localdomain>
Message-Id: <200710080156.IFB56934.tHMLFFJSFOVOOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 8 Oct 2007 01:56:30 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jun WANG wrote:
> I'm sorry,I think I got your idea, if you do not need ptr in
> my_task_that_may_sleep(), why you need to grab a reference to "ptr". If
> your my_task_that_may_sleep() needs ptr, and according to the 
> "memory region pointed by "ptr" never be removed." you say,
> it is ok to use "ptr" after rcu_read_ulock(). The basic idea behind RCU
> is to split updates into "removal" and "reclamation" phases. If you
> memory region pointed by "ptr" will not "reclamation" in sleep, it is ok
I need "ptr" in my_task_that_may_sleep(), but regarding my case,
memory region pointed by "ptr" will never be kfree()ed.

So, I don't need to grab a reference to "ptr"
because memory region pointed by "ptr" will never be kfree()ed.
And it is legal to use "ptr" after rcu_read_unlock()
because memory region pointed by "ptr" will never be kfree()ed.

Thank you.

