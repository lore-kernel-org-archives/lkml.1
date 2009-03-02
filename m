Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbZCBSHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbZCBSHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZCBSHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:07:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:46362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZCBSHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:07:40 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200903021855.02765.bzolnier@gmail.com>
References: <1235996477.5330.174.camel@laptop>
	 <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
	 <200903021855.02765.bzolnier@gmail.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 19:07:28 +0100
Message-Id: <1236017249.5330.1011.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 18:55 +0100, Bartlomiej Zolnierkiewicz wrote:
> > Could we make just the IDE driver itself enable interrupts? Sure. But that 
> 
> Actually it has been doing it for years (some host drivers don't do this by
> default and still need "hdparm -u" or equivalent but I was planning to change
> it for 2.6.30).

What does it use to do that? A local_irq_enable() in hardirq context
will make lockdep yell bloody murder :-).

Then there is local_irq_enable_in_hardirq(), which plain simply lies
when lockdep is enabled -- IOW it would generate horrid irq latencies.

Not having to deal with IRQ recursion in lockdep helps.

