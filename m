Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0BRJ44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:56:56 -0500
Received: from ozlabs.org ([203.10.76.45]:49939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab0BRJ4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:56:52 -0500
Date: Thu, 18 Feb 2010 20:55:30 +1100
From: Anton Blanchard <anton@samba.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: arun@linux.vnet.ibm.com, tglx@linutronix.de, davem@davemloft.net,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       venkatesh.pallipadi@intel.com
Subject: Re: NO_HZ migration of TCP ack timers
Message-ID: <20100218095529.GA31681@kryten>
References: <20100218052820.GD24270@kryten>
 <87mxz755ks.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxz755ks.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andi,

> If the nohz balancer CPU is otherwise idle, shouldn't it have enough
> cycles to handle acks for everyone? Is the problem the cache line
> transfer time?

Yeah, I think the timer spinlock on the nohz balancer cpu ends up being a
global lock for every other cpu trying to migrate their ack timers to it.

> Sounds like something that should be controlled by the cpufreq governour's
> idle predictor? Only migrate if predicted idle time is long enough.
> It's essentially the same problem as deciding how deeply idle to put
> a CPU. Heavy measures only pay off if the expected time is long enough.

Interesting idea, it seems like we do need a better understanding of
how idle a cpu is, not just that it is idle when mod_timer is called.

Anton
