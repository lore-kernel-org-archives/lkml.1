Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbYCEAqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbYCEAqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbYCEAqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:46:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780AbYCEAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:46:30 -0500
Date: Tue, 4 Mar 2008 16:45:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, tglx@linutronix.de, ak@suse.de, clameter@sgi.com,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] x86_64: Cleanup non-smp usage of cpu maps v3
Message-Id: <20080304164538.4de48630.akpm@linux-foundation.org>
In-Reply-To: <20080304083507.GE5689@elte.hu>
References: <20080219203335.866324000@polaris-admin.engr.sgi.com>
	<20080219203336.177905000@polaris-admin.engr.sgi.com>
	<20080303170235.4334e841.akpm@linux-foundation.org>
	<20080303173011.b0d9a89d.akpm@linux-foundation.org>
	<20080304083507.GE5689@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 09:35:07 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I now recall that it has been happening on every fifth-odd boot for a 
> > few weeks now.  The machine prints
> > 
> > Time: tsc clocksource has been installed
> > 
> > then five instances of "system 00:01: iomem range 0x...", then it 
> > hangs. ie: it never prints "system 00:01: iomem range 
> > 0xfe600000-0xfe6fffff has been reserved" from 
> > http://userweb.kernel.org/~akpm/dmesg-akpm2.txt.
> > 
> > It may have some correlation with whether the machine was booted via 
> > poweron versus `reboot -f', dunno.
> 
> the tsc thing seems to be an accidental proximity to me.
> 
> such a hard hang has a basic system setup feel to it: the PCI changes in 
> 2.6.25 or perhaps some ACPI changes. But it could also be timer related 
> (although in that case it typically doesnt hang in the middle of a 
> system setup sequence)
> 
> i'd say pci=nommconf, but your dmesg has this:
> 
>   PCI: Not using MMCONFIG.
> 
> but, what does seem to be new in your dmesg (i happen to have a historic 
> dmesg-akpm2.txt of yours saved away) is:
> 
>   hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
>   hpet0: 3 64-bit timers, 14318180 Hz
> 
> was hpet active on this box before? Try hpet=disable perhaps - does that 
> change anything? (But ... this is still a 10% chance suggestion, there's 
> way too many other possibilities for such bugs to occur.)
> 

I dunno - the machine does this rarely and today seems to be the day on
which it likes to produce its long-occurring doesnt-reboot-at-all problem,
which is different, and might be a BIOS thing.

Now current mainline is giving me this:

zsh: exec format error: /opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-gcc

and /usr/bin/sum matches that binary on a different machine.

I think I'll go home and knit a sweater or something.
