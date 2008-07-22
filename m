Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYGVRoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYGVRoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYGVRoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:44:12 -0400
Received: from smtp.extricom.com ([192.114.46.18]:33538 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752830AbYGVRoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:44:11 -0400
Message-ID: <48861BAC.1080009@extricom.com>
Date: Tue, 22 Jul 2008 20:41:00 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: eran liberty <eran.liberty@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org> <4885DD41.9010202@extricom.com> <20080722141327.GB7337@parisc-linux.org> <4885FBF4.6070306@extricom.com> <20080722165241.GD7337@parisc-linux.org>
In-Reply-To: <20080722165241.GD7337@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Jul 22, 2008 at 06:25:40PM +0300, Eran Liberty wrote:
>   
>> If my devices where the only one on the bus I would not have stumbled on 
>> this bug. I would have removed them all before reloading and would have 
>> scanned and empty PCI bus list after the reloading.
>>     
>
> That's not true, the code you posted:
>
> bus = null;
> while ((bus = pci_find_next_bus(bus)) != NULL) {
>         pci_scan_child_bus(bus);
>         pci_bus_assign_resources(bus);
>         pci_bus_add_devices(bus);
> }
>
> will scan all busses again.
>   
You are correct! I have a single bus :)

>   
>> Alas, the CPU itself is a pci device. Upon scanning the bus it is it who 
>> is duplicated. Upon trying to "pci_bus_add_devices()" you get resource 
>> collision.
>>     
>
> Does the CPU have BARs of its own?  If you have no other devices with
> BARs, it would explain why you have not noticed the problem with
> fixup_resource ;-)
>   
I seriously doubt my CPU has any resources of its own.

>   
>> Do you perceive any down side to my suggested patch?
>> It seems (to me) really logical that a device can not and should not be 
>> added twice to a pci bus device list.
>>     
>
> The problem is the other side-effects of what you propose.
>   
Could you elaborate what ominous side-effects you predict?

Liberty
