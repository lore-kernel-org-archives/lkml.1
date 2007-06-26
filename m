Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbXFZIbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbXFZIbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXFZIb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:31:26 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:43930 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbXFZIbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:31:25 -0400
X-Greylist: delayed 1876 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 04:31:24 EDT
Date: Tue, 26 Jun 2007 09:58:17 +0200 (CEST)
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: linux-kernel@vger.kernel.org
cc: erich@areca.com.tw, ciprich@linuxbox.cz
Subject: arcmsr + dmcrypt problem
Message-ID: <Pine.LNX.4.64.0706260931480.14913@databox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Antivirus: on proxybox by NOD32 antivirus, virus signature database version 2353 (20070625)
X-Antivirus: on linuxbox by Kaspersky antivirus, engine 5.0.5, data 331712 records(26-06-2007)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,
I've stumbled upon a problem with arcmsr driver: trying to use a dmcrypt 
encrypted volume on top of areca volume always hangs the card.

Steps to reproduce:

1) create some kind of raid on areca (raid5, or even a passthrough disc)
2) cryptsetup luksFormat /dev/sda1 (or whatever areca sdX device is)
3) cryptsetup luksOpen /dev/sda1 cryptotest
4) mkfs.xfs /dev/mapper/cryptotest
5) mount /dev/mapper/cryptotest /mnt/cryptotest
6) copy some data to /mnt/cryptotest

this hangs card and printk's following messages:
[  288.160614] arcmsr0: isr get an illegal ccb command done acb='0xffff810144758548'ccb='0xffff810020020000' ccbacb='0x50a05ed7588a40c0' startdone = 0xbcda ccboutstandingcount=1 --

I have tested it on:
1) SMP amd64 machine running 2.6.18 x86_64 kernel with external arcmsr 
module or 2.6.21.3 - it it always hangs on step 4
2) SMP xeon machine running 2.6.21 and also 2.6.22-rc6, UP or SMP, with 
acpi on or off, also tried disabling NCQ - always hangs on step 6

Card information:
Firmware Version   : V1.43 2007-4-17
BOOT ROM Version   : V1.43 2007-4-17
Controller Name    : ARC-1220

Apparently I'm not the first person to encounter this problem:
http://forums.storagereview.net/index.php?showtopic=25513

Should somebody be willing to hunt down this bug, I'd be more than happy 
to assist.

best regards

nik.

