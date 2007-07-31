Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbXGaUeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbXGaUeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763772AbXGaUat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:30:49 -0400
Received: from flvpn.ccur.com ([66.10.65.2]:55213 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765908AbXGaUaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:30:46 -0400
Date: Tue, 31 Jul 2007 16:29:43 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
Subject: Re: [PATCH] expand /proc/interrupts to include missing vectors, v3
Message-ID: <20070731202943.GA30789@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20070726180522.GA1486@tsunami.ccur.com> <46A8EE78.4040702@zytor.com> <1185816797.3170.1.camel@sven.thebigcorporation.com> <20070730123206.abeab890.akpm@linux-foundation.org> <20070731001718.GA14295@tsunami.ccur.com> <20070731141941.GA3112@tsunami.ccur.com> <p73wswgpkvq.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73wswgpkvq.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 07:02:01PM +0200, Andi Kleen wrote:

Hi Andi,
Thanks for the review.  I implemented many of your suggestions and for
the rest, here mention why not, in case you want to respond further.

Regards,
Joe

> Joe Korty <joe.korty@ccur.com> writes:
> > A threshold interrupt occurs when ECC memory correction
> > is occuring at too high a frequency. 
> 
> It's configurable and the default is off. Also 
> it's only on AMD hardware.

v4 now has a comment to the Documentation section noting
this.


> > Thresholds are used
> > by the ECC hardware as occasional ECC failures are part
> > of normal operation,

Occasional ECC _corrections_ are normal (due to stray alpha particles)
but ECC _failures_ are not.  Document corrected.

> >  	irq_exit();
> > +	__get_cpu_var(irq_stat).irq_spur_counts++;
> 
> Wouldn't it be safer on preemptible kernels to have that inside
> the irq_exit? 

Although irq_exit() releases the preemption block, it doesn't seem to
release the APIC interrupt block, at least for i386.  And as an interrupt
block also blocks preemption and process migration, it seems that it would
be safe to do the increments after the irq_exit().  But I've moved them
all inside in v4, just in case I am wrong, or this changes in the future
(eg, PREEMPT_RT).

> > +		seq_printf(p, "RES: ");
> 
> I think it would be better to use 5-6 char identifiers
> even when it whacks the columns a bit; otherwise nobody
> will know what it means. e.g. SCHED here.

v3 addresses this.  The normally empty 'description' column at the end of
each line now holds a description of each vector.  The three-character
line-prefix names are there only to make the new lines match the syntax
and format of the other lines in /proc/interrupts.

> Also there you should update proc(5) and send a patch
> to the manpage maintainer.

Will do.

Thanks,
Joe

PS: also fixed up the whitespace.
