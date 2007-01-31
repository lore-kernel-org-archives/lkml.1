Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXAaIkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXAaIkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXAaIkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:40:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34453 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbXAaIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:40:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <luigi.genoni@pirelli.com>
Cc: <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1ps973rxh.fsf@ebiederm.dsl.xmission.com>
	<200701231051.32945.luigi.genoni@pirelli.com>
	<m1y7nu2axr.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0701232052330.32111@baldios.it.pirelli.com>
Date: Wed, 31 Jan 2007 01:39:26 -0700
In-Reply-To: <Pine.LNX.4.64.0701232052330.32111@baldios.it.pirelli.com> (luigi
	genoni's message of "Tue, 23 Jan 2007 21:16:28 +0100 (CET)")
Message-ID: <m1bqkfbnep.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<luigi.genoni@pirelli.com> writes:

> I have in interesting update, at less I suppose I have.

It was, at least as another data point.

> I do not know very well what happens with irq stuff migrating shared irq, but I
> suppose this has something to do with this crash.

The fact the irq was shared should have no bearing on this crash scenario.
A shared irq is not at all helpful in a performance sense, but this problem
is low enough that a shared irq should have made not difference at all, except
for the frequency the interrupt fired, and was migrated.  And a high interrupt
frequency, and a high migration rate tend to cause this problem.

> Right now I stopped irqbalance and puff! load average is back to normal, and
> under the same workload notthing similar is happening for the moment.

Yes.  That sounds like a good work around until this problem is sorted out.

> Lesson number one I learnt: avoid shared IRQ on this systems (but to reconfigure
> HW cabling right now is not so easy).

Right.   Because the only sharing should be because the traces on the
motherboard are shared.

> I hope this helps

It has all helped.

I have been tracking some easier problems, keeping this one on my back burner.
The good/bad news is that by restricting my set of vectors I can choose from
in the kernel, and running ping -f to another machine.  And migrating the
single irq for my NIC.  I have been able to reproduce this in about 5 minutes.

I haven't root caused it yet, but the fact I can reproduce this on dual socket
motherboard suggest the reason it took you an hour to reproduce the problem is
simply because you had so few irqs on your system, and that the extreme
latency of 8-socket Opterons is not to blame.

Hopefully now that I can reproduce this I will be able to root cause
this and then fix this bug.

Eric
