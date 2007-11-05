Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbXKEVX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbXKEVX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXKEVXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:23:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52332 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXKEVXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:23:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472F89C0.80602@s5r6.in-berlin.de>
Date: Mon, 05 Nov 2007 22:23:12 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?S=F8ren_Renner?= <soren.renner@gmail.com>
CC: linux1394-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: request_mem_region failed (was: dv camera no longer recognized)
References: <a4280a600710281656s168aa64bge2ee8efaf13ea4c8@mail.gmail.com>
In-Reply-To: <a4280a600710281656s168aa64bge2ee8efaf13ea4c8@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-10-29, Søren Renner wrote to linux1394-user:
> testlibraw provides some output but freezes the box and a reboot is
> necessary.
> 
> dvgrab previously worked with this hardware. After the latest kernel upgrade
> it does not work. Booting to a previous kernel does not help.
> 
> 
> root@siduxbox:/home/sr# dmesg | grep 1394
> ohci1394: MMIO resource (0xfdffc000 - 0xfdffc800) unavailable
> ohci1394: probe of 0000:00:0c.0 failed with error -12
> ieee1394: raw1394: /dev/raw1394 device initialized
> root@siduxbox:/home/sr#
> 
> root@siduxbox:/home/sr# infobash
> CPU[Dual Intel Core2 Duo E4400 @ clocked at 1000.000 Mhz]  Kernel[Linux
> 2.6.23.1-slh64-smp-18 x86_64]  Up[-18min-]  Mem[-370.7/1510.3MB-]
> HDD[-330GB(48%used)-]  Procs[-106-]  Client[Shell]
[...]

The controller itself cannot be initialized anymore.  The message "MMIO
resource... unavailable" is because ohci1394's call to
request_mem_region failed, i.e. when it tried to request the
memory-mapping of controller registers.

I have no idea how this could happen, therefore I Cc lkml.  It's not a
problem with the IEEE 1394 drivers.

Besides the kernel update, did you change anything in the BIOS or even
the hardware?  Do you boot the old kernels with the same boot parameters
as you did before you added the new kernel?
-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
