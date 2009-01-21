Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbZAUQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbZAUQBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZAUQBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:01:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZAUQBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:01:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: [ACPI] GPE storm detected on FS Amilo Pro
Date: Wed, 21 Jan 2009 17:00:47 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: astarikovskiy@suse.de, len.brown@intel.com,
       LKML <linux-kernel@vger.kernel.org>
References: <4977352B.1040303@gmail.com>
In-Reply-To: <4977352B.1040303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211700.48357.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Jacek Luczak wrote:
> Hi All,

Hi Jacek,

> I've got that ,,GPE storm detected'' issue on my Fujitsu Siemens Amilo Pro
> notebook.  I was using 2.6.25.20 (which was fine) for a long while and recently
> started testing some latest git versions starting from 2.6.29-rc2 where I've
> discovered that issue. So I've made some back kernels and it shows up from
> 2.6.26 kernel. Bisection between 2.6.25 and 2.6.26 shows that patch:
> 
> fa95ba04e6ba11d71e1b87becd054b38faf546c8 is first bad commit
> commit fa95ba04e6ba11d71e1b87becd054b38faf546c8
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Fri Mar 21 19:36:02 2008 +0300
> 
>     ACPI: EC: Detect irq storm
> 
>     Problem seems to be that hw fails to clear GPE after we service it and write 1
>     into corresponding bit. Thus, as soon as we get interrupts enabled again, we
>     receive a new one. Google gives too many results for "acer interrupt storm" for
>     this being one-broken-machine case.
> 
>     Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9998
> 
>     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> The bug[1] (reopened recently) seems to be quite different than the one in my
> case. I've got no ,,side effects'' of that GPE storm. Notebook works fine and I
> didn't discovered any interrupts problems.

So everything appears to be OK except that your hardware has a problem,
which is correctly worked around and the message just tells you what happens.

> Up to 2.6.28 GPE storm information is printed early[2]:
> 
> Setting up standard PCI resources
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> ACPI: EC: GPE storm detected, disabling EC GPE
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: driver started in poll mode
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> 
> While recent git[3] which I'm now running, shows it after setting-up AC adapter[4]:
> 
> ACPI: AC Adapter [ADP1] (on-line)
> ACPI: EC: GPE storm detected, transactions will use polling mode
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
> ACPI: EC: missing confirmations, switch off interrupt mode.
> ACPI: Battery Slot [BAT0] (battery present)
> input: Power Button (FF) as /class/input/input0
> ACPI: Power Button (FF) [PWRF]
> input: Lid Switch as /class/input/input1
> ACPI: Lid Switch [LID0]
> input: Sleep Button (CM) as /class/input/input2
> ACPI: Sleep Button (CM) [SLPB]
> 
> I'm not sure if the origin of that GPE storm is the same in both cases. Will try
> to do bisection here later if needed.
> 
> NOTE: In git kernel I've noticed that after boot and obtaining IP from DHCP I've
> got such message:
> 
> Jan 21 14:44:32 difrost kernel: sky2 eth0: enabling interface
> Jan 21 14:44:33 difrost kernel: sky2 eth0: Link is up at 100 Mbps, full duplex,
> flow control rx
> Jan 21 14:45:36 difrost kernel: ACPI: EC: missing confirmations, switch off
> interrupt mode.
> 
> This is not fully reproducible, didn't shown on [4].

This may be related to the issue behind the GPM storm message.

Thanks,
Rafael
