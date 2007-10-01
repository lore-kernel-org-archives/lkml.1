Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXJAPAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXJAPAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXJAPAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:00:05 -0400
Received: from www.tglx.de ([62.245.132.106]:39010 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJAPAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:00:03 -0400
Date: Mon, 1 Oct 2007 16:59:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: x86_64 and AMD with C1E
In-Reply-To: <20071001143225.GA19797@one.firstfloor.org>
Message-ID: <alpine.LRH.0.999.0710011652470.7353@www.tglx.de>
References: <20071001101532.025d652f@localhost> <p73r6kf6uwz.fsf@bingen.suse.de>
 <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
 <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com>
 <alpine.LRH.0.999.0710011612001.7353@www.tglx.de>
 <20071001143225.GA19797@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andi Kleen wrote:
> > There is work in progress on a patch, which allows to utilize the hpet
> > timers as per cpu timers. This should solve the problem. Be patient.
> 
> Given that e.g. ICH8 only has 3 HPET timers that seems doubtful
> except for the special case of single-socket non hyper threaded dual core.
> You'll probably do a lot of broadcasting and IPI'ing still.
> 
> Also you'll likely make user space unhappy which often requires 
> at least one free HPET timer for /dev/rtc. Ok I suppose that 
> could be replaced with a hrtimer.

Yes, we can replace rtc with a hrtimer. Also HPET can operate in non
legacy irq mode, so the legacy rtc is still available. So if the
number of hpet channels is greater/equal to the number of possible
CPUs it's perfectly fine and does not need IPI at all.

Thanks,

	tglx

