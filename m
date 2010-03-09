Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0CISH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:07:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0CISH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:07:57 -0500
Date: Tue, 9 Mar 2010 19:06:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Q: select_fallback_rq() && cpuset_lock()
Message-ID: <20100309180615.GA11681@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried to remove the deadlockable cpuset_lock() many times, but my
attempts were ignored by cpuset maintainers ;)

In particular, see http://marc.info/?l=linux-kernel&m=125261083613103

But now I have another question. Since 5da9a0fb673a0ea0a093862f95f6b89b3390c31e
cpuset_cpus_allowed_locked() is called without callback_mutex held by
try_to_wake_up().

And, without callback_mutex held, isn't it possible to race with, say,
update_cpumask() which changes cpuset->cpus_allowed? Yes, update_tasks_cpumask()
should fixup task->cpus_allowed later. But isn't it possible (at least
in theory) that try_to_wake_up() gets, say, all-zeroes in task->cpus_allowed
after select_fallback_rq()->cpuset_cpus_allowed_locked() if we race with
update_cpumask()->cpumask_copy() ?

Oleg.

