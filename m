Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZA3B4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZA3B4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZA3Bz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:55:56 -0500
Received: from ozlabs.org ([203.10.76.45]:53919 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZA3Bzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:55:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
Date: Fri, 30 Jan 2009 12:25:48 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301225.48979.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 04:38:23 Linus Torvalds wrote:
> 
> On Thu, 29 Jan 2009, Steven Rostedt wrote:
> > 
> > Actually, we are locking against the destination CPU.
> 
> Oh.
> 
> THAT'S JUST INCOMPETENT.
> 
> What the *fuck* is the point of having per-CPU data, and then using it for 
> the wrong CPU?

Maybe we made it too easy to declare and use per-cpu data?

Could we use an nr_cpu_ids array?  Yes, it needs alloc at boot somewhere, but
it avoids collateral damage to other percpu data (and please don't suggest DEFINE_PER_CPU_SHARED_ALIGNED: that's just antisocial).

Thanks,
Rusty.
