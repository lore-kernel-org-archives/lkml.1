Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0CCQrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:47:09 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43770 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754207Ab0CCQrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:47:05 -0500
Date: Wed, 3 Mar 2010 17:59:44 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sched: enforce per-cpu utilization limits on runtime
 balancing
Message-ID: <20100303165944.GN2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
 <1267129704.22519.560.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267129704.22519.560.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, Feb 25, 2010 09:28:24PM +0100
>
> On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> > +static inline void double_spin_lock(raw_spinlock_t *lock1,
> > +                                   raw_spinlock_t *lock2)
> > +       __acquires(lock1)
> > +       __acquires(lock2)
> > +{
> > +       if (lock1 < lock2) {
> > +               raw_spin_lock(lock1);
> > +               raw_spin_lock_nested(lock2, SINGLE_DEPTH_NESTING);
> > +       } else {
> > +               raw_spin_lock(lock2);
> > +               raw_spin_lock_nested(lock1, SINGLE_DEPTH_NESTING);
> > +       }
> > +}
> > +
> > +static inline void double_spin_unlock(raw_spinlock_t *lock1,
> > +                                     raw_spinlock_t *lock2)
> > +       __releases(lock1)
> > +       __releases(lock2)
> > +{
> > +       raw_spin_unlock(lock1);
> > +       lock_set_subclass(&lock2->dep_map, 0, _RET_IP_);
> > +       raw_spin_unlock(lock2);
> > +} 
> 
> If you release both there is no need to re-set the subclass.

Will fix, thanks.
