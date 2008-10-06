Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYJFNQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYJFNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 09:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYJFNQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 09:16:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYJFNQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 09:16:51 -0400
Date: Mon, 6 Oct 2008 15:22:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional hotplug  CPUs to be set at compile time
Message-ID: <20081006132252.GF3180@one.firstfloor.org>
References: <bjiEh-2MC-21@gated-at.bofh.it> <bjnXc-1ec-11@gated-at.bofh.it> <bjz2s-78A-13@gated-at.bofh.it> <bjDfK-40E-19@gated-at.bofh.it> <bjDIN-4L8-31@gated-at.bofh.it> <bjEbU-5eX-19@gated-at.bofh.it> <bjIIi-2Oi-1@gated-at.bofh.it> <bjJOk-49Q-5@gated-at.bofh.it> <bjKAv-5bK-17@gated-at.bofh.it> <E1Kmno6-0003es-Te@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kmno6-0003es-Te@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 12:59:18PM +0200, Bodo Eggert wrote:
> I don't have a machine with pluggable CPUs, but I'd imagine if you'd take out
> some CPUs, the number of additional CPUs you can plug in will increase by the
> same number (forcing me to change the kernel command lince if I do), while the

It only costs you some memory to have more hotpluggable CPUs (on my
kernel here around 40k/possible CPU), so there's very little "force" in 
practice unless you set excessive values.

Some other architectures invented a "possible_cpus=..." parameter to address
this. I presume this could be done on x86 too, but it doesn't seem
like a very pressing issue. Even if it was done it would be better
to keep additional_cpus for compatibility.

> number of slots (and the number of possible CPUs) stays the same unless
> somebody offers a new kind of CPU card. Therefore, I'd expect "maxcpus=" to be
> the only interface I want for this purpose. Put in a value bigger than the
> amount plugged in -> voila.

maxcpus=... doesn't affect the cpu_possible_mask.  It really is only 
good for limiting CPUs.

> OTOH, looking at Thomas' patch, I'd guess it would not work as expected ...
> and looking at the code seems to confirm this. Besides that, I'd possibly
> want a way to limit the number of online CPUs at boot saying something like
> "onlinecpus=", which would not limit the number of CPUs I can plug in.

That is exactly what maxcpus=... does.

Anyways I don't see the additional_cpus=... removal patch in tip
so hopefully things are fine now

-Andi

-- 
ak@linux.intel.com
