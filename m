Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870Ab0AUTsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0AUTsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566Ab0AUTsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:48:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:34432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0AUTsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:48:52 -0500
Message-ID: <4B58AF41.3010404@kernel.org>
Date: Thu, 21 Jan 2010 11:47:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/9] pci: add pci_bridge_release_unused_res and	pci_bus_release_unused_bridge_res
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-2-git-send-email-yinghai@kernel.org> <20100121181859.GC17684@ldl.fc.hp.com>
In-Reply-To: <20100121181859.GC17684@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 10:18 AM, Alex Chiang wrote:
>   
> Sorry, this is getting into bike-shed territory.
> 
> I'm a lot happier with the code now, so may as well fix up a few
> style issues before it goes in.
> 
>> +static void pci_bridge_release_resources(struct pci_bus *bus,
>> +					  unsigned long type)
>> +{
> 
> [...]
> 
>> +	if (changed) {
>> +		if (type & IORESOURCE_PREFETCH) {
>> +			/* avoiding touch the one without PREF */
>> +			type = IORESOURCE_PREFETCH;
>> +		}
> 
> Strictly speaking, you don't need those curly braces. If you want
> readability, how about moving the comment up?
> 
> 		/* Only setup prefetch resources */
> 		if (type & IORESOURCE_PREFETCH)
> 			type = IORESOURCE_PREFETCH;
> 
> 
>> +		__pci_setup_bridge(bus, type);
>> +	}
>> +}
>> +
>> +static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
>> +						   unsigned long type,
>> +						   enum release_type rel_type)
>> +{
> 
> [...]
> 
>> +
>> +	/* The root bus? */
> 
> Useless comment.
> 
>> +	if (pci_is_root_bus(bus))
>> +		return;
>> +
>> +	if ((bus->self->class >> 8) != PCI_CLASS_BRIDGE_PCI)
>> +		return;
>> +
>> +	if (((rel_type == leaf_only) && is_leaf_bridge) ||
>> +		    (rel_type == whole_subtree))
>> +		pci_bridge_release_resources(bus, type);
>> +}
> 
> Can clean this up a bit too with short-circuit logic.
> 
> 	if ((rel_type == whole_subtree) || is_leaf_bridge)
> 		pci_bridge_release_resources(bus, type);
> 
> If you clean those up, you can add my:
> 
> Reviewed-by: Alex Chiang <achiang@hp.com>

ok thanks.
