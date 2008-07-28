Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYG1HWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYG1HWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYG1HWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 03:22:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41443 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbYG1HWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 03:22:36 -0400
Message-ID: <488D7369.4060508@jp.fujitsu.com>
Date: Mon, 28 Jul 2008 16:21:13 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <4889948D.7020408@jp.fujitsu.com> <20080725114040.GC6701@parisc-linux.org>
In-Reply-To: <20080725114040.GC6701@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Jul 25, 2008 at 05:53:33PM +0900, Kenji Kaneshige wrote:
>> IIRC, pciehp uses bridge's secondary bus number for slot name, and
>> PCI express downstream port can have only one hotplug slot. I think
>> this is why with_bus prameter makes difference.
> 
> Ahh, I overlooked that last night.
> 
>> But it doesn't work on the system that has multiple pci segments.
> 
> Yes, we still have the problem that pciehp does not include the 'chassis
> number' as part of the name.  I no longer have easy access to any
> systems with multiple chassis.  Do your systems have devices which
> implement the PCI_CAP_ID_SLOTID capcbility?  (as root) lspci -vvv will
> report it:
> 
>   printf("Slot ID: %d slots, First%c, chassis %02x\n",
>          esr & PCI_SID_ESR_NSLOTS,
>          FLAG(esr, PCI_SID_ESR_FIC),
>          chs);
> 

Unfortunately, I don't have any systems that implement the
PCI_CAP_ID_SLOTID capability...

Thanks,
Kenji Kaneshige


