Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbZKOXk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbZKOXk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZKOXk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:40:26 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33735 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZKOXk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TLCOFBEhvluRHFKgJxjHW4uYsKkABuPYKU7L8pzn4sEoQSVQKa3ajypLIxfiP/iKHi
         eKz7XwDzOjJa7Q/LGuij3mOMxFX3ZgMpMJeozwPycTO4KGalFYRbP5ujAeXv+Kax2oVB
         pWlSEMXM0Qf2qADlzQVBLGAO8WBg119Dehdik=
Date: Mon, 16 Nov 2009 00:40:33 +0100
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
Message-ID: <20091115234031.GB6090@nowhere>
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <20091111171703.GA28506@redhat.com> <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain> <20091115233703.GA6090@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091115233703.GA6090@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 12:37:06AM +0100, Frederic Weisbecker wrote:
> On Thu, Nov 12, 2009 at 06:33:00PM +0100, Thomas Gleixner wrote:
> > @@ -145,6 +255,7 @@ static void __queue_work(struct cpu_work
> >  {
> >  	unsigned long flags;
> >  
> > +	debug_work_activate(work);
> >  	spin_lock_irqsave(&cwq->lock, flags);
> >  	insert_work(cwq, work, &cwq->worklist);
> 
> 
> 
> Since you are doing that from insert_wq_barrier too, which
> endpoint is also insert_work(), why not put debug_work_activate
> there instead? Or may be you really prefer to do this outside
> the spinlock (which in off-case is zero-overhead). May be that
> can sleep or?


/me now remembers this path can't sleep since we can queue a
work from anywhere...so I guess this is to not bloat the lock
overhead.

Whatever, this is really a small detail.

