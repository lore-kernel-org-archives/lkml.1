Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZBWF7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZBWF7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 00:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZBWF7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 00:59:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52322
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbZBWF7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 00:59:25 -0500
Date: Sun, 22 Feb 2009 21:59:06 -0800 (PST)
Message-Id: <20090222.215906.240407314.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090223045159.GR26292@one.firstfloor.org>
References: <873ae6wgd6.fsf@basil.nowhere.org>
	<20090222.201152.169082487.davem@davemloft.net>
	<20090223045159.GR26292@one.firstfloor.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon, 23 Feb 2009 05:52:00 +0100

> > Again, the code in nmi_timer_int.c doesn't.
> > 
> > It uses the NMI watchdog timer interrupts, it catches DIE_NMI
> > events.
> > 
> > > Does that answer your question?
> > 
> > Not really.
> 
> Ah see what you mean now. The nmi_timer_int code can only
> be active ever when the cpu is not known to nmi_int.c and 
> when the nmi watchdog is in io apic mode. But IO apic mode
> doesn't use the fast check/slowdown because it always runs
> at HZ frequency. That only happens in LAPIC mode.
> 
> The standard fallback mode for unknown CPU is the non NMI timer 
> fallback in oprofile_init, the IO APIC mode happens near never in practice.

Look at the fallback logic, the pure NMI profiler can fail for
a number of reasons, not just because the watchdog is in
I/O APIC mode.

No matter what the failure reason, nmi_int.c is used.

And in some of those cases, the nmi_hz has been decreased to '1'.
