Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbZLKNxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbZLKNxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZLKNxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:53:50 -0500
Received: from www.tglx.de ([62.245.132.106]:37899 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267AbZLKNxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:53:48 -0500
Date: Fri, 11 Dec 2009 14:52:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Howells <dhowells@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [patch 4/9] oom: Add missing rcu protection of __task_cred() in
 dump_tasks
In-Reply-To: <13284.1260539371@redhat.com>
Message-ID: <alpine.LFD.2.00.0912111452360.3089@localhost.localdomain>
References: <20091210004703.148689096@linutronix.de> <20091210001308.247025548@linutronix.de> <13284.1260539371@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, David Howells wrote:

> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > +		/* Protect __task_cred() access */
> > +		rcu_read_lock();
> >  		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
> >  		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
> >  		       get_mm_rss(mm), (int)task_cpu(p), p->signal->oom_adj,
> >  		       p->comm);
> > +		rcu_read_unlock();
> 
> No.  If there's only one access to __task_cred() like this, use
> task_cred_xxx() or one of its wrappers instead:
> 
> -		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
> +		       p->pid, task_uid(p), p->tgid, mm->total_vm,
> 
> that limits the size of the critical section.

Fair enough.

     tglx
