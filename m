Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYDFGYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYDFGYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 02:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYDFGYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 02:24:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbYDFGY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 02:24:28 -0400
Date: Sat, 5 Apr 2008 23:23:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Realtek 8111c weirdness problems, apic/msi, and normal bug
Message-Id: <20080405232354.57ff2fac.akpm@linux-foundation.org>
In-Reply-To: <1207407804.14885.27.camel@localhost>
References: <1207407804.14885.27.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let's add some cc's.

On Sat, 05 Apr 2008 17:03:24 +0200 Kasper Sandberg <lkml@metanurb.dk> wrote:

> Hello.
> 
> I have a Gigabyte-X48-DQ6 motherboard which contains two realtek 8111c
> pci express gigabit ethernet controllers.
> 
> The driver for these are r8169
> 
> To cut to the results that matters(IMO) most, is that on .25-rc8-git3,
> the driver detects these cards, both of them, on different interrupts,
> however, none of the nics work if i have both msi and apic enabled. If i
> boot with pci=nomsi, and apic is enabled, both ports work (however one
> "insignificant" bug remains), if i boot with noapic boot parameter, but
> msi is enabled, both controllers are again found, and they work, however
> that insignificant bug is also present here.
> 
> The insignificant bug is, that one of the interfaces appears to always
> report as link up, despite me not having any cable in it.
> 
> So apparently the conflict is if i have BOTH apic and msi.
> 
> That leads me to a question, untill this is resolved, which
> configuration do i want? apic with no msi, or msi with no apic?
> 
> I also have some more information, however i do not know if its useful
> at all: On a .23 livecd, which has both msi and apic, something
> different happens. What happens is that both controllers are detected,
> however only 1 of them works, ethtool reports that the working
> controller properly detects link up/down, and that its TP with 1gbit.
> This is the ethtool output for the .23 livecd with apic and msi:
> Settings for eth0:
>         Supported ports: [ TP ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>         Supports auto-negotiation: Yes
>         Advertised link modes:  10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>         Advertised auto-negotiation: Yes
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: Twisted Pair
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: on
>         Supports Wake-on: pumbg
>         Wake-on: g
>         Current message level: 0x00000033 (51)
>         Link detected: yes
> 
> 
> Settings for eth1:
>         Supported ports: [ FIBRE ]
>         Supported link modes:   1000baseT/Full
>         Supports auto-negotiation: Yes
>         Advertised link modes:  Not reported
>         Advertised auto-negotiation: Yes
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: FIBRE
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: on
>         Supports Wake-on: pumbg
>         Wake-on: g
>         Current message level: 0x00000033 (51)
>         Link detected: no
> 
> and as you can see, eth1 is completely messed up, thinking its fibre,
> and stuff..
> 
> it appears that on this configuration, both nic's were registered
> in /proc/interrupts as IO-APIC-fasteoi.
> ---
> 
> I realize that more information will probably be needed to fix this bug,
> however, as you probably will want to cc linux-netdev or apic/msi or
> what it is, i will refrain from posting that now.
> 
> However, i can pretty much provide/try anything, so what would you want
> me to get?
> /proc/interrupts, dmesg, ethtool on .25 apic/nomsi?
> /proc/interrupts, dmesg, ethtool on .25 msi/noapic?
> /proc/interrupts, dmesg, ethtool on .25 msi/apic?
> i also saw a strange message with .25 msi/apic, where when i rmmod r8169
> and modprobe it again, it couldnt parse something, should i try get this
> again?
> 
> 
> In any case, just let me know what information you want, or patches you
> wish me to test, and it will be done.
> 

