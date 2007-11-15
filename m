Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXKOFgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXKOFgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 00:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXKOFgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 00:36:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34685 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXKOFgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 00:36:45 -0500
Date: Thu, 15 Nov 2007 06:36:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Max Asbock <masbock@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: x86 32-bit machine check handler
Message-ID: <20071115053639.GA7552@one.firstfloor.org>
References: <1194899975.9979.7.camel@w-amax.beaverton.ibm.com> <p73abpiz0x8.fsf@bingen.suse.de> <1195088771.9979.31.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195088771.9979.31.camel@w-amax.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I found patch from about three years ago that implemented a 32-bit
> version of the x86_64 machine check handler. Do you know of any newer
> attempts?

No.

> However, given the merge of x86, a single implementation should be able
> to handle both the 32-bit and 64-bit cases. I tried to build the 64-bit
> machine check handler (mce_64.c) for 32-bit to see what kind problems it
> would run into. So far I found a few things:
> - there is no idle_notifier_register in 32-bit x86

There used to be one, just needs to be readded.

> - there is no oops_begin in 32-bit x86
> - register names are different (rip, cs)

regs->rip -> instruction_pointer() 
->cs just needs a similar macro

> So it looks like giving 32-bit x86 the same machine check support as in
> 64-bit is both feasible and desirable.

Yep.

-Andi
