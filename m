Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZKOXhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZKOXhD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZKOXhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:37:02 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:35948 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZKOXhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T9kZDryHDh7ThIwA4IJyM//fEFBSGUFbKSWLPmX2RNlybnSDMNEGjsIS8izQd026KF
         t+hfU+Bb3g0sbeEebYF1hwEM9GJgk8zSo/V+vGerv8C3h5Ocodjsx4XR9vVX9o/Cldvz
         s2ZPllOZJX1atHizWQlzbZpc86e4WWeyrkxDI=
Date: Mon, 16 Nov 2009 00:37:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
	resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps
	related to preempt_count leakage in keventd)
Message-ID: <20091115233703.GA6090@nowhere>
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <20091111171703.GA28506@redhat.com> <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 06:33:00PM +0100, Thomas Gleixner wrote:
> @@ -145,6 +255,7 @@ static void __queue_work(struct cpu_work
>  {
>  	unsigned long flags;
>  
> +	debug_work_activate(work);
>  	spin_lock_irqsave(&cwq->lock, flags);
>  	insert_work(cwq, work, &cwq->worklist);



Since you are doing that from insert_wq_barrier too, which
endpoint is also insert_work(), why not put debug_work_activate
there instead? Or may be you really prefer to do this outside
the spinlock (which in off-case is zero-overhead). May be that
can sleep or?

