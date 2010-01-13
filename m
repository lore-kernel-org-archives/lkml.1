Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121Ab0AMB7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0AMB7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191Ab0AMB7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:59:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:42749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0AMB73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:59:29 -0500
Message-ID: <4B4D28AF.1060506@kernel.org>
Date: Tue, 12 Jan 2010 17:58:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/14] pci: introduce pci_assign_unassigned_bridge_resources
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org> <1261522954-12591-10-git-send-email-yinghai@kernel.org> <4B4D18D9.1030609@jp.fujitsu.com>
In-Reply-To: <4B4D18D9.1030609@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 04:50 PM, Kenji Kaneshige wrote:
> Yinghai Lu wrote:
>> for pciehp to use it later
>>
>> pci_setup_bridge() will not check enabled for the slot bridge, otherwise
>> update res is not updated to bridge BAR. that is bridge is enabled already for
>> port service.
>>
>> -v2: update it with resource_list_x
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
...

>> +
>> +void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>> +{
>> +	struct pci_bus *bus;
>> +	struct pci_bus *parent = bridge->subordinate;
>> +	int retval;
>> +
>> +	pci_bus_size_bridges(parent);
>> +	pci_clear_master(bridge);
> 
> I have a concern about clearing bus master enable bit here, though
> I'm not sure about it. I'm wondering if clearing bus master enable
> bit might have some bad effect for the port services to work. For
> example, does MSI interrupt work without enabling bus mastering?
but we set that pci_set_master right away after we assign the new resource
> 
> 
>> +	__pci_bridge_assign_resources(bridge, NULL);
>> +	retval = pci_reenable_device(bridge);
>> +	pci_set_master(bridge);
>> +	pci_enable_bridges(parent);

YH
