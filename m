Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYCDIht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYCDIht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760143AbYCDIfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:35:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760394AbYCDIfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:35:39 -0500
Date: Tue, 4 Mar 2008 09:35:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: travis@sgi.com, tglx@linutronix.de, ak@suse.de, clameter@sgi.com,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] x86_64: Cleanup non-smp usage of cpu maps v3
Message-ID: <20080304083507.GE5689@elte.hu>
References: <20080219203335.866324000@polaris-admin.engr.sgi.com> <20080219203336.177905000@polaris-admin.engr.sgi.com> <20080303170235.4334e841.akpm@linux-foundation.org> <20080303173011.b0d9a89d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303173011.b0d9a89d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I now recall that it has been happening on every fifth-odd boot for a 
> few weeks now.  The machine prints
> 
> Time: tsc clocksource has been installed
> 
> then five instances of "system 00:01: iomem range 0x...", then it 
> hangs. ie: it never prints "system 00:01: iomem range 
> 0xfe600000-0xfe6fffff has been reserved" from 
> http://userweb.kernel.org/~akpm/dmesg-akpm2.txt.
> 
> It may have some correlation with whether the machine was booted via 
> poweron versus `reboot -f', dunno.

the tsc thing seems to be an accidental proximity to me.

such a hard hang has a basic system setup feel to it: the PCI changes in 
2.6.25 or perhaps some ACPI changes. But it could also be timer related 
(although in that case it typically doesnt hang in the middle of a 
system setup sequence)

i'd say pci=nommconf, but your dmesg has this:

  PCI: Not using MMCONFIG.

but, what does seem to be new in your dmesg (i happen to have a historic 
dmesg-akpm2.txt of yours saved away) is:

  hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
  hpet0: 3 64-bit timers, 14318180 Hz

was hpet active on this box before? Try hpet=disable perhaps - does that 
change anything? (But ... this is still a 10% chance suggestion, there's 
way too many other possibilities for such bugs to occur.)

	Ingo
