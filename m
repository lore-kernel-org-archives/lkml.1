Return-Path: <linux-kernel-owner+w=401wt.eu-S934228AbXGQO0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228AbXGQO0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXGQOZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:25:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:39337 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbXGQOZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:25:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Date: Tue, 17 Jul 2007 16:25:42 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070716045932.GA19914@wotan.suse.de> <20070716050134.GB19914@wotan.suse.de>
In-Reply-To: <20070716050134.GB19914@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171625.42235.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



When you revamp everything I guess it would make the locks
easier to read to just put them into a .S file? They're
out of line anyways.

In general they look ok.

>  
>  static inline void __raw_spin_unlock(raw_spinlock_t *lock)
>  {
> -	asm volatile("movl $1,%0" :"=m" (lock->slock) :: "memory");
> +	__asm__ __volatile__(

Minor nit: please don't use these underlined keywords. They just look
ugly and asm volatile works as well.

-Andi
