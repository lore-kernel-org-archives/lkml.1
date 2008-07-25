Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYGYLlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYGYLlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYGYLk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:40:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56896 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYGYLk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:40:57 -0400
Date: Fri, 25 Jul 2008 05:40:40 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080725114040.GC6701@parisc-linux.org>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <4889948D.7020408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4889948D.7020408@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 05:53:33PM +0900, Kenji Kaneshige wrote:
> IIRC, pciehp uses bridge's secondary bus number for slot name, and
> PCI express downstream port can have only one hotplug slot. I think
> this is why with_bus prameter makes difference.

Ahh, I overlooked that last night.

> But it doesn't work on the system that has multiple pci segments.

Yes, we still have the problem that pciehp does not include the 'chassis
number' as part of the name.  I no longer have easy access to any
systems with multiple chassis.  Do your systems have devices which
implement the PCI_CAP_ID_SLOTID capcbility?  (as root) lspci -vvv will
report it:

  printf("Slot ID: %d slots, First%c, chassis %02x\n",
         esr & PCI_SID_ESR_NSLOTS,
         FLAG(esr, PCI_SID_ESR_FIC),
         chs);

> In addition, shpchp
> also has with_bus option, but it doesn't work because shpc controller
> can have multiple slots on the bridge's secondary bus. Anyway, as
> you mentioned, using bus number for slot name is obviously not good
> idea, and your idea (e.g. "2-1", "2-2") looks much better.

Thanks!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
