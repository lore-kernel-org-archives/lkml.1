Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbXD0NhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbXD0NhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXD0NhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:37:08 -0400
Received: from www.osadl.org ([213.239.205.134]:59309 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755827AbXD0NhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:37:06 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070427115526.GA7699@elte.hu>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 15:39:04 +0200
Message-Id: <1177681144.25960.117.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 13:55 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > update for lkml readers: this is some really 'catastrophic' condition 
> > triggering on your box. Here ogg123 just never skips on an older 750 
> > MHz box, which is 4-5 times slower than your 2GHz box - while i have 
> > _fourty nice-0 infinite loops_ running. I.e. at this clearly 
> > ridiculous load, at just 2.5% of CPU time ogg123 is just chugging 
> > along nicely and never leaves out a beat.
> 
> Kasper, just to exclude the possibility that this is somehow related to 
> IO scheduling, could you copy the OGG file over to /dev/shm and play it 
> from there? Do you still get the bad skips?

That's what I can observe here:

ogg123 local harddisk	skips
ogg123 nfs		works
ogg123 /dev/shm		works

The skips when running from the local harddisk are definitely caused by
the I/O scheduler or some other bottleneck in the block/disk/scsi/sata
jungle. I try to find out more details.

	tglx


