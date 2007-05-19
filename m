Return-Path: <linux-kernel-owner+w=401wt.eu-S1763615AbXESQj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763615AbXESQj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXESQjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:39:20 -0400
Received: from neon.samage.net ([85.17.153.66]:52519 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbXESQjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:39:18 -0400
Message-ID: <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>
In-Reply-To: <464B3505.20004@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
Date: Sat, 19 May 2007 18:39:14 +0200 (CEST)
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Tejun Heo" <htejun@gmail.com>,
       jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 2394e6fd9f1e9f86011669f8146dc264
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Disabling sd_resume() gives me a "quick" resume again (few seconds),
though it doesn't get rid of the COMRESET errors:

[    2.476417] ata1: device not ready (errno=-19), forcing hardreset
[    2.476440] ata2: SATA link down (SStatus 0 SControl 310)
[    2.824896] usb_endpoint usbdev2.3_ep00: PM: resume from 0, parent 2-1 still 2
[    2.824902] usb 2-1:1.0: PM: resume from 2, parent 2-1 still 2
[    2.824906] usb 2-1:1.1: PM: resume from 2, parent 2-1 still 2
[    2.824910] usb 2-1:1.2: PM: resume from 2, parent 2-1 still 2
[    2.824914] usb_endpoint usbdev2.3_ep05: PM: resume from 0, parent 2-1:1.2 still 2
[    2.824919] usb_endpoint usbdev2.3_ep85: PM: resume from 0, parent 2-1:1.2 still 2
[    2.824923] usb_endpoint usbdev2.3_ep81: PM: resume from 0, parent 2-1:1.0 still 2
[    2.825392] Restarting tasks ... done.
[    2.931812] ata1: COMRESET failed (errno=-19)
[    2.931880] ata1: reset failed (errno=-19), retrying in 10 secs
[    3.136543] usb 2-1: USB disconnect, address 3
[    3.249382] usb 2-1: new full speed USB device using ohci_hcd and address 4
[    3.396768] usb 2-1: configuration #1 chosen from 1 choice
[    4.225560] usb 2-1: reset full speed USB device using ohci_hcd and address 4
[    4.372298] usbcore: registered new interface driver speedtch
[    4.456118] speedtch 2-1:1.0: found stage 1 firmware speedtch-1.bin.0.00
[    4.621056] speedtch 2-1:1.0: found stage 2 firmware speedtch-2.bin.0.00
[    9.153941] ATM dev 0: ADSL line is synchronising
[   12.918440] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   12.921971] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[   12.924924] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648

Doesn't the controller generate an interrupt when it detects a harddisk?
Is it really needed to do polling?

Idea: What about implementing a sata_sil specific .check_status function,
instead of using the generic ata_check_status()? That one could check other
registers to find out what's really going on in the case ENODEV is returned
by ata_check_status(), or something like that.

Greetings,

Indan


