Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYLBF5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYLBF5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 00:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYLBF5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 00:57:07 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:2762 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbYLBF5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 00:57:06 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Tue, 2 Dec 2008 06:56:59 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812012037320.3256@nehalem.linux-foundation.org> <200812020629.26714.elendil@planet.nl>
In-Reply-To: <200812020629.26714.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812020657.02173.elendil@planet.nl>
X-OriginalArrivalTime: 02 Dec 2008 05:57:02.0787 (UTC) FILETIME=[CC3CA130:01C95442]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008, Frans Pop wrote:
> +yenta_cardbus 0000:02:06.0: CardBus bridge, secondary bus 0000:03
> +yenta_cardbus 0000:02:06.0:   IO window: 0x003000-0x0030ff
> +yenta_cardbus 0000:02:06.0:   IO window: 0x003400-0x0034ff
> +yenta_cardbus 0000:02:06.0:   PREFETCH window: 0x84400000-0x847fffff
> +yenta_cardbus 0000:02:06.0:   MEM window: 0x80000000-0x83ffffff

Wild speculation, but could all this possibly also be related to occasional
"irq 19: nobody cared" errors I'm seeing on resume for ohci1394?

My FireWire controller is sitting behind this bridge after all.

Here's an example:
Dec  2 04:57:32 aragorn kernel: irq 19: nobody cared (try booting with the "irqpoll" option)
Dec  2 04:57:32 aragorn kernel: Pid: 0, comm: swapper Not tainted 2.6.28-rc6 #57
Dec  2 04:57:32 aragorn kernel: Call Trace:
Dec  2 04:57:32 aragorn kernel:  <IRQ>  [<ffffffffa01009e1>] ? ohci_irq_handler+0x60/0x7e9 [ohci1394]
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8026aa29>] __report_bad_irq+0x38/0x87
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8026ab86>] note_interrupt+0x10e/0x174
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8026b23e>] handle_fasteoi_irq+0xa7/0xd1
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8020eb87>] do_IRQ+0x73/0xe4
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8020c626>] ret_from_intr+0x0/0xa
Dec  2 04:57:32 aragorn kernel:  <EOI>  [<ffffffffa0012606>] ? acpi_idle_enter_bm+0x26b/0x2b2 [processor]
Dec  2 04:57:32 aragorn kernel:  [<ffffffffa00125fc>] ? acpi_idle_enter_bm+0x261/0x2b2 [processor]
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8024f33b>] ? notifier_call_chain+0x33/0x5b
Dec  2 04:57:32 aragorn kernel:  [<ffffffff803b9ca4>] ? cpuidle_idle_call+0x8c/0xc4
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8020b312>] ? cpu_idle+0x4a/0x9a
Dec  2 04:57:32 aragorn kernel:  [<ffffffff8042c528>] ? rest_init+0x5c/0x5e
Dec  2 04:57:32 aragorn kernel: handlers:
Dec  2 04:57:32 aragorn kernel: [<ffffffffa0100981>] (ohci_irq_handler+0x0/0x7e9 [ohci1394])
Dec  2 04:57:32 aragorn kernel: Disabling IRQ #19

I can send full kernel log from the start of that boot if desired.

Cheers,
FJP
