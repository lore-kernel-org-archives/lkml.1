Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZKMJzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZKMJzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbZKMJzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:55:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57153 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769AbZKMJzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:55:49 -0500
Date: Fri, 13 Nov 2009 10:55:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.32-rc6] sched, kvm: fix race condition involving
 sched_in_preempt_notifers
Message-ID: <20091113095516.GD1364@elte.hu>
References: <4AFD2801.7020900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFD2801.7020900@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> In finish_task_switch(), fire_sched_in_preempt_notifiers() is called
> after finish_lock_switch().  However, depending on architecture,
> preemption can be enabled after finish_lock_switch() which breaks the
> semantics of preempt notifiers.  Move it before finish_arch_switch().
> This also makes in notifiers symmetric to out notifiers in terms of
> locking - now both are called under rq lock.
> 
> NOT_SIGNED_OFF_YET
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Avi Kivity <avi@redhat.com>
> ---
> Avi, I think kvm should be fine with this but I haven't tested it.
> Does this look okay to you?  If so, can you please route this through
> kvm tree with my signoff?

I'd like to have Avi's Ack for it, but we want to do sched.c changes via 
the scheduler tree.

	Ingo
