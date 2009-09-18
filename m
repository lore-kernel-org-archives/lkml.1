Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZIRTTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZIRTTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZIRTTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:19:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbZIRTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:19:44 -0400
Date: Fri, 18 Sep 2009 12:17:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Wu Fei <at.wufei@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, arjan@infradead.org,
       jeremy@goop.org, mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
 kthreadd_task_init_done
In-Reply-To: <20090918185425.GA16620@redhat.com>
Message-ID: <alpine.LFD.2.01.0909181217270.4950@localhost.localdomain>
References: <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org>
 <20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu> <20090918163241.GA8556@desktop> <20090918185425.GA16620@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Oleg Nesterov wrote:
> >  	rcu_scheduler_starting();
> > -	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
> > -	numa_default_policy();
> >  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
> >  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
> > +	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
> 
> We can't do this. kernel_init() should run with ->pid == 1, we are
> going to exec /sbin/init.

Umm - why not just add CLONE_PID to the 'kthreadd' creation, then?

		Linus
