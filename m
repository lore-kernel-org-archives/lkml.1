Return-Path: <linux-kernel-owner+w=401wt.eu-S934394AbXHNTI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394AbXHNTI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXHNTIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:08:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbXHNTIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:08:16 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
References: <20070814153021.446917377@sgi.com>
	<20070814153501.766137366@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Aug 2007 22:02:23 +0200
In-Reply-To: <20070814153501.766137366@sgi.com>
Message-ID: <p73vebhnauo.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> Reclaim can be called with interrupts disabled in atomic reclaim.
> vmscan.c is currently using spinlock_irq(). Switch to spin_lock_irqsave().

I like the idea in principle. If this fully works out we could
potentially keep less memory free by default which would be a good
thing in general: free memory is bad memory.

But would be interesting to measure what the lock
changes do to interrupt latency. Probably nothing good.

A more benign alternative might be to just set a per CPU flag during
these critical sections and then only do atomic reclaim on a local
interrupt when the flag is not set.  That would make it a little less
reliable, but much less intrusive and with some luck still give many
of the benefits.

-Andi
