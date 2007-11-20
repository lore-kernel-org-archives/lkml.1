Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbXKTTSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbXKTTSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXKTTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:18:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbXKTTSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:18:00 -0500
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
From: Andi Kleen <andi@firstfloor.org>
References: <47425EA5.7000607@rtr.ca>
	<200711201517.16171.nickpiggin@yahoo.com.au>
Date: Tue, 20 Nov 2007 20:17:57 +0100
In-Reply-To: <200711201517.16171.nickpiggin@yahoo.com.au> (Nick Piggin's message of "Tue\, 20 Nov 2007 15\:17\:15 +1100")
Message-ID: <p7363zwbuai.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:
>
> For that matter, I'd like to know why it has been decided that the
> best place for IRQ balancing is in userspace.

There is a lot of possible policy in it 

> It should be in kernel
> IMO, and it would probably allow better power saving, performance,
> fairness, etc. if it were to be integrated with the task balancer as
> well.

Integrating with the task balancer makes really only sense if the
device supports MSI-X and if it does that you don't really need
an irq balancer because you can just send to all CPUs as needed.

Without MSI-X you would be trying to reprogram the interrupts
all the time when a task is migrating and it is highly doubtful
that doing that automatically would do any good.

-Andi

