Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYAKJNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYAKJNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbYAKJN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:13:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:39931 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbYAKJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WPNLV6gk8nleb+FSNfc8ksh8IRPxAdYAnpScx9pVyYgq1EU6PVRtBB874m9c0Ygv6+0TPByugSlQRvG+0JPldAPjMkJoK9ryXGMKdzx0wBMauNcdjD5qdvFn2GwOMJULfSz1CvdvtZYBnKBy7aUhB5j41UUmBWCljeWyoNbCGCM=
Message-ID: <47873333.5020202@gmail.com>
Date: Fri, 11 Jan 2008 10:13:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI Failed to allocate mem for PCI ROM
References: <1B75C5A8-E512-40CB-A6F3-351640701D0D@kernel.crashing.org> <47872BC8.2040204@gmail.com> <0119CD93-D9F1-42E0-9F6A-A50B2C63B19D@kernel.crashing.org>
In-Reply-To: <0119CD93-D9F1-42E0-9F6A-A50B2C63B19D@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 10:07 AM, Kumar Gala wrote:
> 
> On Jan 11, 2008, at 2:41 AM, Jiri Slaby wrote:
> 
>> On 01/11/2008 09:29 AM, Kumar Gala wrote:
>>> Greg,
>>> I'm getting the following message from the kernel on an embedded 
>>> ppc32 system:
>>> PCI: Failed to allocate mem resource #9:100000@e0000000 for 0000:00:00.0
>>> The HW setup is a PCIe host controller and an e1000 NIC card.  It 
>>> appears that pci_bus_assign_resources() is trying to call 
>>> pci_assign_resource() for the ROM and the resource for the ROM is 
>>> [100000:1fffff] where the PHB is [c0000000:dfffffff].
>>> It seems like the resno that pci_assign_resource is getting called 
>>> with is wrong and thus pci_update_resource() doesn't get called.
>>> any ideas?
>>
>> Kernel version, please.
> 
> Sorry, its 2.6.24-rc7 + some ppc patches queued for 2.6.25

Could you try this patch?
http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob_plain;f=pci/pci-remove-default-pci-expansion-rom-memory-allocation.patch

Greg: is this 2.6.25 material, please? We need this for SP2.

thanks,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
