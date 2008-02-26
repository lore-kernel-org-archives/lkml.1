Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbYBZQc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbYBZQc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYBZQct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:32:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47307 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbYBZQcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:32:48 -0500
Message-ID: <47C43F18.6060207@pobox.com>
Date: Tue, 26 Feb 2008 11:32:24 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080225195924.GA23176@atjola.homenet> <47C32043.6090809@pobox.com> <20080225124054.9b69e9f0.akpm@linux-foundation.org> <alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de> <47C34CEA.7060307@pobox.com> <20080226083904.GC9857@elte.hu>
In-Reply-To: <20080226083904.GC9857@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jgarzik@pobox.com> wrote:
> 
>> +	unsigned long flags;
>> +
>> +	local_irq_save(flags);
> 
> hm, couldnt we attach the irq disabling to some spinlock, in a natural 
> way? Explicit flags fiddling is a PITA once we do things like threaded 
> irq handlers, -rt, etc.

Attaching the irq disabling to some spinlock is what would be 
artificial...  See the ahci.c patch earlier in this thread.  It is taken 
without spin_lock_irqsave() in the interrupt handler, and there is no 
reason to disable interrupts for the entirety of the interrupt handler 
run -- only the part where we call kmap.

This is only being done to satisfy kmap_atomic's requirements, not libata's.

I could add a "kmap lock" but that just seems silly.

	Jeff




