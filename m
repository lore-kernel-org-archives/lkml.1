Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXIYA6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXIYA6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXIYA6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:58:40 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:36924 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbXIYA6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:58:39 -0400
Message-ID: <46F85D3F.5010400@lwfinger.net>
Date: Mon, 24 Sep 2007 19:58:39 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: John Pierce <john.j35@gmail.com>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Missing PCIe interface in lspci
References: <aa73b9a0709211952n284fa902oa7fe84174f2b53b7@mail.gmail.com>	 <46F489AF.2020101@lwfinger.net>	 <aa73b9a0709212105u524736e7ja9b860a4f2b1b5ab@mail.gmail.com>	 <46F49A5F.8020300@lwfinger.net>	 <aa73b9a0709212134k5458b799p146c0bd740fe70a4@mail.gmail.com>	 <aa73b9a0709231756y38a364c2jcaf8135663f0de8c@mail.gmail.com>	 <46F713B8.5030806@lwfinger.net> <aa73b9a0709231906s3bd7a2a0h3fbf5a751b531488@mail.gmail.com>
In-Reply-To: <aa73b9a0709231906s3bd7a2a0h3fbf5a751b531488@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the process of advising a user on getting a BCM4311 wireless device to work with bcm43xx rather
than ndiswrapper, the device stopped appearing in an lspci output. The 'lspci -vn' output
for this device before this failure was:

03:00.0 0280: 14e4:4311 (rev 01)
        Subsystem: 103c:1363
        Flags: fast devsel, IRQ 21
        Memory at b8000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
        Capabilities: [d0] Express Legacy Endpoint IRQ 0

Fortunately, the "customer" has two identical machines. Swapping the wireless cards showed that both
BCM4311s work in the other computer, but neither works in the problem machine. Kernel Version
2.6.22.4-65.fc7 is used on both.

Doing a line-by-line comparison of the dmesg outputs, the only thing that stands out is that the line

Allocate Port Service[0000:00:03.0:pcie03]

is missing on the faulty computer. This is the bridge that should connect to the device in question.

The BIOS has been reset and reflashed without helping the problem.

Is there anything other than some failure on the motherboard that would lead to this situation? Is
there anything that we can try? The BIOS in this machine doesn't have many options.


Thanks,

Larry
