Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZIRH3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZIRH3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZIRH3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:29:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:42828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZIRH3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:29:12 -0400
Subject: Re: suspend a thread with an another thread
From: Peter Zijlstra <peterz@infradead.org>
To: maxime louvel <m.louvel@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <dda529d0909172353u6ec2c59ele6467617078f726d@mail.gmail.com>
References: <dda529d0909172353u6ec2c59ele6467617078f726d@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Sep 2009 09:29:27 +0200
Message-Id: <1253258967.8439.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 08:53 +0200, maxime louvel wrote:
> HI all,
> 
> I'm doing a phd related to QoS and resources management within
> distributed systems.
> I would like to affect a CPU budget to my applications, one
> application being a thread.
> 
> As I would like to experiment quickly my ideas in order to test them,
> I wanted to use a little trick :
> instead of modifying the linux scheduler (which I guess will take me a
> lot of time because I'm not familiar with it) I tried to use a "super
> thread".

Kernel thread or userspace? I read the below as if you're meaning
user-space, since you talk about pthread stuff (at which point this
mailing list is off-topic).

> My try was that this "super thread" with higher priority is suspending
> the other threads if they overcome their cpu budget.
> I thought of something like activate an application thread, make the
> super thread sleep for X time (cpu budget) and then wake up and
> suspend the application thread until next time.
> 
> However I haven't been able to do that because I've read (and test
> myself :) ) that :
> - it is not possible to suspend a thread by an another thread (I don't
> think I can use the pthread_cond facilities)

No, pthread_cond() is for waiting for an event to occur.

> - as threads within a process share the signals and signal handlers I
> can't send a signal (like SIGUSR1 or SIGSTOP) to a specific thread.
> Correct me if I'm wrong

try: man pthread_kill

> Or should I start by looking at how to modify the linux scheduler ?

Depends on what you want to do... how hard can it be right ;-)
