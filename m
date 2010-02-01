Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0BAIac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:30:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:60789 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab0BAIa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:30:29 -0500
Date: Mon, 1 Feb 2010 18:28:11 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 1/3] Create spin lock/spin unlock with distinct memory
 barrier
Message-ID: <20100201072811.GG9085@laptop>
References: <20100131205254.407214951@polymtl.ca>
 <20100131210013.265317204@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131210013.265317204@polymtl.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 03:52:55PM -0500, Mathieu Desnoyers wrote:
> +/*
> + * X86 spinlock-mb mappings. Use standard spinlocks with acquire/release
> + * semantics. Associated memory barriers are defined as no-ops, because the
> + * spinlock LOCK-prefixed atomic operations imply a full memory barrier.
> + */
> +
> +#define spin_lock__no_acquire			spin_lock
> +#define spin_unlock__no_release			spin_unlock
> +
> +#define spin_lock_irq__no_acquire		spin_lock_irq
> +#define spin_unlock_irq__no_release		spin_unlock_irq
> +
> +#define raw_spin_lock__no_acquire		raw_spin_lock
> +#define raw_spin_unlock__no_release		raw_spin_unlock
> +
> +#define raw_spin_lock_irq__no_acquire		raw_spin_lock_irq
> +#define raw_spin_unlock_irq__no_release		raw_spin_unlock_irq
> +
> +#define smp_acquire__after_spin_lock()		do { } while (0)
> +#define smp_release__before_spin_unlock()	do { } while (0)
> +
> +#define smp_mb__after_spin_lock()		do { } while (0)
> +#define smp_mb__before_spin_unlock()		do { } while (0)

Oh, and that one's wrong. loads can pass spin_unlock on x86 so it
needs to be smp_mb().

