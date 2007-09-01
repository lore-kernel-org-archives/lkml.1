Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbXIAALg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbXIAALg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 20:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXIAAL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 20:11:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:37756 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXIAAL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 20:11:26 -0400
Subject: Re: v2.6.23-rc4-rt1 / new project URL
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1188593944.9647.15.camel@chaos>
References: <1188593944.9647.15.camel@chaos>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 17:01:26 -0700
Message-Id: <1188604887.26038.110.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 22:59 +0200, Thomas Gleixner wrote:
> We're pleased to announce the release of the v2.6.23-rc4-rt1 kernel,
> which can be downloaded from a new place:
>  
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
>  
> The move to kernel.org is experimental for now, we'll keep it if it
> works out fine.
> 
> Changes since 2.6.23-rc2-rt2:
> 
> - update to -rc4
> - update to 2.6.23-rc4-hrt1
> 
> - UP compile fixes back merged (Kevin Hilman / Steven Rostedt)
> - various latency tracer fixes (Steven Rostedt)

I'm not sure which latency tracing fixes these are, but Steven's
get_monotonic_cycles() changes are racy .. It might be a little
premature to include them .. It at least fouls latency tracing on my
test machine.

> - simple_irq change (Kevin Hilman): needs more thought
> - RCU updates (Paul McKenney): needs proper integration
> - latency tracer changes (Daniel Walker): needs review
> - PICK_OP changes (Daniel Walker): needs review

The PICK_OP changes got reviewed by Ingo , as of,

http://marc.info/?l=linux-rt-users&m=118638506125380&w=2

They do need one small fix tho .. Below ..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

Index: linux-2.6.22/include/linux/spinlock.h
===================================================================
--- linux-2.6.22.orig/include/linux/spinlock.h	2007-09-01 00:08:04.000000000 +0000
+++ linux-2.6.22/include/linux/spinlock.h	2007-09-01 00:07:48.000000000 +0000
@@ -501,7 +501,7 @@ do {									\
 
 #define spin_trylock_irq(lock)	\
 	__cond_lock(lock, PICK_SPIN_OP_RET(__spin_trylock_irq,		\
-		__spin_trylock_irq, lock))
+		_spin_trylock_irq, lock))
 
 #define spin_trylock_irqsave(lock, flags) \
 	__cond_lock(lock, PICK_SPIN_OP_RET(__spin_trylock_irqsave, 	\


