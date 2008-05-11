Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYEKA5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYEKA5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 20:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYEKA5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 20:57:23 -0400
Received: from [194.117.236.238] ([194.117.236.238]:52028 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYEKA5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 20:57:23 -0400
Date: Sun, 11 May 2008 03:56:44 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Paul McKenney <Paul.McKenney@us.ibm.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Using markers w/ preemptible RCU in early code
Message-ID: <20080511035644.3613a9a2@linux360.ro>
In-Reply-To: <OFFCD1EB75.A69A5A3C-ON88257445.007BA01C-88257446.0002C7EF@us.ibm.com>
References: <20080509223823.GD12311@Krystal>
	<OFFCD1EB75.A69A5A3C-ON88257445.007BA01C-88257446.0002C7EF@us.ibm.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008 17:30:23 -0700
Paul McKenney <Paul.McKenney@us.ibm.com> wrote:

> There might be an easy and harmless fix for early-boot use of 
> synchronize_sched() -- I will look into this.
> 
> As noted above, call_rcu() is not a problem.
> 
> The rcu_barrier*() primitives must never be invoked at early boot
> time. These primitives absolutely must block until all of the
> corresponding flavor of callback has been invoked (and completed),
> but it is not possible to block during early boot.  Perhaps they
> should do a WARN_ON() or BUG_ON() in this case?
> 
> But why are you calling rcu_barrier() during early boot in the first 
> place?

Hi,

Mathieu's code does not call rcu_barrier() explicitely during early
boot. It just happens that I need to use his code (i.e. markers) at that
moment.

My understanding is that we could skip any synchronization primitives
during early code, since there is no SMP and no preemption (and no IRQs
popping around, maybe?). RCU stuff still needs to get registered for
later on, though.

I guess we should write a marker_probe_register() variant for early
code, with no rcu_barrier() and no synchronize_sched() around.

Mathieu, does this sound okay?

(Paul, I removed your alias from the Cc list, so you don't get duplicates.)


Thanks for your input,
		Eduard
