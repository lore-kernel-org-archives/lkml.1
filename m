Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYAKPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYAKPlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbYAKPla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:41:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:37042 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760023AbYAKPl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:41:29 -0500
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Message-Id: <FB6DCE73-5D8A-42AC-AE5C-0C1AD095B50B@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <47873333.5020202@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: PCI Failed to allocate mem for PCI ROM
Date: Fri, 11 Jan 2008 09:41:17 -0600
References: <1B75C5A8-E512-40CB-A6F3-351640701D0D@kernel.crashing.org> <47872BC8.2040204@gmail.com> <0119CD93-D9F1-42E0-9F6A-A50B2C63B19D@kernel.crashing.org> <47873333.5020202@gmail.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 11, 2008, at 3:13 AM, Jiri Slaby wrote:

> On 01/11/2008 10:07 AM, Kumar Gala wrote:
>> On Jan 11, 2008, at 2:41 AM, Jiri Slaby wrote:
>>> On 01/11/2008 09:29 AM, Kumar Gala wrote:
>>>> Greg,
>>>> I'm getting the following message from the kernel on an embedded  
>>>> ppc32 system:
>>>> PCI: Failed to allocate mem resource #9:100000@e0000000 for  
>>>> 0000:00:00.0
>>>> The HW setup is a PCIe host controller and an e1000 NIC card.  It  
>>>> appears that pci_bus_assign_resources() is trying to call  
>>>> pci_assign_resource() for the ROM and the resource for the ROM is  
>>>> [100000:1fffff] where the PHB is [c0000000:dfffffff].
>>>> It seems like the resno that pci_assign_resource is getting  
>>>> called with is wrong and thus pci_update_resource() doesn't get  
>>>> called.
>>>> any ideas?
>>>
>>> Kernel version, please.
>> Sorry, its 2.6.24-rc7 + some ppc patches queued for 2.6.25
>
> Could you try this patch?
> http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob_plain;f=pci/pci-remove-default-pci-expansion-rom-memory-allocation.patch
>
> Greg: is this 2.6.25 material, please? We need this for SP2.

I saw that patch, but if you notice that its just x86 specific and I'm  
having the issue on a powerpc 32-bit system.

- k
