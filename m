Return-Path: <linux-kernel-owner+w=401wt.eu-S1031194AbXDQQ6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031194AbXDQQ6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031195AbXDQQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:58:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33566 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031194AbXDQQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:58:04 -0400
Date: Tue, 17 Apr 2007 18:57:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: John Sigler <linux.kernel@free.fr>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Disabling x86 System Management Mode
Message-ID: <20070417165759.GA10145@one.firstfloor.org>
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de> <4624FA85.9010704@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624FA85.9010704@free.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 06:49:09PM +0200, John Sigler wrote:
> >>.globl foo
> >>foo:
> >>   push %ebx
> >>   push %esi
> >>   cpuid
> >>   rdtsc
> >
> >At least some SMM implementations restore the old TSC value. Sad but true.
> 
> Why would they do that?

I asked the same question.  But it has been observed.

> How would you detect periodic SMM on such a system?

It's not a design goal of SMM to be detectable so the BIOS 
writers and hardware designers don't care if you can.

You could probably try to measure using a external or the LAPIC 
clock.  Or check the chipset bits. 

> 
> >Besides RDTSC can be speculated around on some CPUs which also adds errors.
> 
> I don't understand this sentence. Could you clarify?

Modern x86 CPUs execute code out of order and in parallel. The reordering
window can be quite large and the CPU can execute code speculatively. 
This can add large errors to RDTSC when the instruction is not executed
where you think it is. One way around this is to synchronize it -- 
using CPUID -- but that also adds latency and makes the measurement
less precise.

-Andi

