Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbYDWBf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbYDWBf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYDWBfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:35:12 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:64472 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbYDWBfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aOJ2L9+5b5Ofy1J7rpRLKyRVyBK0WwgaQImeztZhnfzGaC9QDlN7Y8++7BEv27babm/OJeKTD+MJtQBr5oKuRZmPXVi7SCCnuNuJ4IEvEop/Vry/Gy99si+Xfb4ibvC6dx2X/fwcUvDsJBUYBiLcrwlppXnLqjmU2eiAVhdx/rE=
Message-ID: <480E9246.1060105@gmail.com>
Date: Wed, 23 Apr 2008 10:35:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [bisected] Latest git not seeing HD with sata_nv
References: <adazlrlcw9f.fsf@cisco.com>
In-Reply-To: <adazlrlcw9f.fsf@cisco.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> It seems that commit 305d2a1a ("libata: unify mechanism to request
> follow-up SRST") causes sata_nv not to see the HD on a system I have
> here; with current git (80750147), I get this in my bootlog:
> 
> [    2.425108] Driver 'sd' needs updating - please use bus_type methods
> [    2.435751] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
> [    2.441508] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
> [    2.452929] sata_nv 0000:00:05.0: Using SWNCQ mode
> [    2.457892] scsi0 : sata_nv
> [    2.461813] scsi1 : sata_nv
> [    2.465891] ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 23
> [    2.473034] ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 23
> [    2.565962] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.003517] ata2: SATA link down (SStatus 0 SControl 300)
> [    3.137171] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
> [    3.142926] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 22 (level, low) -> IRQ 22
> [    3.151675] sata_nv 0000:00:05.1: Using SWNCQ mode
> [    3.156582] scsi2 : sata_nv
> [    3.160553] scsi3 : sata_nv
> 
> ie no HD is found, even thought he ata1 link comes up, which of course
> leads to:
> 
> [    4.763274] VFS: Cannot open root device "sda1" or unknown-block(0,0)
> [    4.769724] Please append a correct "root=" boot option; here are the available partitions:
> 
> and the system is dead.
> 
> I did a bisection and came up with 305d2a1a as the culprit.  Then I
> applied the revert patch below by hand (since 305d2a1a doesn't revert
> entirely cleanly), and things worked again:

Thanks for the bisection.  Hmmm... it's not supposed to change probe 
behavior (well, of course).  I'll try to reproduce the problem here and 
report back.

-- 
tejun
