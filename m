Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbYFMGDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbYFMGDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 02:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYFMGDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 02:03:04 -0400
Received: from www.tglx.de ([62.245.132.106]:50745 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbYFMGDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:03:04 -0400
Date: Fri, 13 Jun 2008 08:02:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@infradead.org,
       andreas.herrmann3@amd.com
Subject: Re: [patch 6/6] x86: add c1e aware idle function
In-Reply-To: <20080612175533.5b6c1736.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806130800060.3193@apollo.tec.linutronix.de>
References: <20080610171639.551369443@linutronix.de> <20080610171712.465591661@linutronix.de> <20080612175533.5b6c1736.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Andrew Morton wrote:
> On Thu, 12 Jun 2008 10:29:00 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> > +		default_idle();
> > +		local_irq_disable();
> > +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> > +		local_irq_enable();
> 
> I worked it out!  It took me a while.
> 
> This function is called with local irqs disabled.
> 
> default_idle() is entered with local irqs disabled but returns with them
> enabled.
> 
> clockevents_notify() is supposed to be called with local irqs disabled.
> 
> This functions returns with local irqs enabled.

Damn, you decoded my sekrit.
 
> Was I right?  None of any of that is documented anywhere.  But it should
> be.

Yeah, needs a big comment. Will add one.

Thanks,

	tglx
