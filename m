Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbXLBVTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbXLBVTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXLBVT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:19:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXLBVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:19:27 -0500
Date: Sun, 2 Dec 2007 22:19:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202211925.GA26414@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202211027.GA32282@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202211027.GA32282@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 10:10:27PM +0100, Ingo Molnar wrote:
> what if you considered - just for a minute - the possibility of this 
> debug tool being the thing that actually animates developers to fix such 
> long delay bugs that have bothered users for almost a decade meanwhile?

Throwing frequent debugging messages for non buggy cases will
just lead to people generally ignore softlockups.

I don't think runtime instrumentation is the way to introduce
TASK_KILLABLE in general. The only way there is people going through
the source and identify places where it makes sense.

> 
> Until now users had little direct recourse to get such problems fixed. 
> (we had sysrq-t, but that included no real metric of how long a task was 

Actually task delay accounting can measure this now.  iirc someone
had a latencytop based on it already.

> blocked, so there was no direct link in the typical case and users had 
> no real reliable tool to express their frustration about unreasonable 
> delays.)
> 
> Now this changes: they get a "smoking gun" backtrace reported by the 
> kernel, and blamed on exactly the place that caused that unreasonable 
> delay. And it's not like the kernel breaks - at most 10 such messages 
> are reported per bootup.
> 
> We increase the delay timeout to say 300 seconds, and if the system is 
> under extremely high IO load then 120+ might be a reasonable delay, so 
> it's all tunable and runtime disable-able anyway. So if you _know_ that 
> you will see and tolerate such long delays, you can tweak it - but i can 

This means the user has to see their kernel log fill by such
messages at least once - do a round trip to some mailing list to 
explain that it is expected and not a kernel bug - then tweak
some obscure parameters. Doesn't seem like a particular fruitful
procedure to me.

> tell you with 100% certainty that 99.9% of the typical Linux users do 
> not characterize such long delays as "correct behavior".

It's about robustness, not the typical case.
Throwing backtraces when something slightly unusual happens is not a robust system.

-Andi
