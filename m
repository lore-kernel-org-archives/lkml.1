Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYBZGjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYBZGjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYBZGjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:39:08 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbYBZGjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:39:06 -0500
Date: Mon, 25 Feb 2008 22:38:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Connors <tconnors@astro.swin.edu.au>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl4965 dropping packets and __dev_addr_discard: address
 leakage! da_users=1
Message-Id: <20080225223823.db13a7fe.akpm@linux-foundation.org>
In-Reply-To: <slrn-0.9.7.4-5027-27940-200802261551-tc@hexane.ssi.swin.edu.au>
References: <slrn-0.9.7.4-5027-27940-200802261551-tc@hexane.ssi.swin.edu.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 16:22:43 +1100 Tim Connors <tconnors@astro.swin.edu.au> wrote:

> Possibly because of the frequent renegotiating my iwl4965 card has
> been making, it has now decided it's not going to pass packets
> reliably until presumably next time I reboot.
> 
> I've noticed messages in syslog that I hadn't seen when things were
> working fine.  The problem possibly has only surfaced after rmmodding
> the iwl4965 module, then remodding it.  It stays with me through being
> removed and modprobed again.  It is being bonded in conjunction with a
> physical ethernet, if that is relevant, although I think I reproduced
> it when it was on its lonesome.
> 
> 
> Fresh after reboot:
> 
> Feb 22 09:49:31 dirac kernel: iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.1.17kds
> Feb 22 09:49:31 dirac kernel: iwl4965: Copyright(c) 2003-2007 Intel Corporation
> Feb 22 09:49:31 dirac kernel: ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> Feb 22 09:49:31 dirac kernel: PCI: Setting latency timer of device 0000:0c:00.0 to 64
> Feb 22 09:49:31 dirac kernel: iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> Feb 22 09:49:31 dirac kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
> Feb 22 09:49:31 dirac kernel: PCI: Setting latency timer of device 0000:00:1b.0 to 64
> Feb 22 09:49:31 dirac kernel: iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
> Feb 22 09:49:31 dirac kernel: phy0: Selected rate control algorithm 'iwl-4965-rs'
> 
> now finished with it, will be deconfigured and rmmodded:
> 
> Feb 23 03:05:23 dirac kernel: __dev_addr_discard: address leakage! da_users=1
> Feb 23 03:05:23 dirac kernel: ACPI: PCI interrupt for device 0000:0c:00.0 disabled
> 
> The modprobed again:
> 
> Feb 23 03:05:35 dirac kernel: iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.1.17kds
> Feb 23 03:05:35 dirac kernel: iwl4965: Copyright(c) 2003-2007 Intel Corporation
> Feb 23 03:05:35 dirac kernel: ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> Feb 23 03:05:35 dirac kernel: PCI: Setting latency timer of device 0000:0c:00.0 to 64
> Feb 23 03:05:35 dirac kernel: iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> Feb 23 03:05:35 dirac kernel: iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
> Feb 23 03:05:35 dirac kernel: phy9: Selected rate control algorithm 'iwl-4965-rs'
> 
> according to lspci -vvv, 0c:00.0 is:
> 
> 0c:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
>         Subsystem: Intel Corporation Unknown device 1120
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 379
>         Region 0: Memory at f9ffe000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [c8] Power Management version 3
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
>                 Address: 00000000fee0300c  Data: 4194
>         Capabilities: [e0] Express (v1) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
>                         ClockPM+ Suprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [100] Advanced Error Reporting <?>
>         Capabilities: [140] Device Serial Number d7-36-9b-ff-ff-e8-13-00
>         Kernel driver in use: iwl4965
>         Kernel modules: iwl4965

(cc linux-wireless)

What kernel version is this?

Is this a regression from an earlier kenrel version?  If so, which?
