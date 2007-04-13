Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXDMVbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXDMVbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030502AbXDMVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:31:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030490AbXDMVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:31:36 -0400
Date: Fri, 13 Apr 2007 14:31:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make kthread_create() more scalable
Message-Id: <20070413143104.99a1eeb9.akpm@linux-foundation.org>
In-Reply-To: <20070413130201.GA170@tv-sign.ru>
References: <20070413130201.GA170@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 17:02:01 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> If kernel_thread(kthread) succeeds, kthread() can not fail on its path to
> complete(&create->started) + schedule(). After that it can't be woken because
> nobody can see the new task yet. This means:
> 
> 	- we don't need tasklist_lock for find_task_by_pid().
> 
> 	- create_kthread() doesn't need to wait for create->started. Instead,
> 	  kthread_create() first waits for create->created to get the result of
> 	  kernel_thread(), then waits for create->started to synchronize with
> 	  kthread().

Why don't we need tasklist_lock for find_task_by_pid()?  I'd have though that
we'd at least need rcu_read_lock(), and I'm not sure that the implicit
understanding of pid-management internals here is a great idea.
