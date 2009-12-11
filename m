Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZLKNrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZLKNrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbZLKNrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:47:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbZLKNrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:47:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091210004703.111906707@linutronix.de>
References: <20091210004703.111906707@linutronix.de> <20091210001308.247025548@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 3/9] proc: Add missing rcu protection for __task_cred() in task_sig()
Date: Fri, 11 Dec 2009 13:46:42 +0000
Message-ID: <13225.1260539202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> task_sig() accesses __task_cred() without being in a RCU read side
> critical section. tasklist_lock is not protecting that when
> CONFIG_TREE_PREEMPT_RCU=y.
> 
> Add a rcu_read_lock/unlock() section around the code which accesses
> __task_cred().
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David Howells <dhowells@redhat.com>
