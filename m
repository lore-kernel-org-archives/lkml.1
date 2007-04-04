Return-Path: <linux-kernel-owner+w=401wt.eu-S2992907AbXDDNML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992907AbXDDNML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992906AbXDDNML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:12:11 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:58473 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992902AbXDDNMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:12:09 -0400
Date: Wed, 4 Apr 2007 14:12:05 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Francois Romieu <romieu@fr.zoreil.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-Reply-To: <20070403205744.GB12969@electric-eye.fr.zoreil.com>
Message-ID: <Pine.LNX.4.64.0704041342390.3963@sheep.housecafe.de>
References: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
 <20070403205744.GB12969@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Francois Romieu wrote:
> Christian Kujau <evil@g-house.de> :
> If the apic voodoo makes no difference, you can:
> 1 - leave it enabled

Well, we tried to boot with ACPI compiled in again, but disabled during 
boot:

- acpi=off lapic, crashed after 1h (almost exactly) of service
- acpi=off lapic, crashed again, this time after 4h (almost exactly)
- acpi=off noapic, still running, now 21h.

The 2nd node has been booted with 'noapic' and ACPI *not* compiled in 
and is now running for 2,5 days. However, interrupts are not shared 
between cores.

This means we still have to test booting with 'lapic' and ACPI enabled. 
Unfortnately there are a few more sub-options to choose from:

     - acpi=force -- enable ACPI if default was off
     - acpi=noirq -- do not use ACPI for IRQ routing
     - acpi=ht -- run only enough ACPI to enable Hyper Threading
     - acpi=strict -- Be less tolerant of platforms that are
                      not strictly ACPI specification compliant.

> 2 - check that netconsole is not used with the 8139 (it is busted)
> 3 - check that netconsole is not used at all

Actually I was thinking about *using* netconsole, since even setting up 
remote (userspace-)syslog left nothing on the syslog-server, when the 
machine crashed. But if it's b0rked in 8139, I will refrain from doing 
so.

> 4 - try:
>    http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.21-rc5/r8169-20070402

Are they in -rc5 yet or 'not in -rc5 but should be applied to -rc5'?

Thanks for your time,
Christian.
-- 
BOFH excuse #235:

The new frame relay network hasn't bedded down the software loop transmitter yet.
