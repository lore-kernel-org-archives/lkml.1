Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbYLDM4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbYLDM4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYLDM4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:56:23 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60343 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYLDM4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:56:22 -0500
Subject: Re: [PATCH 2/3] ftrace: use struct pid
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <m1d4g8un6b.fsf@frodo.ebiederm.org>
References: <20081204052638.425740534@goodmis.org>
	 <20081204052735.175697908@goodmis.org>  <m1d4g8un6b.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 04:56:18 -0800
Message-Id: <1228395378.13111.23.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 04:42 -0800, Eric W. Biederman wrote:
> 
> > +static void clear_ftrace_pid_task(struct pid **pid)
> > +{
> > +     struct task_struct *p;
> > +
>         rcu_read_lock();
> 
> > +     do_each_pid_task(*pid, PIDTYPE_PID, p) {
> > +             clear_tsk_trace_trace(p);
> > +     } while_each_pid_task(*pid, PIDTYPE_PID, p);
>         rcu_read_unlock()
> 
> > +     put_pid(*pid);
> > +
> > +     *pid = NULL;
> > +}

Could we get away with sticking the rcu_read_{un}lock() inside those
macros?  Those are going to get used in pretty high level code and we're
allowed to nest rcu_read_lock().  No danger of deadlocks or lock
inversions.

-- Dave

