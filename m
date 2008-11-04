Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYKDCbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYKDCbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 21:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYKDCbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 21:31:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37758 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYKDCbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 21:31:14 -0500
Message-ID: <490FB397.8050809@jp.fujitsu.com>
Date: Tue, 04 Nov 2008 11:29:43 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
References: <20081029200903.GA1678@srcf.ucam.org> <490FAC33.9050808@jp.fujitsu.com> <20081104020700.GA11761@srcf.ucam.org>
In-Reply-To: <20081104020700.GA11761@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Nov 04, 2008 at 10:58:11AM +0900, Kenji Kaneshige wrote:
> 
>> - Even with pciehp_passive option, pciehp driver controls hotplug
>>  related registers at the initialization time, enabling software
>>  notification mechanism for hotplug events, trying to turn power
>>  on the slot and so on. Is this your intended behaviour?
> 
> Yes, although the most recent version of the patch doesn't do the 
> forcible power on if no card is detected.
>

Oh, sorry.
I didn't noticed it was already changed in your v2 patch.
 
>> - Maybe I don't understand what "pciehp will listen for events..."
>>  in your patch description means. But if you expect the pciehp's
>>  interrupts for hotplug events, it would not work properly when
>>  hotplug control is not granted through _OSC or OSHP.
> 
> What do you mean by "not work properly"? The hardware we've tested with 
> fires events even without an OSHP method being present. That's the case 
> we're trying to deal with.
>

Because the explanation of PCI Express Native Hot Plug control bit in
_OSC return value in PCI firmware spec says

"... If firmware allows the operating system control of this feature,
then in the context of the _OSC method, it must ensure that all hot
plug events are routed to device interrupts as described in the PCI
Express Base Specification. ..."

My understanding is that it is not ensured that all hot plug events
are routed to device interrupts, if hotplug control is not granted.

Thanks,
Kenji Kaneshige


 
>>> 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if 
>>> 	slot is occupied */
>>> -	if (value && pciehp_force) {
>>> +	if (value && (pciehp_force || pciehp_passive)) {
>>> 		rc = pciehp_enable_slot(t_slot);
>>> 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
>>> 			value = 0;
> 
> This code no longer runs in the pciehp_passive case. However, by the 
> looks of it it still does in the resume case - that probably wants 
> fixing.
> 






