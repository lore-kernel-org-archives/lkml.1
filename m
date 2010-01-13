Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200Ab0AMApa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0AMApa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712Ab0AMAp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:45:29 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:51086 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0AMAp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:45:28 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86-32: clean up rwsem inline asm statements
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
X-Yow: I've got a COUSIN who works in the GARMENT DISTRICT...
Date: Wed, 13 Jan 2010 01:45:24 +0100
In-Reply-To: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
	(Linus Torvalds's message of "Tue, 12 Jan 2010 16:21:09 -0800 (PST)")
Message-ID: <m2fx6ahly3.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> @@ -249,7 +249,7 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
>  {
>  	int tmp = delta;
>  
> -	asm volatile(LOCK_PREFIX "xadd %0,%1"
> +	asm volatile(LOCK_PREFIX "xadd%z0 %0,%1"
>  		     : "+r" (tmp), "+m" (sem->count)
>  		     : : "memory");

I think %z0 should be %z1 here.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
