Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbXKBWc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbXKBWc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXKBWcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:32:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51447 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbXKBWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:32:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472BA567.8040301@s5r6.in-berlin.de>
Date: Fri, 02 Nov 2007 23:32:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to
 boot: kernel BUG at include/linux/scatterlist.h:49!
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
In-Reply-To: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> Both 2.6.24-rc1 and the current git version fail to boot for me:
> 
> [   57.182205] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]
> MMIO=[effff800-efffffff]  Max Packet=
> [2048]  IR/IT contexts=[4/8]
> [   57.194032] eth1394: eth2: IPv4 over IEEE 1394 (fw-host0)
> [   57.199527] ------------[ cut here ]------------
> [   57.204154] kernel BUG at include/linux/scatterlist.h:49!

To which extent do you need IEEE 1394 drivers?

[...]
> from gdb:
> 0xffffffff80463512 is in dma_region_alloc (include/linux/scatterlist.h:49).
> 44               * In order for the low bit stealing approach to work, pages
> 45               * must be aligned at a 32-bit boundary as a minimum.
> 46               */
> 47              BUG_ON((unsigned long) page & 0x03);
> 48      #ifdef CONFIG_DEBUG_SG
> 49              BUG_ON(sg->sg_magic != SG_MAGIC);
> 50      #endif
> 51              sg->page_link = page_link | (unsigned long) page;
> 52      }
> 53

Uh oh...

I'm afraid the ieee1394 core's own scatter-gather list managing code
didn't survive the changes in the kernel's s/g list implementation.

Alas I will be quite busy with non-Linux related stuff during at least
the next two weeks and can't fix this myself for now.
-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
