Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYCZVkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYCZVkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYCZVk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:40:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53150 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755959AbYCZVk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:40:27 -0400
Date: Wed, 26 Mar 2008 16:40:26 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Mayer <ajm@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
In-Reply-To: <20080326212312.GA27594@elte.hu>
Message-ID: <Pine.SGI.3.96.1080326163708.7873204c-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Ingo Molnar wrote:

> 
> * Alan Mayer <ajm@sgi.com> wrote:
> 
> > On machines with very large numbers of cpus, tables that are 
> > dimensioned by NR_IRQS get very large, especially the irq_desc table.  
> > They are also very sparsely used.  When the cpu count is > 
> > MAX_IO_APICS, use MAX_IO_APICS to set NR_IRQS, otherwise use NR_CPUS.
> 
> thanks Alan, applied this in place of the other patch.
> 
> this bit is still ugly:
> 
> > -#define NR_IRQS (NR_VECTORS + (32 *NR_CPUS))
> > +#if NR_CPUS < MAX_IO_APICS
> > +#define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
> > +#else
> > +#define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
> > +#endif
> >  #define NR_IRQ_VECTORS NR_IRQS
> 
> but it doesnt really depart from the current status quo of huge 
> [NR_IRQS] arrays either. Patches that make NR_IRQS a variable are 
> welcome :)
> 
> 	Ingo
> 

Good luck with that.  If i come up with something that's elegant enough
to make it worth the risk, I'll let you know.  Changing NR_IRQS to a variable
touches every arch and a lot of drivers.  Someone is bound to choke
on it, so it has to be something worth fighting for.

		--ajm

Lately it occurs to me,
What a long, strange trip it's been.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

