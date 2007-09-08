Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXIHEMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXIHEMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 00:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbXIHEMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 00:12:37 -0400
Received: from [212.12.190.17] ([212.12.190.17]:32903 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbXIHEMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 00:12:36 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Why do so many machines need "noapic"?
Date: Sat, 8 Sep 2007 07:12:51 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709080712.51339.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 09/06/2007 07:31 AM, Andi Kleen wrote:
> > Chuck Ebbert <cebbert@redhat.com> writes:
> >> Some systems lock up without the noapic option.
> >
> > Please find patterns: cpu type, chipsets, mainboard vendors etc.
>
> This is the first one I've actually had in front of me:
>
>   HP TX1000 notebook
>   Nvidia C51/MCP51 mobile chipset
>
> Booting with "noapic" gives some very strange results. This is two
> snapshots of /proc/interrupts taken one second apart. It almost looks
> like timer interrupts are occurring on IRQ 0 and IRQ7 on different
> CPUs:
>
>            CPU0       CPU1
>   0:     446096       6224    XT-PIC-XT        timer
>   1:        342          6    XT-PIC-XT        i8042
>   2:          0          0    XT-PIC-XT        cascade
>   5:       3099        865    XT-PIC-XT        sata_nv
>   7:       8145     494718    XT-PIC-XT        ehci_hcd:usb2
>   8:          0          0    XT-PIC-XT        rtc0
>   9:        323          9    XT-PIC-XT        acpi
>  10:        136         36    XT-PIC-XT        HDA Intel
>  11:      43884       1091    XT-PIC-XT        ohci_hcd:usb1, eth0
>  12:        104         19    XT-PIC-XT        i8042
>  14:       1011         25    XT-PIC-XT        libata
>  15:          0          0    XT-PIC-XT        libata
> NMI:          0          0
> LOC:       6212     445951
> ERR:     403241
> MIS:          0

You may want to try to reconfigure your bios to reserve irq 5/7 for isa only.

Then post /proc/interrupts again.


Thanks!

--
Al

