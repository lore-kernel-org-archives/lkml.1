Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbYL0MwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbYL0MwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 07:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbYL0MwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 07:52:00 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:26359 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYL0Mv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 07:51:59 -0500
X-RZG-CLASS-ID: mo05
X-RZG-AUTH: :J20NVUqhafZjXmY+Np2czPoDrWHf+vfHoOjaOgf6V+NsqL0SlZ8=
Message-ID: <495624EC.4040907@tragetaschen.dyndns.org>
Date: Sat, 27 Dec 2008 13:51:56 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081204)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Boot hang after io scheduler registration
References: <49556A37.8070202@tragetaschen.dyndns.org> <20081226164827.48527739.akpm@linux-foundation.org>
In-Reply-To: <20081226164827.48527739.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 27 Dec 2008 00:35:19 +0100 Kai Ruhnau <kai@tragetaschen.dyndns.org> wrote:
>
>   
>> Hi,
>>
>> I have a somewhat weird hang problem when booting all recent kernel
>> versions including 2.6.28: When I boot my system and let grub start the
>> kernel after a 5 second timeout, the system will hang after registering
>> the io schedulers (see below). However, when I choose the default grub
>> entry manually by pressing ENTER in the menu, the kernel does not hang
>> and continues the normal booting process.
>>
>> Below, you can find the place of the hang and an excerpt of the messages
>> that follow on a normal boot as well as some system information.
>>
>> Thanks for your time on this problem.
>>
>> Best regards
>> Kai
>>
>>     
[old dmesg]
> Please add `initcall_debug' to the kernel boot command line.  That
> should tell us which initialisation function is getting stuck.
>   
Sure:

[    0.916827] initcall deadline_init+0x0/0x14 returned 0 after 93 usecs
[    0.916932] calling  cfq_init+0x0/0x9d @ 1
[    0.917055] io scheduler cfq registered (default)
[    0.917154] initcall cfq_init+0x0/0x9d returned 0 after 114 usecs
[    0.917266] calling  percpu_counter_startup+0x0/0x14 @ 1
[    0.917369] initcall percpu_counter_startup+0x0/0x14 returned 0 after
1 usecs
[    0.917480] calling  pci_init+0x0/0x30 @ 1

Hang happens here.

Continuation when pressing ENTER in grub:

[    1.022100] pci 0000:01:00.0: Boot video device
[    1.025022] initcall pci_init+0x0/0x30 returned 0 after 104926 usecs
[    1.025128] calling  pci_proc_init+0x0/0x60 @ 1
[    1.025279] initcall pci_proc_init+0x0/0x60 returned 0 after 49 usecs
[    1.025385] calling  pcie_portdrv_init+0x0/0x42 @ 1
[    1.025553] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    1.025582] pcieport-driver 0000:00:02.0: found MSI capability
[    1.025707] pcieport-driver 0000:00:02.0: irq 319 for MSI/MSI-X
[    1.025716] pci_express 0000:00:02.0:pcie00: allocate port service
[    1.025765] pci_express 0000:00:02.0:pcie03: allocate port service
[    1.025845] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    1.025872] pcieport-driver 0000:00:06.0: found MSI capability
[    1.025992] pcieport-driver 0000:00:06.0: irq 318 for MSI/MSI-X
[    1.026003] pci_express 0000:00:06.0:pcie00: allocate port service
[    1.026050] pci_express 0000:00:06.0:pcie03: allocate port service


Best regards
Kai

-- 
This signature is left as an exercise for the reader.

