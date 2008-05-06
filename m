Return-Path: <linux-kernel-owner+w=401wt.eu-S1765805AbYEFWgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765805AbYEFWgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYEFWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:36:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbYEFWgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:36:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: libata regression in current -git
Date: Wed, 7 May 2008 00:35:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
References: <480D6A25.2040206@trash.net>
In-Reply-To: <480D6A25.2040206@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070035.59272.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of April 2008, Patrick McHardy wrote:
> I bisected a boot-failure with sata-sis back to this libata-change:

Has the problem been fixed in 2.6.26-rc1 or in the current -git?

> ---
> libata: clear SError after link resume
> 
> SError used to be cleared in ->postreset.  This has small hotplug race
> condition.  If a device is plugged in after reset is complete but
> postreset hasn't run yet, its hotplug event gets lost when SError is
> cleared.  This patch makes sata_link_resume() clear SError.  This
> kills the race condition and makes a lot of sense as some PMP and host
> PHYs don't work properly without SError cleared.
> 
> This change makes sata_pmp_std_{pre|post}_reset()'s unnecessary as
> they become identical to ata_std counterparts.  It also simplifies
> sata_pmp_hardreset() and ahci_vt8251_hardreset().
> ---
> 
> Whats happening is that sata_scr_read() in sata_link_resume()
> returns -1 and the reset never completes. Ignoring the return
> value as before this patch makes it work for me again.
> 
> This is lspci-output of the controller, dmesg of a working and
> non-working boot and .config are attached.
> 
> If you need further information or want me to test something,
> please let me know.
> 
> 
> 00:05.0 RAID bus controller: Silicon Integrated Systems [SiS] RAID bus 
> controller 180 SATA/PATA  [SiS] (rev 01) (prog-if 85)
>          Subsystem: ASUSTeK Computer Inc. Unknown device 810e
>          Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>          Latency: 128
>          Interrupt: pin A routed to IRQ 17
>          Region 0: I/O ports at eff0 [size=8]
>          Region 1: I/O ports at efe4 [size=4]
>          Region 2: I/O ports at efa8 [size=8]
>          Region 3: I/O ports at efe0 [size=4]
>          Region 4: I/O ports at ef90 [size=16]
>          Region 5: I/O ports at <unassigned>
>          Kernel driver in use: sata_sis
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
