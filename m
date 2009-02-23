Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbZBWGQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbZBWGQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 01:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZBWGQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 01:16:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59420 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZBWGQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 01:16:06 -0500
Date: Mon, 23 Feb 2009 07:34:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
Message-ID: <20090223063406.GS26292@one.firstfloor.org>
References: <873ae6wgd6.fsf@basil.nowhere.org> <20090222.201152.169082487.davem@davemloft.net> <20090223045159.GR26292@one.firstfloor.org> <20090222.215906.240407314.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222.215906.240407314.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Look at the fallback logic, the pure NMI profiler can fail for
> a number of reasons, not just because the watchdog is in
> I/O APIC mode.

I assume you mean nmi_init? It doesn't check for the watchdog at all,
just if it knows the CPU and if it can profile
All the reasons it fails on (unknown CPU, no APIC) will imply that the lapic 
based watchdog won't run either, because it relies on the same
perfctr hardware. The only case where it could fall into 
this path is in IO-APIC nmi watchdog mode (and unknown CPU) and then again 
the IO-APIC watchdog doesn't do the multiple frequencies thing, it always
runs with HZ.

Admittedly the logic is quite obscure.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
