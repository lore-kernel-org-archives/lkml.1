Return-Path: <linux-kernel-owner+w=401wt.eu-S939658AbXG3Xyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939658AbXG3Xyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763101AbXG3Xys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:54:48 -0400
Received: from aun.it.uu.se ([130.238.12.36]:54562 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbXG3Xyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:54:47 -0400
Date: Tue, 31 Jul 2007 01:54:02 +0200 (MEST)
Message-Id: <200707302354.l6UNs222023051@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: buytenh@wantstofly.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: handle_futex_death() infinite loop on ARM (fwd)
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007 12:23:18 +0200, Lennert Buytenhek wrote:
>If you're also running into glibc's tst-robust1 test suite test
>locking up your ARM machine, you're probably running into the fact
>that asm-arm/futex.h includes asm-generic/futex.h, and
>asm-generic/futex.h defines futex_atomic_cmpxchg_inatomic() to
>return -ENOSYS.  This causes handle_futex_death() to loop forever.

Has there been any progress on fixing this yet?

I've studied the relevant futex code (handle_futex_death()
and asm-${arch}/futex.h), and it seems that many archs
are seriously broken now, not just arm. Any arch that wires
up the set_robust_list() syscall while implementing its
asm-${arch}/futex.h by including asm-generic/futex.h allows
its kernels to be hung by unprivileged user-space code.

My concern is arm, but it seems alpha, avr32, h8300, m68k,
m68knommu, and sh64 are also affected by this bug.

/Mikael
