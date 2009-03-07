Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZCGPbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZCGPbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZCGPbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:31:17 -0500
Received: from www.tglx.de ([62.245.132.106]:37402 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZCGPbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:31:16 -0500
Date: Sat, 7 Mar 2009 16:30:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 4/7] futex: finish_futex_lock_pi()
In-Reply-To: <49AC7683.3080503@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0903071625180.29264@localhost.localdomain>
References: <49AC73A9.4040804@us.ibm.com> <49AC7683.3080503@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, Darren Hart wrote:
> +	} else {
> +		/* dvhart FIXME: can't we just BUG_ON in this case?

No. There is no reason to crash the kernel if this happens. All what
happens is that a userspace application becomes a bit unhappy.

I did not put a WARN_ON there as the stack trace is known, but we
could do a WARN to trigger the kerneloops detector.

> +		 * Paranoia check. If we did not take the lock in the trylock
> +		 * above, then we should not be the owner of the rtmutex,
> +		 * neither the real nor the pending one:
> +		 */
> +		if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
> +			printk(KERN_ERR "finish_futex_lock_pi: "
> +					"ret = %d pi-mutex: %p "
> +					"pi-state %p\n", ret,
> +					q->pi_state->pi_mutex.owner,
> +					q->pi_state->owner);
> +	}

Thanks,

	tglx
