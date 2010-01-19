Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672Ab0ASWK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0ASWK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246Ab0ASWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:10:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:58303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab0ASWKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:10:55 -0500
Message-ID: <4B562DB8.8000801@kernel.org>
Date: Tue, 19 Jan 2010 14:10:00 -0800
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
Subject: Re: [PATCH 05/11] pci: update bridge res to get more big range in
 pci assign unssign
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org> <1263640037-24134-6-git-send-email-yinghai@kernel.org> <20100119214823.GH11010@ldl.fc.hp.com>
In-Reply-To: <20100119214823.GH11010@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 01:48 PM, Alex Chiang wrote:
>> +	/* retore size and flags */
> 
> "restore"
> 
>> +	for (list = head.next; list;) {
>> +		struct resource *res = list->res;
>> +
>> +		res->start = list->start;
>> +		res->end = list->end;
>> +		res->flags = list->flags;
>> +		if (list->dev->subordinate)
>> +			res->flags = 0;
>> +
>> +		list = list->next;
>> +	}
>> +	free_failed_list(&head);
>> +
>> +	goto again;
>> +
>> +enable_and_dump:
>> +	/* Depth last, update the hardware. */
>> +	list_for_each_entry(bus, &pci_root_buses, node) {
>>  		pci_enable_bridges(bus);
>>  	}
> 
> Strictly speaking, you don't need these curly braces.

ok
