Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbXGKBPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbXGKBPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbXGKBOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:14:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37437 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759653AbXGKBOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:14:47 -0400
Message-ID: <46942F02.2020204@garzik.org>
Date: Tue, 10 Jul 2007 21:14:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sata_promise: SATA hotplug support, take 2
References: <200707022309.l62N9597007667@harpo.it.uu.se>
In-Reply-To: <200707022309.l62N9597007667@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> This patch enables hotplugging of SATA devices in the
> sata_promise driver. It's been tested successfully on
> both first- and second-generation Promise SATA chips:
> SATA150 TX2plus, SATAII150 TX2plus, SATAII150 TX4,
> SATA300 TX2plus, and SATA300 TX4.
> 
> The only quirk I've seen is that hotplugging (insertion)
> on the first-generation SATA150 TX2plus requires a lengthier
> EH sequence than on the second-generation chips.
> On the second-generation chips a simple soft reset seems
> to suffice, but on the first-generation chip there's a
> "port is slow to respond" after the initial soft reset,
> after which libata issues a hard reset, and then the
> device is recognised.
> 
> The hotplug checks are high up in the interrupt handling
> path, not deep down in error_intr as in ahci/sata_sil24.
> That's because the chip doesn't signal hotplug status changes
> in the per-port status register: instead a global register
> contains hotplug control and status flags for all ports.
> I considered following the ahci/sata_sil24 structure, but
> that would have required non-trivial changes to the interrupt
> handling path, so I chose to keep the hotplug changes simple
> and unobtrusive.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> --
> This patch depends on the "sata_promise: cleanups" patch.
> 
> Changes since the previous version (posted June 19):
> - Correct pdc_interrupt() to increment 'handled' also in
>   the hotplug case. This prevents IRQ_NONE from being
>   returned when an interrupt only has hotplug events to
>   handle, which could confuse the kernel's IRQ machinery.
> - Added testing on the SATAII150 TX4.
> 
>  drivers/ata/sata_promise.c |   41 ++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 36 insertions(+), 5 deletions(-)

applied


