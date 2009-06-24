Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZFXK7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZFXK7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZFXK7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:59:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46487
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800AbZFXK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:59:09 -0400
Date: Wed, 24 Jun 2009 03:59:14 -0700 (PDT)
Message-Id: <20090624.035914.156829493.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624105223.GO6760@one.firstfloor.org>
References: <20090624102325.GN6760@one.firstfloor.org>
	<20090624.033233.170094460.davem@davemloft.net>
	<20090624105223.GO6760@one.firstfloor.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 24 Jun 2009 12:52:23 +0200

> On Wed, Jun 24, 2009 at 03:32:33AM -0700, David Miller wrote:
>> From: Andi Kleen <andi@firstfloor.org>
>> Date: Wed, 24 Jun 2009 12:23:25 +0200
>> 
>> >> And similarly to sparc64, if that 5+ second qla2xxx interrupt
>> >> sequence happens after the tick_nohz_stop_sched_tick() call
>> >> we can run into the same situation.
>> > 
>> > Yes it would be probably safer to do the tick disabling with
>> > interrupts off already.
>> 
>> That only makes sense if you're really putting the cpu to sleep
>> until an interrupt or similar happens.
> 
> That is what the idle loop is supposed to do, isn't it?

Some sparc64 cpu's don't have a yield, and therefore can't
truly "sleep" during this loop.  That's what I'm talking
about.

>> > These days NMI watchdog is not used much on x86 anymore because it's 
>> > default off, so probably people never noticed that.
>> 
>> I really didn't want to provide the feature that way on sparc64 which
>> is why I made it on by default.  It would be interesting to reconsider
>> x86's default, perhaps even only on a trial basis in -next.
> 
> The reason it was turned off is that there are a few systems (e.g.
> laptops from a particular vendor) which don't handle NMIs correctly
> in the platform. When the NMI happens while SMI is active
> they hang. Also there were a few other strange problems
> on other systems that went away when it was disabled.

I wonder how many of those "few other strange problems" were of
the variety I'm diagnosing here :-)

Yes, it's a messy problem to turn on by default on x86 then.

Is this realm of systems-with-NMI-issues exclusive to x86-32 
or would it be more doable to turn it on by default for 64-bit
x86 builds?
