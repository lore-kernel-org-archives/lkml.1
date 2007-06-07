Return-Path: <linux-kernel-owner+w=401wt.eu-S934158AbXFGRwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158AbXFGRwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763738AbXFGRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:51:49 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:7050 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762960AbXFGRvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:51:47 -0400
Date: Thu, 7 Jun 2007 19:51:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Make smp_call_function{_single} go WARNING and return -EINVAL on !SMP (was Re: [PATCH] i386/x86_64: NMI watchdog: Protect smp_call_function() within CONFIG_SMP)
Message-ID: <20070607175127.GA22844@osiris.ibm.com>
References: <a781481a0706070848j2256cc1elea8723778ab7da5b@mail.gmail.com> <a781481a0706070933ld67e06escaddf1b7be2b017@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706070933ld67e06escaddf1b7be2b017@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The smp_call_function{_single} functions are used to run
> given function on all {or speicified} *other* CPUs. For
> UP systems, "other" CPUs simply don't exist, so we flag
> such incorrect usage of these functions using a WARNING.

If other cpus don't exist then smp_call_function() should just do
*nothing* (there is no other cpu right?). We don't want to sprinkle
a ton of #ifdef CONFIG_SMP around each smp_call_function().

> Also, -EBUSY is generally returned by arch implementations
> when they find that target_cpu == current_cpu, which is not
> a comparable case to the !SMP case. Use -EINVAL instead,
> similar to what powerpc does for !cpu_online(target), which
> is somewhat more analogous.

No. Current semantics of smp_call_function_single() are that it
returns -EBUSY if called on the *current* cpu. Since on !CONFIG_SMP the
only possible cpu it can be called on is the current one, the only
sane return value is -EBUSY.
