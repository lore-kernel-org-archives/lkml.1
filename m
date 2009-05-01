Return-Path: <linux-kernel-owner+w=401wt.eu-S1765124AbZEAUoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765124AbZEAUoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZEAUn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:43:59 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:61472 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527AbZEAUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:43:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEADD4+klMQW1W/2dsb2JhbACBUM19g30F
Date: Fri, 1 May 2009 16:43:55 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090501204355.GB20280@Krystal>
References: <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com> <20090501202400.GA20280@Krystal> <alpine.DEB.1.10.0905011623450.16255@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905011623450.16255@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:42:06 up 62 days, 17:08,  2 users,  load average: 0.29, 0.53,
	0.52
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 1 May 2009, Mathieu Desnoyers wrote:
> 
> > So, back to my original point : do you agree on the usefulness of
> > separating fallback irq-disabling from the per-cpu atomic construct ?
> 
> No. Percpu operations are used for statistics and are like atomic
> operations. Aggregation of these leads to a can of worms that we better
> leave unopened.
> 
> > x86 would map :
> >
> > percpu_irqsave/restore to "nothing".
> > percpu_add_return_irq to xadd instruction. It is irq-safe by design.
> >
> > Other architectures (fallback) would map
> >
> > percpu_irqsave/restore to local_irq_save/restore.
> > percpu_add_return_irq to var += value; return var;
> 
> Shudder.... We have explored those types of macros before (while doing
> fastpath optimization for SLUB) and it significant increases the
> complexity. People may add additional instructions in between and now
> interrupts off could be on or off depending on the architecture. Sometimes
> percpu_irqsave does nothing. Very difficult to ensure that the usage is
> correct.
> 
> And we have barely any usage case for such macros.
> 

Then do you have a better idea on how to deal with
__inc_zone_state/inc_zone_state without duplicating the code and without
adding useless local_irq_save/restore on x86 ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
