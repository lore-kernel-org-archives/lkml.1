Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXLMDgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXLMDgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 22:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXLMDgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 22:36:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXLMDgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 22:36:14 -0500
Subject: Re: [PATCH RT] add pending in fasteoi for IOAPIC hack
From: Jon Masters <jcm@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.58.0712121539400.22581@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0712121539400.22581@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Wed, 12 Dec 2007 22:35:40 -0500
Message-Id: <1197516940.12653.5.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 15:41 -0500, Steven Rostedt wrote:
> The IOAPIC hack that does a level=>edge to mask does not disable
> interrupts. So we can receive interrupts when masked, and this means
> that we can miss interrupts that arrive when the thread is handling
> them.
> 
> This patch adds the "IRQ_PENDING" logic of the edge irqs to be
> able to catch interrupts coming in when supposably "masked".

ACK on all of these. I've been using them internally for a bit in
pursuit of a later problem. Additionally, I am currently reworking the
level->edge->level hack because it's known to be in violation of a
number of errata from third parties. The "legacy mode" hack is actually
only need on certain systems, which have e.g. a PCIe host bridge with
integrated IO-APIC that snoops the APIC to determine mask status.

I'm going to add a blacklist and quirks instead, as doing
level->edge->level otherwise causes us to start losing interrupts on
other systems. I will supply more information later - this is a somewhat
involved problem that we (Red Hat) have been looking at for a while.

Jon.


