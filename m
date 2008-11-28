Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYK1WS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYK1WS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYK1WSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:18:20 -0500
Received: from cpsmtpo-eml02.KPNXCHANGE.COM ([213.75.38.151]:9459 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbYK1WST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:18:19 -0500
From: Frans Pop <elendil@planet.nl>
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq
Date: Fri, 28 Nov 2008 23:18:13 +0100
User-Agent: KMail/1.9.9
Cc: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Pierre Ossman <drzeus@drzeus.cx>, Matthew Garrett <mjg59@srcf.ucam.org>
References: <492DFB39.1050503@overt.org>
In-Reply-To: <492DFB39.1050503@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811282318.14171.elendil@planet.nl>
X-OriginalArrivalTime: 28 Nov 2008 22:18:14.0523 (UTC) FILETIME=[34DFA4B0:01C951A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008, Philip Langdale wrote:
> I based this change on top of my previous fix for the new chip but it
> will apply successfully to the original tree. There's still merit in
> considering the quirk idea but this is the simplest fix and it works
> (for my machine, at least :-)

It seems to work for me too.

I also see now what's wrong when I suspend/resume with a partition
mounted: after resume the device appears as /dev/mmcblk1 instead of
the /dev/mmcblk0 it was before suspending and of course that causes
errors when you try to access the mounted partition.

When I suspend/resume without a partition mounted it remains at
/dev/mmcblk0.

I'm not 100% sure this was also the case when I tested Matthew's patch
(I can't remember checking for that), but I would guess so.


With a partition mounted I get during suspend:
pci 0000:00:02.0: PCI INT A disabled
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
mmc0: card 8879 removed
MMC: killing requests for dead queue
ACPI handle has no context!
sdhci-pci 0000:02:06.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:10:00.0: PCI INT A disabled
[...]
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.

And during resume:
Back to C!
Extended CMOS year: 2000
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
Enabling non-boot CPUs ...
[...]
sdhci-pci 0000:02:06.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x0, writing 0xe0102000)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
mmc0: new SD card at address 8879
mmcblk1: mmc0:8879 SU02G 1.89 GiB
 mmcblk1: p1 p2 < p5 >

The messages "Controller is now re-enabled/disabled" are a bit confusing
during suspend/resume. Users may well wonder why a controller should get
enabled during suspend...

Feel free to add my:
Tested-by: Frans Pop <elendil@planet.nl>

Cheers,
FJP
