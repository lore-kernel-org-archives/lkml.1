Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZBDAPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZBDAPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZBDAPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:15:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48862 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZBDAPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:15:36 -0500
Date: Wed, 4 Feb 2009 01:12:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: do_each_pid_task() needs rcu lock
Message-ID: <20090204001243.GA6567@redhat.com>
References: <20090203193904.GA23695@redhat.com> <20090203194214.GA23703@redhat.com> <m1fxivw673.fsf@fess.ebiederm.org> <20090203222803.GA31756@redhat.com> <m1zlh3umho.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlh3umho.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Yes, I thought about de_thread() too. But we can't "fix" do_each_pid_task()
> > to avoid the race?
>
> For the case of exec there is that.  There is also the case that
> ftrace unlike everything else wants to trace be able to trace all of
> the idle threads with pid 0.  I think that is a special case
> currently, but for that case the only correct version I can think
> of do_each_task_pid(), and current do_each_task_pid is wrong because
> it does not allow that.

Well, yes, I (partly) agree.

But, if we are talking about idle threads, we should change copy_process()
first. Because fork_idle()->copy_process(..., pid => init_struct_pid, ...)
means we don't really attach the idle thread to init_struct_pid.

I must admit, I think we should keep init_struct_pid "special" anyway,
but in any case you are right imho, there are nasty oddities here.

Oleg.

