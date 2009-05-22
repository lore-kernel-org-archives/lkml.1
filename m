Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZEVOnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZEVOnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZEVOnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:43:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51697 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZEVOni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:43:38 -0400
Date: Fri, 22 May 2009 16:36:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend4 3/3] itimers: simplify arm_timer() code a bit
Message-ID: <20090522163625.1e1dd8ce@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.0905221629080.3570@localhost.localdomain>
References: <20090522154349.396d9ea6@dhcp-lab-109.englab.brq.redhat.com>
	<alpine.LFD.2.00.0905221629080.3570@localhost.localdomain>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 16:30:09 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 22 May 2009, Stanislaw Gruszka wrote:
> >  			case CPUCLOCK_PROF:
> > -				if (cputime_eq(p->cputime_expires.prof_exp,
> > -					       cputime_zero) ||
> > -				    cputime_gt(p->cputime_expires.prof_exp,
> > -					       nt->expires.cpu))
> > -					p->cputime_expires.prof_exp =
> > -						nt->expires.cpu;
> > +				if (expires_le(p->cputime_expires.prof_exp,
> > +					       exp->cpu))
> > +					break;
> 
>   Why the reverse logic and the extra break ?

Just to use helper and to make similar logic in all cases in this funcion.

Thanks
Stanislaw
