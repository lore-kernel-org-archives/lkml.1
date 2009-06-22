Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZFVJ15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZFVJ15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZFVJ1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:27:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32897
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbZFVJ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:27:48 -0400
Date: Mon, 22 Jun 2009 02:27:52 -0700 (PDT)
Message-Id: <20090622.022752.219499742.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <87bpog3clx.fsf@basil.nowhere.org>
References: <20090622.002722.53993293.davem@davemloft.net>
	<87bpog3clx.fsf@basil.nowhere.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon, 22 Jun 2009 10:18:50 +0200

> David Miller <davem@davemloft.net> writes:
>>
>> Is there something fundamental that should be preventing this?
> 
> Unless that changed recently when I wasn't looking NOHZ should only
> stop timers when the CPU is idle. So when a driver is doing
> something and the interrupts are not disabled for too long the timers
> should be ticking.
> 
> Then when you're idle interrupts should be never off, so the NMI
> watchdog cannot fire. On x86 often the NMI watchdog is in fact
> stopped on idle.

Thanks Andi.

I think something else is afoot, because while using "nohz=off" makes
the problem go away, simply adding a NMI watchdog touch after the
schedule() call in cpu_idle() does not make the problem go away.

Also, the cpu that gets the NMI watchdog is different from the cpu
running the qla2xxx driver init.   That basically destroys the bulk
of my theory :-)
