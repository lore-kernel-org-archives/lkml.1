Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZJZFuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZJZFuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZJZFuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:50:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:43145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZJZFuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:50:23 -0400
Message-ID: <4AE53883.3070709@kernel.org>
Date: Sun, 25 Oct 2009 22:49:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big range
 for pcie devices
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>
In-Reply-To: <4AE52B68.3070501@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
> Yinghai Lu wrote:
>> move out bus_size_bridges and assign resources out of pciehp_add_bridge()
>> and at last do them all together one time including slot bridge, to
>> avoid to call
>> assign resources several times, when there are several bridges under
>> the slot bridge.
>>
>> need to introduce pci_bridge_assign_resources there.
>>
>> handle the case the first bridge that doesn't get pre-allocated big
>> enough res from FW.
>> for example pcie devices need 256M, but the bridge only get
>> preallocated 2M...
>>
> 
> Though I have not looked at the patch deeply yet (sorry), I have
> some questions and concerns about this change. Please correct me
> if my understanding is not correct.
> 
> - Your patch doesn't seems to have the code to free resources.
>  If we need to expand the resource range, don't we need to free
>  preallocated resource before allocating the new one?

that is done with pci_bus_size_bridges ==> pbus_size_io/pbus_size_mem ==> find_free_bus_resource ==> release_resource.

> 
> - Your patch seems to update BARs for bridge itself. I think it
>  would break the bridge's driver (port service driver) that if
>  it controls the device's capability by using IO/Mem, though I
>  don't know if such driver or capabilities exists now.

port service driver will be AER and pciehotplug.
it seems those driver are not use those BAR...
those BAR are supposed for the devices under the pcie bridge.

> 
> And one comment about pci_configure_slot(). We need to program
> hotplug parameters before the device start working. So we need
> to call pci_configure_slot() before calling pci_bus_add_devices().
> 


Thanks, will correct that.

YH


YH
