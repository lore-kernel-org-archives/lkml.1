Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbXJJNkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbXJJNkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXJJNkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:40:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:38740 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbXJJNki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:40:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86_64, vsyscall: fix the oops crash with __pa_vsymbol()
Date: Wed, 10 Oct 2007 15:36:58 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, yanmin.zhang@intel.com, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20071010015922.GC30676@linux-os.sc.intel.com>
In-Reply-To: <20071010015922.GC30676@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710101536.59156.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 03:59:22 Siddha, Suresh B wrote:
> Appended patch fixes an oops while changing the vsyscall sysctl.
> I am sure no one tested this code before integrating into mainline :(

The original code worked, but got broken by 0dbf7028c0c1f266c9631139450a1502d3cd457e
> 
> BTW, using ioremap() in vsyscall_sysctl_change() to get the virtual
> address of a kernel symbol sounds like an over kill.

Another point was to get a writable mapping. At some point we had write 
protected kernels, although that was later then removed again.

> And also, the whole nop out syscall in vsyscall page infrastructure
> (vsyscall_sysctl_change()) is added to make some attacks difficult,
> and yet I don't see this nop out being done by default. This area
> requires more cleanups?

It used to be done, but it is difficult with the changing vreads
in timesources and was probably disabled then. Yes you're right right now 
it looks dubious.

It needs to be updated when the timesource is updated.

-Andi

