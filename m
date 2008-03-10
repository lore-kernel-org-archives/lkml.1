Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYCJXJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYCJXJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCJXIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:08:52 -0400
Received: from kryptiva.com ([69.70.52.242]:18784 "EHLO mail.kryptiva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYCJXIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:08:51 -0400
X-Greylist: delayed 1503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 19:08:51 EDT
Message-ID: <47D5B99E.1010302@kryptiva.com>
Date: Mon, 10 Mar 2008 18:43:42 -0400
From: Karim Yaghmour <karim.yaghmour@kryptiva.com>
Reply-To: karim.yaghmour@kryptiva.com
Organization: Kryptiva Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DMA issues w/ via82cxxx (OQO 02)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- KRYPTIVA PACKAGED MESSAGE -----
PACKAGING TYPE: SIGNED

I've been working on getting a decent Linux install working on the
OQO 02 for a few weeks. I ran into quite a few issues but have been
able to overcome most (like getting the OQO to display nice on a
DVI monitor ...); except for some DMA issues which I'd prefer
getting some advice over before I play around.

Unlike the 01, which was based on the Transmeta chip, the 02 is
based on a VIA C7M ULV (1.5GHz or 1.6Ghz depending on config) and
uses the CX700 as an all-in-one video/sound/IDE chip:
http://www.via.com.tw/en/products/chipsets/c-series/cx700/#blkdiagram
Overall it's a pretty decent device.

Getting a standard distro to work on it was a challenge. Ubuntu 7.10
won't install. For some reason the kernel doesn't like the hardware
too much (it hangs.) 7.04 does install, but it's got DMA issues. So
what I did was install 7.04 and "update" to 7.10 but use the 7.04
kernel until I got a 2.6.24.3 going. There's an unofficial patch
from OQO to solve the DMA issues with Linux which I ported to
2.6.24.3:
http://www.oqo.com/unsupported/linux/cx700-dma.patch
Full unofficial instructions here:
http://www.oqo.com/unsupported/linux/

Without this patch, the kernel continuously gets DMA timeouts. With
the patch, it works fine ... for a while. After a certain amount of
random time, some DMA timeouts will happen. Sometimes they are
relatively isolated. Other times, once they start they won't stop.
I've included samples at the bottom of this email.

Standard diagnostics on the disk show that it's fine, but somehow
the IDE controller is flaky. According to the following posts it
would seem that some hardware is slow to respond and the IDE code
gets "impatient":
http://lkml.org/lkml/2005/5/25/221
http://lkml.org/lkml/2005/5/26/176
Not sure whether the disk's slow RPM (4200) could be a factor in
the case of the OQO 02.

So I'm wondering if somebody could point me in the right direction.
Clearly the patch works for some time (i.e. no DMA timeouts) and
then timeouts start happening, possibly under heavy disk load. Is
there anything I could tweak to help or is this really a case of
unsupported hardware?

Any help would be greatly appreciated. Thanks,

Karim Yaghmour
Founder and CEO
Kryptiva inc.


Sample DMA errors (some reboots in between):
--------------------------------------------
Mar  3 09:27:22 localhost kernel: [ 3286.574721] hdc: dma_timer_expiry: dma status == 0x20
Mar  3 09:27:22 localhost kernel: [ 3286.574755] hdc: DMA timeout retry
Mar  3 09:27:22 localhost kernel: [ 3286.574770] hdc: timeout waiting for DMA
Mar  3 09:27:37 localhost kernel: [ 3292.347888] hdc: status timeout: status=0xd0 { Busy }
Mar  3 09:27:37 localhost kernel: [ 3292.347922] ide: failed opcode was: unknown
Mar  3 09:27:37 localhost kernel: [ 3292.347980] hdc: no DRQ after issuing MULTWRITE
Mar  3 09:27:38 localhost kernel: [ 3292.577621] ide1: reset: success
Mar  3 09:28:12 localhost kernel: [ 3305.208017] hdc: status timeout: status=0xd0 { Busy }
Mar  3 09:28:12 localhost kernel: [ 3305.208050] ide: failed opcode was: unknown
Mar  3 09:28:12 localhost kernel: [ 3305.208108] hdc: no DRQ after issuing MULTWRITE
Mar  3 09:28:13 localhost kernel: [ 3305.530337] ide1: reset: success
...
Mar  3 13:07:25 localhost kernel: [ 9202.335387] hdc: dma_timer_expiry: dma status == 0x20
Mar  3 13:07:25 localhost kernel: [ 9202.335419] hdc: DMA timeout retry
Mar  3 13:07:25 localhost kernel: [ 9202.335434] hdc: timeout waiting for DMA
Mar  3 13:07:25 localhost kernel: [ 9202.451339] hdc: status timeout: status=0xd0 { Busy }
Mar  3 13:07:25 localhost kernel: [ 9202.451363] ide: failed opcode was: unknown
Mar  3 13:07:25 localhost kernel: [ 9202.451420] hdc: no DRQ after issuing MULTWRITE
Mar  3 13:07:26 localhost kernel: [ 9202.707746] ide1: reset: success
Mar  3 13:07:35 localhost kernel: [ 2301.996646] hdc: status timeout: status=0xd0 { Busy }
Mar  3 13:07:35 localhost kernel: [ 2301.996658] ide: failed opcode was: unknown
Mar  3 13:07:35 localhost kernel: [ 2301.997984] hdc: no DRQ after issuing MULTWRITE
Mar  3 13:07:35 localhost kernel: [ 2302.044409] ide1: reset: success
Mar  3 13:07:36 localhost kernel: [ 2302.164272] hdc: status timeout: status=0xd0 { Busy }
Mar  3 13:07:36 localhost kernel: [ 2302.164282] ide: failed opcode was: unknown
Mar  3 13:07:36 localhost kernel: [ 2302.164317] hdc: no DRQ after issuing MULTWRITE
Mar  3 13:07:36 localhost kernel: [ 2302.691800] ide1: reset: success
...
Mar  4 01:27:41 localhost kernel: [18212.360790] hdc: dma_timer_expiry: dma status == 0x20
Mar  4 01:27:41 localhost kernel: [18212.360824] hdc: DMA timeout retry
Mar  4 01:27:41 localhost kernel: [18212.360840] hdc: timeout waiting for DMA
Mar  4 01:28:51 localhost kernel: [18300.035293] hdc: dma_timer_expiry: dma status == 0x20
Mar  4 01:28:51 localhost kernel: [18300.035327] hdc: DMA timeout retry
Mar  4 01:28:51 localhost kernel: [18300.035343] hdc: timeout waiting for DMA
Mar  4 01:50:07 localhost kernel: [20852.223010] hdc: dma_timer_expiry: dma status == 0x20
Mar  4 01:50:07 localhost kernel: [20852.223045] hdc: DMA timeout retry
Mar  4 01:50:07 localhost kernel: [20852.223061] hdc: timeout waiting for DMA
...
Mar  4 14:29:30 localhost kernel: [  379.409774] hdc: dma_timer_expiry: dma status == 0x20
Mar  4 14:29:30 localhost kernel: [  379.409788] hdc: DMA timeout retry
Mar  4 14:29:30 localhost kernel: [  379.409792] hdc: timeout waiting for DMA
Mar  4 14:29:30 localhost kernel: [  379.410047] hdc: status error: status=0x51 { DriveReady SeekComplete Error }
Mar  4 14:29:30 localhost kernel: [  379.410056] hdc: status error: error=0x04 { DriveStatusError }
Mar  4 14:29:30 localhost kernel: [  379.410063] ide: failed opcode was: unknown
Mar  4 14:29:30 localhost kernel: [  379.410070] hdc: no DRQ after issuing MULTWRITE
Mar  4 14:29:30 localhost kernel: [  379.421243] hdc: status error: status=0x51 { DriveReady SeekComplete Error }
Mar  4 14:29:30 localhost kernel: [  379.421251] hdc: status error: error=0x04 { DriveStatusError }
Mar  4 14:29:30 localhost kernel: [  379.421258] ide: failed opcode was: unknown
Mar  4 14:29:30 localhost kernel: [  379.421264] hdc: no DRQ after issuing MULTWRITE
Mar  4 14:29:30 localhost kernel: [  379.432579] hdc: status error: status=0x51 { DriveReady SeekComplete Error }
Mar  4 14:29:30 localhost kernel: [  379.432588] hdc: status error: error=0x04 { DriveStatusError }
Mar  4 14:29:30 localhost kernel: [  379.432594] ide: failed opcode was: unknown
Mar  4 14:29:30 localhost kernel: [  379.432600] hdc: no DRQ after issuing MULTWRITE
Mar  4 14:29:30 localhost kernel: [  379.446502] hdc: status error: status=0x51 { DriveReady SeekComplete Error }
Mar  4 14:29:30 localhost kernel: [  379.446510] hdc: status error: error=0x04 { DriveStatusError }
Mar  4 14:29:30 localhost kernel: [  379.446517] ide: failed opcode was: unknown
Mar  4 14:29:30 localhost kernel: [  379.446546] hdc: no DRQ after issuing MULTWRITE
Mar  4 14:29:30 localhost kernel: [  379.488369] ide1: reset: success
...
Mar  4 20:17:21 localhost kernel: [ 1229.078076] hdc: dma_timer_expiry: dma status == 0x24
Mar  4 20:17:31 localhost kernel: [  310.357908] hdc: DMA interrupt recovery
Mar  4 20:17:31 localhost kernel: [  310.357923] hdc: lost interrupt
Mar  4 20:25:57 localhost kernel: [ 1267.055119] hdc: dma_timer_expiry: dma status == 0x24
Mar  4 20:25:57 localhost kernel: [ 1279.998907] hdc: DMA interrupt recovery
Mar  4 20:25:57 localhost kernel: [ 1279.998939] hdc: lost interrupt
Mar  4 20:25:57 localhost kernel: [ 1311.894213] hdc: dma_timer_expiry: dma status == 0x24
Mar  4 20:25:57 localhost kernel: [  331.229499] hdc: DMA interrupt recovery
Mar  4 20:25:57 localhost kernel: [  331.229514] hdc: lost interrupt
Mar  4 20:25:57 localhost kernel: [ 1351.822576] hdc: dma_timer_expiry: dma status == 0x24
Mar  4 20:25:57 localhost kernel: [ 1366.689010] hdc: DMA interrupt recovery
Mar  4 20:25:57 localhost kernel: [ 1366.689039] hdc: lost interrupt
Mar  4 20:25:57 localhost kernel: [ 1391.865651] hdc: dma_timer_expiry: dma status == 0x24
Mar  4 20:25:57 localhost kernel: [ 1404.198657] hdc: DMA interrupt recovery
Mar  4 20:25:57 localhost kernel: [ 1404.198689] hdc: lost interrupt
Mar  4 20:25:57 localhost kernel: [ 1428.973425] hdc: dma_timer_expiry: dma status == 0x24
Mar  4 20:25:57 localhost kernel: [ 1440.720827] hdc: DMA interrupt recovery
Mar  4 20:25:57 localhost kernel: [ 1440.720860] hdc: lost interrupt
...
Mar  5 00:22:30 localhost kernel: [ 3661.626173] hdc: dma_timer_expiry: dma status == 0x24
Mar  5 00:28:44 localhost kernel: [ 3883.197988] hdc: dma_timer_expiry: dma status == 0x20
Mar  5 00:28:44 localhost kernel: [ 3883.198000] hdc: DMA timeout retry
Mar  5 00:28:44 localhost kernel: [ 3883.198004] hdc: timeout waiting for DMA

----- KRYPTIVA SIGNED MESSAGE -----
This email claims to have been packaged by Kryptiva.
To process this email and authenticate its origin, get
the free plugin from:
http://www.kryptiva.com/downloads

----- KRYPTIVA SIGNATURE START -----
AvWVqAAAAAIAAAABAAAAAAAATiACAQAAAACgAQAIAAAABAAAAAECABQeQpzoxBhWk1N2pZBP
+oJQqNIFbQMAFNa8GHXZWJH5Dz+D76vfh6JhvWLvBAAURAL2x8oKVxDoCb3M2+az1McuJdkG
ABQufjDxg3ZpKELkwuEedzcbtj6XDgcAFGBYVRYVxGPKznDAvCV9tyFGIeZ/EQAYAAAAAAAA
TiBH1bmdAAbZigAAAAAAADroEwAEAAAAAAAAAIID/1COLIewi7oyiGGYE7/BkNOXeJslZW4i
3nafo47IsSEnR3jndEvqprAlqORStWxxWwA9WVxNFTIAHYl0cBwlqfXyM7nskT3VtvyZSJBj
JgGV82ADwv/DDuqvIA7gZ+2YjQcl48ktzm9AVYjFwZb0lgBgkSGqnwHgO2KWEOE3BmCS
----- KRYPTIVA SIGNATURE END -----
