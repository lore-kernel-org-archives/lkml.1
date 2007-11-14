Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbXKNQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbXKNQjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXKNQjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:39:06 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:22041 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXKNQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:39:05 -0500
X-IronPort-AV: E=Sophos;i="4.21,417,1188802800"; 
   d="scan'208";a="15562532"
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
X-Message-Flag: Warning: May contain useful information
References: <ada1wb05p6n.fsf@cisco.com> <s5hbq9zyktm.wl%tiwai@suse.de>
	<adak5on2yd6.fsf@cisco.com> <s5hwssnvaw1.wl%tiwai@suse.de>
	<adafxzb2tf3.fsf@cisco.com> <s5hhcjqhkty.wl%tiwai@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Nov 2007 08:39:03 -0800
In-Reply-To: <s5hhcjqhkty.wl%tiwai@suse.de> (Takashi Iwai's message of "Tue, 13 Nov 2007 04:43:05 +0100")
Message-ID: <ada3av8234o.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Nov 2007 16:39:04.0292 (UTC) FILETIME=[DE37D240:01C826DC]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Roland Dreier wrote:
 > > > >     [ 2311.759856] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 21
 > > > >     [ 2311.759866] hda_intel: probe_mask set to 0x1 for device 17aa:2010
 > > > >     [ 2311.759886] PCI: Setting latency timer of device 0000:00:1b.0 to 64
 > > > >     [ 2312.911309] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x003f000c

 > Anyway, could you try the patch below?  As far as I see, it's the only
 > part that may access PINCAP verb for that NID.

This seems to help in that I don't see the "azx_get_response timeout"
message on every module load as I do with mainline, but I still see a
problem with a different cmd after a few load-unload cycles:

[  257.503143] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[  259.215359] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
[  259.215372] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[  259.215398] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  263.418591] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[  265.626093] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
[  265.626105] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[  265.626133] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  320.898290] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[  322.874182] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
[  322.874196] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[  322.874228] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  333.087177] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[  334.024358] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
[  334.024371] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[  334.024395] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  335.422296] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x002f0d00

Thanks,
  Roland
