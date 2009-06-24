Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZFXKcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZFXKcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbZFXKc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:32:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44305
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbZFXKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:32:28 -0400
Date: Wed, 24 Jun 2009 03:32:33 -0700 (PDT)
Message-Id: <20090624.033233.170094460.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624102325.GN6760@one.firstfloor.org>
References: <20090624075342.GL6760@one.firstfloor.org>
	<20090624.024428.215194313.davem@davemloft.net>
	<20090624102325.GN6760@one.firstfloor.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 24 Jun 2009 12:23:25 +0200

>> And similarly to sparc64, if that 5+ second qla2xxx interrupt
>> sequence happens after the tick_nohz_stop_sched_tick() call
>> we can run into the same situation.
> 
> Yes it would be probably safer to do the tick disabling with
> interrupts off already.

That only makes sense if you're really putting the cpu to sleep
until an interrupt or similar happens.

Here in this sparc64 case I'm not, I just spin waiting for the exit
from cpu_idle() conditions.

I'll think more about how I'll handle this.  It's at least a relief to
understand exactly what causes this issue now :-)

> These days NMI watchdog is not used much on x86 anymore because it's 
> default off, so probably people never noticed that.

I really didn't want to provide the feature that way on sparc64 which
is why I made it on by default.  It would be interesting to reconsider
x86's default, perhaps even only on a trial basis in -next.

It's so useful, and in the short time sparc64 has had this NMI code I
can count at least 8 bugs I've fixed only because it was on all the
time.
