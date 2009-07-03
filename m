Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZGCQs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZGCQs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbZGCQsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:48:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756717AbZGCQst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:48:49 -0400
Date: Fri, 3 Jul 2009 09:47:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, arnd@arndb.de,
       fweisbec@gmail.com, dhowells@redhat.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: Move the 32-bit atomic64_t
 implementation to a .c file
In-Reply-To: <tip-b7882b7c65abb00194bdb3d4a22d27d70fcc59ba@git.kernel.org>
Message-ID: <alpine.LFD.2.01.0907030942260.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-b7882b7c65abb00194bdb3d4a22d27d70fcc59ba@git.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Jul 2009, tip-bot for Ingo Molnar wrote:
> +int atomic64_add_negative(u64 delta, atomic64_t *ptr)
> +{
> +	long long old_val = atomic64_add_return(delta, ptr);
> +
> +	return old_val < 0;
> +}

Can we please fix this horribly mis-named 'old_val' variable?

It's not 'old_val'. It should be 'new_val' or 'result'.

As it is, the above looks very wrong, and made me think that you had done 
the wrong semantics (ie "xadd" like semantics that literally return the 
pre-add 'old' value).

But on closer inspection, it looks like the code is correct, but the 
naming is just totally wrong.

		Linus
