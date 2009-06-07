Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZFGVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZFGVU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZFGVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:20:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZFGVUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:20:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: usb fails to suspend [was: mmotm 2009-06-05-16-19]
Date: Sun, 7 Jun 2009 23:20:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <4A2AA469.5020709@gmail.com> <200906070028.32631.rjw@sisk.pl> <4A2C24E3.5090609@gmail.com>
In-Reply-To: <4A2C24E3.5090609@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072320.24548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Jiri Slaby wrote:
> On 06/07/2009 12:28 AM, Rafael J. Wysocki wrote:
> > On Saturday 06 June 2009, Jiri Slaby wrote:
> >> Hi,
> >>
> >> there is a suspend regression somewhere between mmotm 2009-05-17-12-15
> >> and 2009-06-05-16-19:
> >> hcd_pci_suspend_noirq(): pci_prepare_to_sleep+0x0/0x80 returns -19
> >> pci_pm_suspend_noirq(): hcd_pci_suspend_noirq+0x0/0xb0 returns -19
> >> pm_noirq_op(): pci_pm_suspend_noirq+0x0/0x180 returns -19
> >> PM: Device 0000:00:1d.2 failed to suspend late: error -19
> >>
> >> $ lspci -xxvvs 0000:00:1d.2
> >> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> >> Controller #3 (rev 02) (prog-if 00 [UHCI])
> >>         Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI
> >> Controller #3
> >>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> >> ParErr- Stepping- SERR- FastB2B- DisINTx-
> >>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> >> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>         Latency: 0
> >>         Interrupt: pin D routed to IRQ 16
> >>         Region 4: I/O ports at d000 [size=32]
> >>         Capabilities: [50] Vendor Specific Information <?>
> >>         Kernel driver in use: uhci_hcd
> >> 00: 86 80 36 29 05 00 90 02 02 00 03 0c 00 00 00 00
> >> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >> 20: 01 d0 00 00 00 00 00 00 00 00 00 00 86 80 36 29
> >> 30: 00 00 00 00 50 00 00 00 00 00 00 00 05 04 00 00
> >>
> >> Any ideas?
> > 
> > Not really.  Is it -mm-only or is the mainline affected too?
> 
> Yup, only an -mm thing. I reverted these two:
> pci-pm-read-device-power-state-from-register-after-updating-it.patch
> pci-pm-read-device-power-state-from-register-after-updating-it-update.patch
> and it works now :).

OK, thanks.

Andrew, can you drop these two patches from -mm please?

Best,
Rafael
