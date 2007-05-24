Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXEXAU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXEXAU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXEXAUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:20:50 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:4834 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbXEXAUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=spt1CaE5nRkktZCqZyYyd4O+p1MpQ68QI3kNrB+KEYD11tFdoAq0H8zLxA3sZiZJAKpe77N2PLNCBT0HvdOikNHHV23hqBNO/zu+GnDryuyzoE0GuIktDiSbiRQ2Gtr3NVjTiDujec+X/QmbDuP5skC8KCNLvOBIloooqvoP8M0=
Message-ID: <4654DA5E.2050003@gmail.com>
Date: Wed, 23 May 2007 17:20:46 -0700
From: Wayne Sherman <wsherman@gmail.com>
Organization: System Design Works
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region,
 resource collisions
References: <46524A6D.5050601@gmail.com> <200705220858.51604.jbarnes@virtuousgeek.org> <46537ADE.1060103@gmail.com> <200705221631.22456.jbarnes@virtuousgeek.org> <20070523132634.A16545@jurassic.park.msu.ru>
In-Reply-To: <20070523132634.A16545@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> No, it won't help. The 1M range (ff500000-ff5fffff) is more than enough.

Good catch, I didn't look close enough at the allocations of the devices 
under the bridge.

> The reason why the D-Link resource is not getting assigned is rather
> interesting: as Wayne wrote
> 
>> Here is the D-LINK NIC:
>> # od -t x4 /sys/devices/pci0000:00/0000:00:14.4/0000:02:02.0/config
>>
>> 0000000 49011186 80b00117 00000011 00004010
> 			    ^^^^^^
> which means that the device class is 0 (not defined).
> And in drivers/pci/setup-bus.c we have
> 
> 		/* Don't touch classless devices or host bridges or ioapics.  */
> 		if (class == PCI_CLASS_NOT_DEFINED ||
> 		    class == PCI_CLASS_BRIDGE_HOST)
> 			continue;
> 
> The short term fix would be to assign proper device class to D-Link NIC
> using pci quirk...

I would like to try this, where do I find "pci quirk"?

Thanks,

Wayne



