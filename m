Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909Ab0AMHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0AMHcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 02:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189Ab0AMHcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 02:32:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39983 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0AMHcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 02:32:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B4D76E1.7040708@jp.fujitsu.com>
Date: Wed, 13 Jan 2010 16:31:45 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/14] pci: introduce pci_assign_unassigned_bridge_resources
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org> <1261522954-12591-10-git-send-email-yinghai@kernel.org> <4B4D18D9.1030609@jp.fujitsu.com> <4B4D28AF.1060506@kernel.org>
In-Reply-To: <4B4D28AF.1060506@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On 01/12/2010 04:50 PM, Kenji Kaneshige wrote:
>> Yinghai Lu wrote:
>>> for pciehp to use it later
>>>
>>> pci_setup_bridge() will not check enabled for the slot bridge, otherwise
>>> update res is not updated to bridge BAR. that is bridge is enabled already for
>>> port service.
>>>
>>> -v2: update it with resource_list_x
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ...
> 
>>> +
>>> +void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>>> +{
>>> +	struct pci_bus *bus;
>>> +	struct pci_bus *parent = bridge->subordinate;
>>> +	int retval;
>>> +
>>> +	pci_bus_size_bridges(parent);
>>> +	pci_clear_master(bridge);
>> I have a concern about clearing bus master enable bit here, though
>> I'm not sure about it. I'm wondering if clearing bus master enable
>> bit might have some bad effect for the port services to work. For
>> example, does MSI interrupt work without enabling bus mastering?
> but we set that pci_set_master right away after we assign the new resource

Yes, I know you set bus master enable bit again.

In my understanding, bus master enable bit of the bridge is
cleared temporary while its port service driver is working.
I'm worrying about this temporary operation. For example,
I'm worrying about whether the MSI interrupt works, if some
port service generates interrupts when bus master enable bit
is cleared temporary.

Thanks,
Kenji Kaneshige


