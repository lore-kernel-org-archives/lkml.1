Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0BJR5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:57:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab0BJR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:57:42 -0500
Date: Wed, 10 Feb 2010 09:57:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, oleg@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Update comment on find_task_by_pid_ns
Message-Id: <20100210095710.c7b124f7.akpm@linux-foundation.org>
In-Reply-To: <20100210163033.GA12251@us.ibm.com>
References: <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
	<201002082130.JDC57339.OHOVJFQtFSLFMO@I-love.SAKURA.ne.jp>
	<20100208132101.GA7129@redhat.com>
	<alpine.LFD.2.00.1002081802510.2811@localhost.localdomain>
	<20100208171643.GA19230@redhat.com>
	<201002090642.EBE48414.HLJVFOQFSOFOMt@I-love.SAKURA.ne.jp>
	<20100209140818.43bb9770.akpm@linux-foundation.org>
	<20100210163033.GA12251@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010 10:30:33 -0600 "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Tue, 9 Feb 2010 06:42:45 +0900
> > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > 
> > > OK. I updated description.
> > > 
> > > As of 2.6.32 , below users are missing rcu_read_lock().
> > > 
> > > Users missing rcu_read_lock() when calling find_task_by_vpid():
> > > 
> > >   SYSCALL_DEFINE3(ioprio_set) in fs/ioprio.c
> > >   SYSCALL_DEFINE2(ioprio_get) in fs/ioprio.c
> > >   cap_get_target_pid() in kernel/capability.c
> > 
> > Actually, cap_get_target_pid() uses rcu_read_lock() and doesn't take
> > tasklist_lock.
> 
> Hmm - is that in -mm?  In my copy here it takes read_lock(&tasklist_lock)

yup.  It got changed in linux-next.

> And I'll admit I'm a bit confused as to the current state of things:
> do I understand correctly that we now need to take both the tasklist_lock
> and rcu_read_lock?  (Presumably only for read_lock()?)

Beats me.  We need to protect both the pid->task_struct lookup data
structures (during the lookup) and protect the resulting task_struct
while the caller is playing with it.  It's unclear whether
rcu_read_lock() suffices for both purposes.


