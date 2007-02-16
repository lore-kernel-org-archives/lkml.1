Return-Path: <linux-kernel-owner+w=401wt.eu-S1946250AbXBPVRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946250AbXBPVRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946252AbXBPVRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:17:36 -0500
Received: from www.osadl.org ([213.239.205.134]:54963 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946250AbXBPVRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:17:35 -0500
Subject: Re: 2.6.20-git13 kernel BUG at
	/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45D61632.1020105@googlemail.com>
References: <45D61632.1020105@googlemail.com>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 22:22:19 +0100
Message-Id: <1171660939.30834.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 21:38 +0100, Michal Piotrowski wrote:
> Hi,
> 
> This looks like a tickless stuff

Yup.

> 0xc0139ea0 is in tick_nohz_stop_sched_tick (/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168).
> 163
> 164             if (need_resched())
> 165                     goto end;
> 166
> 167             cpu = smp_processor_id();
> 168             BUG_ON(local_softirq_pending());

Hmm, the BUG_ON is inside of an interrupt disabled region, so we should
have bailed out early in the need_resched() check above (because we are
in the idle task context according to the stack trace).

Is this reproducible ?

	tglx


