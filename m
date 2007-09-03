Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbXICXOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbXICXOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 19:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXICXOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 19:14:17 -0400
Received: from mail98.megamailservers.com ([216.251.36.98]:52127 "EHLO
	mail98.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbXICXOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 19:14:16 -0400
X-Greylist: delayed 3277 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 19:14:16 EDT
X-Authenticated-User: jgeorgas.georgas.ca
Subject: HIMEM calculation
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Mon, 03 Sep 2007 18:19:34 -0400
Message-Id: <1188857974.6090.19.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure I understand how the kernel calculates the amount of
physical RAM it can map during the boot process.

I've quoted two blocks of kernel messages below, one for a kernel with
NOHIGHMEM and another for a kernel with HIGHMEM4G.

If I do the math on the BIOS provided physical RAM map, there is less
than 5MiB of the address space reserved. Since I only have 1GiB of
physical RAM in the board, I figured that it would still be possible to
physically map 1019MiB, even with the 3GiB/1GiB split between user space
and kernel space that occurs with NOHIGHMEM.

However, What actually happens is that I'm 127MiB short of a full GiB.

What am I missing here? Why does that last 127MiB have to go in HIGHMEM?

Message log for a NOHIGHMEM kernel:

Sep  3 16:56:50 Tachyon kernel: Linux version 2.6.22-gentoo-r5 (root@Tachyon) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #2 PREEMPT Mon Sep 3 16:01:08 EDT 2007
Sep  3 16:56:50 Tachyon kernel: BIOS-provided physical RAM map:
Sep  3 16:56:50 Tachyon kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Sep  3 16:56:50 Tachyon kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Sep  3 16:56:50 Tachyon kernel:  BIOS-e820: 0000000000100000 - 000000003ffd3000 (usable)
Sep  3 16:56:50 Tachyon kernel:  BIOS-e820: 000000003ffd3000 - 0000000040000000 (reserved)
Sep  3 16:56:50 Tachyon kernel:  BIOS-e820: 00000000feda0000 - 00000000fee00000 (reserved)
Sep  3 16:56:50 Tachyon kernel:  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
Sep  3 16:56:50 Tachyon kernel: Warning only 896MB will be used.
Sep  3 16:56:50 Tachyon kernel: Use a HIGHMEM enabled kernel.
Sep  3 16:56:50 Tachyon kernel: 896MB LOWMEM available.
Sep  3 16:56:50 Tachyon kernel: Zone PFN ranges:
Sep  3 16:56:50 Tachyon kernel:   DMA             0 ->     4096
Sep  3 16:56:50 Tachyon kernel:   Normal       4096 ->   229376
Sep  3 16:56:50 Tachyon kernel: early_node_map[1] active PFN ranges
Sep  3 16:56:50 Tachyon kernel:     0:        0 ->   229376
Sep  3 16:56:50 Tachyon kernel: DMI 2.3 present.




Message log for a HIGHMEM4G kernel:

Sep  3 17:40:53 Tachyon kernel: BIOS-provided physical RAM map:
Sep  3 17:40:53 Tachyon kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Sep  3 17:40:53 Tachyon kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Sep  3 17:40:53 Tachyon kernel:  BIOS-e820: 0000000000100000 - 000000003ffd3000 (usable)
Sep  3 17:40:53 Tachyon kernel:  BIOS-e820: 000000003ffd3000 - 0000000040000000 (reserved)
Sep  3 17:40:53 Tachyon kernel:  BIOS-e820: 00000000feda0000 - 00000000fee00000 (reserved)
Sep  3 17:40:53 Tachyon kernel:  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
Sep  3 17:40:53 Tachyon kernel: 127MB HIGHMEM available.
Sep  3 17:40:53 Tachyon kernel: 896MB LOWMEM available.
Sep  3 17:40:53 Tachyon kernel: Zone PFN ranges:
Sep  3 17:40:53 Tachyon kernel:   DMA             0 ->     4096
Sep  3 17:40:53 Tachyon kernel:   Normal       4096 ->   229376
Sep  3 17:40:53 Tachyon kernel:   HighMem    229376 ->   262099
Sep  3 17:40:53 Tachyon kernel: early_node_map[1] active PFN ranges
Sep  3 17:40:53 Tachyon kernel:     0:        0 ->   262099
Sep  3 17:40:53 Tachyon kernel: DMI 2.3 present.


