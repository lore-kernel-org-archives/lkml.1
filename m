Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbXAWJWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbXAWJWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932920AbXAWJWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:22:54 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:55278 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbXAWJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tIRYHJ5uG7RzzVCxBCWdVc1vZ01e5EUOuOEglC7n2odUwpn5CkpPZbq0BKS2QxP6E0iK2qK/ILK+CC0ZwN1F1HS+bcnzDnyY0ZWipJaLbgvOoebTyjCaSZp7PugHtPQG0lSE8/xady39HLdLXJoDCdfx1/7zqIGCpIu9yGiEScs=
Message-ID: <3877989d0701230122r426eb5b0h446c897780923d7a@mail.gmail.com>
Date: Tue, 23 Jan 2007 17:22:52 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: landwer@free.fr
Subject: Re: 2.6.19.2 sky2/acpi crashes
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1169542768.5537.11.camel@cocoduo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1169542768.5537.11.camel@cocoduo>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please try to remove processor module.

On 1/23/07, Lionel Landwerlin <landwer@free.fr> wrote:
> Hi,
>
> I'm running a macbook with a Marvell ethernet controller, and I have a
> lots of freezes when using the ethernet controller under a load of
> ~100K/s. Since I'm running a 2.6.19.2 kernel, I'm able to get some
> report from the kernel. Here they are :
>
> Jan 23 09:30:57 cocoduo kernel: [  662.920000] NETDEV WATCHDOG: eth0:
> transmit timed out
> Jan 23 09:30:57 cocoduo kernel: [  662.920000] sky2 eth0: tx timeout
> Jan 23 09:30:57 cocoduo kernel: [  662.920000] sky2 eth0: transmit ring
> 493 .. 471 report=494 done=494
> Jan 23 09:30:57 cocoduo kernel: [  662.920000] sky2 status report lost?
> Jan 23 09:31:06 cocoduo kernel: [  672.832000] BUG: soft lockup detected
> on CPU#0!
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [softlockup_tick
> +155/208] softlockup_tick+0x9b/0xd0
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [update_process_times
> +49/128] update_process_times+0x31/0x80
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]
> [smp_apic_timer_interrupt+145/176] smp_apic_timer_interrupt+0x91/0xb0
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [apic_timer_interrupt
> +31/36] apic_timer_interrupt+0x1f/0x24
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [_spin_lock_bh+18/32]
> _spin_lock_bh+0x12/0x20
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [pg0
> +946878101/1068803072] sky2_tx_timeout+0xf5/0x1d0 [sky2]
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [dev_watchdog+0/208]
> dev_watchdog+0x0/0xd0
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [dev_watchdog+192/208]
> dev_watchdog+0xc0/0xd0
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [run_timer_softirq
> +273/400] run_timer_softirq+0x111/0x190
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [__do_softirq+116/240]
> __do_softirq+0x74/0xf0
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [do_softirq+59/80]
> do_softirq+0x3b/0x50
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]
> [smp_apic_timer_interrupt+150/176] smp_apic_timer_interrupt+0x96/0xb0
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [apic_timer_interrupt
> +31/36] apic_timer_interrupt+0x1f/0x24
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [pg0
> +943208348/1068803072] acpi_processor_idle+0x1fd/0x3b9 [processor]
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [cpu_idle+116/208]
> cpu_idle+0x74/0xd0
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [start_kernel+872/1072]
> start_kernel+0x368/0x430
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  [unknown_bootoption
> +0/624] unknown_bootoption+0x0/0x270
> Jan 23 09:31:06 cocoduo kernel: [  672.832000]  =======================
>
> As most of the time, the keyboard gets locked and the network driver is
> down, I can get more informations.
>
> Here my hardware configuration :
>
> Apple Macbook 2GHz (x86, not amd64)
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
> 945GT Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile
> 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML
> Express Integrated Graphics Controller (rev 03)
> 00:07.0 Performance counters: Intel Corporation Unknown device 27a3 (rev
> 03)
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
> Definition Audio Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 2 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
> Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
> Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
> Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
> Serial ATA Storage Controller IDE (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
> (rev 02)
> 01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E
> Gigabit Ethernet Controller (rev 22)
> 02:00.0 Ethernet controller: Atheros Communications, Inc. Unknown device
> 001c (rev 01)
> 03:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61)
>
> I hope some fix could be released soon.
>
> --
> Lionel Landwerlin <landwer@free.fr>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
