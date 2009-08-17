Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZHQVbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZHQVbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZHQVbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:31:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56585 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZHQVbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:31:17 -0400
Date: Mon, 17 Aug 2009 23:31:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Mark Kelly <mark@bifferos.com>, linux-kernel@vger.kernel.org,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
Message-ID: <20090817213118.GA24747@one.firstfloor.org>
References: <58001.1250437590@bifferos.com> <20090816155507.GA2791@elte.hu> <alpine.LNX.2.00.0908160317250.19588@cent.localnet> <20090816175204.GA28553@elte.hu> <alpine.LNX.2.00.0908160404300.20653@cent.localnet> <4A899A1D.8060808@zytor.com> <20090817180825.GA5558@elte.hu> <4A899FEA.9020707@zytor.com> <871vnas2gn.fsf@basil.nowhere.org> <4A89A724.406@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89A724.406@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It isn't a matter of if compilation works, it is a matter of if we

I was actually wrong -- someone moved the functions out of line.
So CONFIG_PCI is needed after all.

> should even try to probe PCI if the user has explicitly disabled
> CONFIG_PCI.  arch/x86/kernel/cpu/cyrix.c disables its PCI probing if
> CONFIG_PCI is off, even though it also uses <asm/pci-direct.h>.

Better would be if he used early_pci_allowed() then this could
be set at runtime.

> Given that the benefit of this CPU detection patch is extremely small
> (all it does it get better information in /proc/cpuinfo) and that blind
> probing can have disastrous consequences, I would say it should not.

I thought it was to prevent oopses for zero cpu according
to the reporter?

But these oopses should be probably separately fixed anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
