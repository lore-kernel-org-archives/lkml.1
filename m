Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYFXSRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYFXSRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYFXSRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:17:04 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57347 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYFXSRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:17:03 -0400
Date: Tue, 24 Jun 2008 20:16:56 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Subject: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter -
	disabling IRQ
Message-ID: <20080624181656.GB14243@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using my brand new HP 8510w laptop with kernel 2.6.25 (Debian kernel 
2.6.25-2-amd64 version 2.6.25-5 to be exact) and the integrated memory 
card reader is detected by the sdhci kernel module.

However, about 10 minutes after boot I get the following message in 
dmesg (pid and process may change of course):

[  697.844419] irq 19: nobody cared (try booting with the "irqpoll" option)
[  697.844434] Pid: 6068, comm: ca-certificates Tainted: G       A 2.6.25-2-amd64 #1
[  697.844439] 
[  697.844441] Call Trace:
[  697.844445]  <IRQ>  [<ffffffff8024ded6>] tick_handle_oneshot_broadcast+0x9e/0xce
[  697.844501]  [<ffffffff8026ca2f>] __report_bad_irq+0x30/0x72
[  697.844511]  [<ffffffff8026cc6e>] note_interrupt+0x1fd/0x23f
[  697.844531]  [<ffffffff8026d4fb>] handle_fasteoi_irq+0xa5/0xc8
[  697.844548]  [<ffffffff8020f41c>] do_IRQ+0x6d/0xd9
[  697.844559]  [<ffffffff8020c34d>] ret_from_intr+0x0/0x19
[  697.844564]  <EOI> 
[  697.844589] handlers:
[  697.844592] [<ffffffff883079e4>] (sdhci_irq+0x0/0x609 [sdhci])
[  697.844607] Disabling IRQ #19

(the "taint" comes from a custom DSDT which adjusts fan speeds and 
nothing more).

lspci says:
02:06.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b9)
02:06.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b9)
02:06.2 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 03)
02:06.3 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 20)
02:06.4 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff)

lspci -n says:
02:06.0 0607: 1180:0476 (rev b9)
02:06.1 0607: 1180:0476 (rev b9)
02:06.2 0c00: 1180:0832 (rev 03)
02:06.3 0805: 1180:0822 (rev 20)
02:06.4 0880: 1180:0843 (rev ff)

Any suggestions?

-- 
David Härdeman
