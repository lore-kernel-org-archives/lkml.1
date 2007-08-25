Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbXHYQX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbXHYQX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 12:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXHYQXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 12:23:17 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53586 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXHYQXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 12:23:17 -0400
Date: Sat, 25 Aug 2007 20:26:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cliff Wickman <cpw@sgi.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: cpuset: attach_task() vs sched_setaffinity() race?
Message-ID: <20070825162606.GA2630@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After the brief look at kernel/cpuset.c, it seems that attach_task() should
guarantee that the task can't use CPUs outside of cpuset->cpus_allowed.

But this looks racy wrt sched_setaffinity() which does

	cpus_allowed = cpuset_cpus_allowed(p);
	// callback_mutex is free
	set_cpus_allowed(p);

What if attach_task()->set_cpus_allowed() happens in between?


Another question: update_cpumask(cs) does nothing with the tasks attached to
that cpuset, why? It may take a while before the task actually migrates to the
new CPU.

Thanks,

Oleg.

