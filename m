Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbYCMGIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbYCMGIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYCMGIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:08:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46478
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYCMGIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:08:35 -0400
Date: Wed, 12 Mar 2008 23:08:43 -0700 (PDT)
Message-Id: <20080312.230843.114525346.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ego@in.ibm.com,
       hugh@veritas.com, dada1@cosmosbay.com
Subject: Re: [PATCH 2/2] lockdep: fix fib_hash softirq inversion
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080312121323.959513000@chello.nl>
References: <20080312120920.929901000@chello.nl>
	<20080312121323.959513000@chello.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 12 Mar 2008 13:09:22 +0100

> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.25-rc4-sched-devel.git #56
> ---------------------------------------------------------
> swapper/0 just changed the state of lock:
>  (&rt_hash_locks[i]){-+..}, at: [<ffffffff804721ac>] rt_intern_hash+0x8c/0x3b0
> but this lock took another, soft-read-irq-unsafe lock in the past:
>  (fib_hash_lock){-.-?}
> 
> and interrupts could create inverse lock ordering between them.

I tried to figure out what lockdep doesn't like here.

Could you show me the specific code path that could cause
the lock conflict?

Adding BH disabling to fib_hash_lock will add non-trivial
costs to these code paths, so I'd like to avoid this if
possible.
