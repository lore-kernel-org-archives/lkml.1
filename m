Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbYFTPYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbYFTPYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYFTPYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:24:45 -0400
Received: from mail.atmel.fr ([81.80.104.162]:62488 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYFTPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:24:45 -0400
Message-ID: <485BCBB3.20405@atmel.com>
Date: Fri, 20 Jun 2008 17:24:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>, Nicolas Pitre <nico@cam.org>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: sdio: bad CISTPL_FUNCE error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

While trying to setup a GPS SDIO card, I experience the following error: 
"mmc0: bad CISTPL_FUNCE size 28 type 1"

I use a combo card but without mirco sd card inserted.
http://www.spectec.com.tw/sdg810.htm

Tracing in sdio_cis.c file, I print the tpl_code (line 216).
I have 3 successive codes : 0xff, 0x21 & 0x22.

Is this a host controller driver issue ? or the using of a non 
supported combo SDIO card (with GPS function not probed first) ?


Here is a little log :
"
[..SDIO init & many 52 commands..]
mmc0: starting CMD52 arg 00209e00 flags 00000195
Sending command 52 as 00001074, arg = 00209E00, blocks = 0, length = 0 (MR = 00001B84)
MCI irq: status = 0000C3E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c3e5 [000010FF 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 000010ff 00000000 00000000 00000000
mmc0: *read tpl 0xff*
mmc0: clock 25000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
clkdiv = 1. mcck = 24832000
MMC: Setting controller bus width to 1
mmc0: starting CMD52 arg 00000e00 flags 00000195
Sending command 52 as 00001074, arg = 00000E00, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C3E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c3e5 [00001040 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 00001040 00000000 00000000 00000000

[..many 52 commands..]

mmc0: starting CMD52 arg 0020a000 flags 00000195
Sending command 52 as 00001074, arg = 0020A000, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C1E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c1e5 [00001021 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 00001021 00000000 00000000 00000000
mmc0: *read tpl 0x21*
mmc0: starting CMD52 arg 0020a200 flags 00000195
Sending command 52 as 00001074, arg = 0020A200, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C1E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c1e5 [00001002 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 00001002 00000000 00000000 00000000

[2 CMD52]

mmc0: starting CMD52 arg 0020a800 flags 00000195
Sending command 52 as 00001074, arg = 0020A800, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C0E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c0e5 [00001022 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 00001022 00000000 00000000 00000000
mmc0: *read tpl 0x22*
mmc0: starting CMD52 arg 0020aa00 flags 00000195
Sending command 52 as 00001074, arg = 0020AA00, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C1E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c1e5 [0000101C 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 0000101c 00000000 00000000 00000000
mmc0: starting CMD52 arg 0020ac00 flags 00000195

[many CMD52]

mmc0: starting CMD52 arg 0020e200 flags 00000195
Sending command 52 as 00001074, arg = 0020E200, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C0E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c0e5 [00001000 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
mmc0: bad CISTPL_FUNCE size 28 type 1
mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
MMC: Setting controller bus width to 1
mmc0: error -22 whilst initialising SDIO card
mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
MMC: Setting controller bus width to 1
"

-- 
Nicolas Ferre

