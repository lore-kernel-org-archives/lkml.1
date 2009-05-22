Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZEVOas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZEVOas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZEVOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:30:40 -0400
Received: from www.tglx.de ([62.245.132.106]:41930 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267AbZEVOaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:30:39 -0400
Date: Fri, 22 May 2009 16:30:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend4 3/3] itimers: simplify arm_timer() code a bit
In-Reply-To: <20090522154349.396d9ea6@dhcp-lab-109.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.0905221629080.3570@localhost.localdomain>
References: <20090522154349.396d9ea6@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Stanislaw Gruszka wrote:
>  			case CPUCLOCK_PROF:
> -				if (cputime_eq(p->cputime_expires.prof_exp,
> -					       cputime_zero) ||
> -				    cputime_gt(p->cputime_expires.prof_exp,
> -					       nt->expires.cpu))
> -					p->cputime_expires.prof_exp =
> -						nt->expires.cpu;
> +				if (expires_le(p->cputime_expires.prof_exp,
> +					       exp->cpu))
> +					break;

  Why the reverse logic and the extra break ?

> +				p->cputime_expires.prof_exp = exp->cpu;
>  				break;

Thanks,

	tglx
