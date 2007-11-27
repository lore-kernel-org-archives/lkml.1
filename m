Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbXK0ET6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbXK0ET6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXK0ETu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:19:50 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33961 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbXK0ETt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:19:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: kexec@lists.infradead.org, ak@suse.de, vgoyal@in.ibm.com, hbabu@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071127014740.GA28622@hmsreliant.think-freely.org>
Date: Mon, 26 Nov 2007 21:12:25 -0700
In-Reply-To: <20071127014740.GA28622@hmsreliant.think-freely.org> (Neil
	Horman's message of "Mon, 26 Nov 2007 20:47:40 -0500")
Message-ID: <m1d4twmimu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> Hey all-
> 	I've been working on an issue lately involving multi socket x86_64
> systems connected via hypertransport bridges.  It appears that some systems,
> disable the hypertransport connections during a kdump operation when all but the
> crashing processor gets halted in machine_crash_shutdown.  This becomes a
> problem when the ioapic attempts to route interrupts to the only remaining
> processor.  Even though the active processor is targeted for interrupt
> reception, the fact that the hypertransport connections are inactive result in
> interrupts not getting delivered.  The effective result is that timer interrupts
> are not delivered to the running cpu, and the system hangs on reboot into the
> kdump kernel during calibrate_delay.  I've found that I've been able to avoid
> this hang, by forcing a transition to the bios defined boot cpu during the
> crashing kernel shutdown.  This patch accomplished that.  Tested by myself and
> the origional reporter with successful results.

If you can get to calibrate_delay hypertransport is still routing traffic.
Your diagnosis of the problem is wrong.  Most likely it is just an ioapic
programming error in restoring the system to PIC mode.

I agree that there is a problem.

The reliable fix is to totally skip the PIC interrupt mode and go directly
to apic mode.

To make the code kexec on panic code path reliable we need to remove code
not add it.

Frankly I think switching cpus is one of the least reliable things that
we can do in general.

Eric
