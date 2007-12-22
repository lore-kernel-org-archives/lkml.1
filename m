Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbXLVAZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbXLVAZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 19:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXLVAZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 19:25:34 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:49090 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXLVAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 19:25:33 -0500
Date: Sat, 22 Dec 2007 01:25:16 +0100
From: Harald Welte <laforge@gnumonks.org>
To: linux-kernel@vger.kernel.org
Cc: xorg@lists.freedesktop.org
Subject: linux-2.6.24-rcX regression / xserver-xorg-video-intel / Q35
Message-ID: <20071222002516.GR6625@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm running an Intel DQ35JO mainboard (Q35 chipset, Q6600 CPU) and I am
observing a regression with linux-2.6.24-rc1 through -rc6 (linux-2.6.git as
of today, ea67db4cdbbf7f4e74150e71da0984e25121f500).

The last working version is 2.6.24-rc1.

The system is running debian unstable (current) using
xserver-xorg-video-intel 2.2.0-1

So what is the actual problem:
It seems to be related to the way how the iommu/gart is used for memory
allocation of the framebuffer memory.

Xorg starts just as it should, but the lower part of the screen is
completely gobbled.  I suppose the lower part of the screen is actually
showing off-screen memory at some completely differnt location.

Interestingly, the mouse cursor is superimposed on top of the garbage
(and it is not distorted).

The visible effect can be observed at the following screenshot:
http://ganesha.gnumonks.org/~laforge/tmp/2624rc_xorg_intel.jpg

lspci:
00:00.0 Host bridge: Intel Corporation Unknown device 29b0 (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Unknown device 29b2 (rev 02)
00:02.1 Display controller: Intel Corporation Unknown device 29b3 (rev 02)

00:02.0 VGA compatible controller: Intel Corporation Unknown device 29b2 (rev 02) (prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 4f4a
        Flags: bus master, fast devsel, latency 0, IRQ 11
        Memory at e0380000 (32-bit, non-prefetchable) [size=512K]
        I/O ports at 2430 [size=8]
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Memory at e0200000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
        Capabilities: [d0] Power Management version 2

00:02.1 Display controller: Intel Corporation Unknown device 29b3 (rev 02)
        Subsystem: Intel Corporation Unknown device 4f4a
        Flags: bus master, fast devsel, latency 0
        Memory at e0300000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: [d0] Power Management version 2

Please let me know if I should provide more details.  I'm also happy to
test any patches :)

Cheers,
-- 
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
