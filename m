Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0CCQqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:46:51 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43726 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754881Ab0CCQqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:46:48 -0500
Date: Wed, 3 Mar 2010 17:59:26 +0100
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
Message-ID: <20100303165926.GM2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
 <1267129702.22519.558.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267129702.22519.558.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, Feb 25, 2010 09:28:22PM +0100
>
> On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> > +               /*
> > +                * Make sure that before restarting balancing everyone
> > +                * sees the new free bandwidth.
> > +                */
> > +               smp_wmb(); 
> 
> You cannot order something on its own, barriers come in pairs, where is
> his?

It was coupled with the acquire barrier implied by the spin_lock(rt_b)
in the balance path, as the other wmb() before starting the reset (more
details on the reply about this last barrier, as per your comment they
can be removed).
