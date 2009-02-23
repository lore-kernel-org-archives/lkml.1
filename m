Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZBWEeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZBWEeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZBWEeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:34:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZBWEeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:34:06 -0500
Date: Mon, 23 Feb 2009 05:52:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
Message-ID: <20090223045159.GR26292@one.firstfloor.org>
References: <20090129.155852.161923905.davem@davemloft.net> <873ae6wgd6.fsf@basil.nowhere.org> <20090222.201152.169082487.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222.201152.169082487.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, the code in nmi_timer_int.c doesn't.
> 
> It uses the NMI watchdog timer interrupts, it catches DIE_NMI
> events.
> 
> > Does that answer your question?
> 
> Not really.

Ah see what you mean now. The nmi_timer_int code can only
be active ever when the cpu is not known to nmi_int.c and 
when the nmi watchdog is in io apic mode. But IO apic mode
doesn't use the fast check/slowdown because it always runs
at HZ frequency. That only happens in LAPIC mode.

The standard fallback mode for unknown CPU is the non NMI timer 
fallback in oprofile_init, the IO APIC mode happens near never in practice.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
