Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYH2Qs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYH2Qs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYH2QsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:48:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55223 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYH2QsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:48:15 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [RFC] export irq_set/get_affinity() for multiqueue network drivers
From: Andi Kleen <andi@firstfloor.org>
References: <48B708E1.4070001@inria.fr>
	<20080829055023.07966b4a@infradead.org>
Date: Fri, 29 Aug 2008 18:48:12 +0200
In-Reply-To: <20080829055023.07966b4a@infradead.org> (Arjan van de Ven's message of "Fri, 29 Aug 2008 05:50:23 -0700")
Message-ID: <8763pjpy2b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Thu, 28 Aug 2008 22:21:53 +0200
> Brice Goglin <Brice.Goglin@inria.fr> wrote:
>
>> Hello,
>> 
>> Is there any way to setup IRQ masks from within a driver? myri10ge
>> currently relies on an external script (writing in
>> /proc/irq/*/smp_affinity) to bind each queue/MSI-X to a different
>> processor. By default, Linux will either:
>> * round-robin the interrupts (killing the benefit of DCA for instance)
>> * put all IRQs on the same CPU (killing much of th
>
> * do the right thing with the userspace irq balancer

It probably also needs to be hooked up the sched_mc_power_savings
When the switch is on the interrupts shouldn't be spread out over
that many sockets.

Does it need callbacks to change the interrupts when that variable
changes?

Also I suspect handling SMT explicitely is a good idea. e.g. I would
always set the affinity to all thread siblings in a core, not 
just a single one, because context switch is very cheap between them.

-Andi

-- 
ak@linux.intel.com
