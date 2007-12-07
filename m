Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbXLGLLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbXLGLLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXLGLLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:11:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbXLGLLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:11:33 -0500
Date: Fri, 7 Dec 2007 03:09:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-Id: <20071207030954.8c1fedc5.akpm@linux-foundation.org>
In-Reply-To: <20071207104013.GC27307@elte.hu>
References: <20071207021952.6f0ac922@morte>
	<20071207084559.GA11162@elte.hu>
	<20071207023241.15274ef6.akpm@linux-foundation.org>
	<20071207104013.GC27307@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007 11:40:13 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > -				t = printk_clock();
> > > +				t = cpu_clock(printk_cpu);
> > >  				nanosec_rem = do_div(t, 1000000000);
> > >  				tlen = sprintf(tbuf,
> > >  						"<%c>[%5lu.%06lu] ",
> > 
> > A bit risky - it's quite an expansion of code which no longer can call 
> > printk.
> > 
> > You might want to take that WARN_ON out of __update_rq_clock() ;)
> 
> hm, dont we already detect printk recursions and turn them into a silent 
> return instead of a hang/crash?
> 

We'll pop the locks and will proceed to do the nested printk.  So
__update_rq_clock() will need rather a lot of stack ;)
