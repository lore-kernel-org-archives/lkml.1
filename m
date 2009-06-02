Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZFBEuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZFBEuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbZFBEuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:50:18 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34563 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZFBEuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:50:17 -0400
Date: Mon, 1 Jun 2009 21:48:32 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090602044832.GA8219@us.ibm.com>
References: <20090525185502.GA20781@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525185502.GA20781@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| If the non-traced sub-thread calls do_notify_parent_cldstop(), we send the
| notification to group_leader->real_parent and we report group_leader's pid.
| 
| But, if group_leader is traced we use the wrong ->parent->nsproxy->pid_ns,
| the tracer and parent can live in different namespaces. Change the code
| to use "parent" instead of tsk->parent.
| 
| Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

| 
| --- PTRACE/kernel/signal.c~CLDSTOP_NS	2009-05-25 20:24:50.000000000 +0200
| +++ PTRACE/kernel/signal.c	2009-05-25 20:33:37.000000000 +0200
| @@ -1496,7 +1496,7 @@ static void do_notify_parent_cldstop(str
|  	 * see comment in do_notify_parent() abot the following 3 lines
|  	 */
|  	rcu_read_lock();
| -	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
| +	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
|  	info.si_uid = __task_cred(tsk)->uid;
|  	rcu_read_unlock();
| 
