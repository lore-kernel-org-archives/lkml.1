Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZIQUhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZIQUhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZIQUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZIQUhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:37:21 -0400
Date: Thu, 17 Sep 2009 22:32:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Roland McGrath <roland@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: do_wait() changes && 2.6.32 -mm merge plans
Message-ID: <20090917203248.GB29346@redhat.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915161535.db0a6904.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Andrew Morton wrote:
>
> ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
> do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
> #do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch: busted (KAMEZAWA)
> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch

Hopefully the problem with this one is fixed, thanks again to Kamezawa.

> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
> do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
> do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
> do_wait-wakeup-optimization-simplify-task_pid_type.patch
> #do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch: risky?
> do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

Yes, risky... God knows who can do list_for_each(->children) and expect to
find the sub-threads. But this is obviously good optimization/simplification.

It is just ugly to place sub-threads on ->children list, this buys nothing
but slown downs do_wait(). (this was needed, afaics, to handle ptraced but
not re-parented threads a long ago).

> wait_consider_task-kill-parent-argument.patch
> do_wait-fix-sys_waitid-specific-behaviour.patch
> wait_noreap_copyout-check-for-wo_info-=-null.patch
>
>   ptrace.  Mostly-merge.

Only the first patch is "ptrace" ;)

Oleg.

