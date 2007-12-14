Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXLNJnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXLNJnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbXLNJnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:43:13 -0500
Received: from [194.117.236.238] ([194.117.236.238]:56065 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXLNJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:43:12 -0500
Date: Fri, 14 Dec 2007 14:39:41 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214143941.2c7dcfb4@linux360.ro>
In-Reply-To: <p737ijigr8c.fsf@bingen.suse.de>
References: <20071214004442.5f9eba88@linux360.ro>
	<p737ijigr8c.fsf@bingen.suse.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 23:33:07 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> The description/option is not correct. The mainline kernel never
> disables C1e. Some distribution kernels and Xen do, perhaps you're
> confusing this with them.
> 
> You would rather need a "force_disable_c1e" option if anything.

The option I added (which is set to Y by default, but that's another
matter) disables C1E without any other kernel parameter. In my opinion,
this should be the normal behavior: the kernel has both SMP and NO_HZ
enabled, so do whatever is necessary to enable dynticks. But it would
also be useful, for benchmarking purposes, to prevent the kernel from
disabling C1E using a kernel parameter; that's what force_amd_c1e does.

> Anyways this should be near all obsolete with forced HPET. With HPET
> dynticks can be used even with C1e. So in most cases you can just
> use hpet=force instead and get dynticks and C1e together.

On my system, hpet=force does not enable dynticks:
$ dmesg | grep -E "(not functional|hpet)"
Command line: ro hpet=force
Kernel command line: ro hpet=force
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Time: hpet clocksource has been installed.
Clockevents: could not switch to one-shot mode: lapic is not functional.
Clockevents: could not switch to one-shot mode: lapic is not functional.
hpet_resources: 0xfed00000 is busy

But, using this patch, the kernel enables dynticks.
