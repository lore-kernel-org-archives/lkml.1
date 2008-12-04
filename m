Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYLDNHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYLDNHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYLDNHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:07:08 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56600 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbYLDNHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:07:06 -0500
Subject: Re: [PATCH 2/3] ftrace: use struct pid
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1228395378.13111.23.camel@nimitz>
References: <20081204052638.425740534@goodmis.org>
	 <20081204052735.175697908@goodmis.org> <m1d4g8un6b.fsf@frodo.ebiederm.org>
	 <1228395378.13111.23.camel@nimitz>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 05:07:02 -0800
Message-Id: <1228396022.13111.27.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 04:56 -0800, Dave Hansen wrote:
> On Thu, 2008-12-04 at 04:42 -0800, Eric W. Biederman wrote:
> > 
> > > +static void clear_ftrace_pid_task(struct pid **pid)
> > > +{
> > > +     struct task_struct *p;
> > > +
> >         rcu_read_lock();
> > 
> > > +     do_each_pid_task(*pid, PIDTYPE_PID, p) {
> > > +             clear_tsk_trace_trace(p);
> > > +     } while_each_pid_task(*pid, PIDTYPE_PID, p);
> >         rcu_read_unlock()
> > 
> > > +     put_pid(*pid);
> > > +
> > > +     *pid = NULL;
> > > +}
> 
> Could we get away with sticking the rcu_read_{un}lock() inside those
> macros?  Those are going to get used in pretty high level code and we're
> allowed to nest rcu_read_lock().  No danger of deadlocks or lock
> inversions.

Why don't any of the other users of do_each_pid_task() use
rcu_read_lock()?  They all seem to be under read_lock(&tasklist_lock)
(except one is under a write lock of the same).

-- Dave

