Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYG1JA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYG1JA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYG1JAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:00:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46072 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYG1JAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:00:19 -0400
Message-ID: <488D8A2E.5080509@jp.fujitsu.com>
Date: Mon, 28 Jul 2008 17:58:22 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <20080725012916.06679a6d@mjolnir.drzeus.cx> <48895BA1.1030606@jp.fujitsu.com> <200807251518.53462.jbarnes@virtuousgeek.org> <20080726011600.GA19079@parisc-linux.org>
In-Reply-To: <20080726011600.GA19079@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Jul 25, 2008 at 03:18:53PM -0700, Jesse Barnes wrote:
>> I think that's fine (automatically creating duplicate devices with names to 
>> differentiate them), but I think we should also try harder to avoid adding 
>> duplicates.
>>
>> In Pierre's case, and on my T61, there's only one actual hotplug slot 
>> available, but the firmware creates duplicate physical slot numbers and sets 
>> the HP_CAP bit on everything, both of which are obviously wrong (well I 
>> suppose you could pop these chips off the board, but it's not very 
>> practical).  However, afaict that "other" OS uses the _RMV method to 
>> determine whether a given slot is actually hot pluggable.  On my T61 at 
>> least, this seems to be accurate: only one of my EXP* objects has a _RMV 
>> method.
> 
> I think you're getting distracted from the real problem we're trying to
> solve here, the reason for introducing the pci_slot driver in the first
> place: we want to have information on all slots, not just hotplug ones.
> 
> So while this is growing out of the hotplug system, we need to register
> all slots, even ones without _RMV.
> 

I think Jesse's idea is not for breaking pci_slot driver. I think even
with his idea pci_slot driver will detect all slots, but hotplug driver
(e.g. pciehp) will not be registered on some of those slots.

By the way, how is pci_slot driver on your system that has a problem with
pciehp? Does duplicate slot problem happen also with pci_slot driver? 

Thanks,
Kenji Kaneshige

