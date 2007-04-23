Return-Path: <linux-kernel-owner+w=401wt.eu-S1161196AbXDWSUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161196AbXDWSUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXDWSUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:20:23 -0400
Received: from mail.screens.ru ([213.234.233.54]:49220 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161196AbXDWSUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:20:22 -0400
Date: Mon, 23 Apr 2007 22:20:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] kthread: Spontaneous exit support
Message-ID: <20070423182014.GA243@tv-sign.ru>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org> <20070422194455.GA18561@infradead.org> <m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com> <20070423112537.GA21941@infradead.org> <20070423165810.GA188@tv-sign.ru> <m1mz0zvvao.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mz0zvvao.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Eric W. Biederman wrote:
>
> So I propose we add a kthread_orphan as a basic primitive to decrement the
> count on the task_struct if we want a kthread to simply exit after it
> has done some work.
> 
> And as a helper function we can have a kthread_run_orphan.

Speaking about helpers, could we also add kthread_start(), which should be
used instead of direct wake_up_process() ? Not that it is terribly important,
but still.

Note that "kthread_create() pins the task_struct" allows us to cleanup the code.
Look at this ugly "wait_to_die:" label in migration_thread(). Is is because
migration_thread() can't exit until CPU_DEAD reaps it. Other reasons were already
solved by kthread-enhance-kthread_stop-to-abort-interruptible-sleeps.patch

Oleg.

