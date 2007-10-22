Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXJVUl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXJVUl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXJVUlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:41:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40294 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXJVUlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:41:14 -0400
Message-ID: <471D0ADC.7000005@garzik.org>
Date: Mon, 22 Oct 2007 16:41:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
CC: Linas Vepstas <linas@austin.ibm.com>,
       Shane Huang <chunhao.huang@hotmail.com>, davem@davemloft.net,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, Brice Goglin <brice@myri.com>
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
References: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl> <20071019195749.GK29903@austin.ibm.com> <471911BE.2000405@garzik.org> <Pine.LNX.4.64.0710221555190.32497@iabervon.org>
In-Reply-To: <Pine.LNX.4.64.0710221555190.32497@iabervon.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
> On Fri, 19 Oct 2007, Jeff Garzik wrote:
> 
>> Linas Vepstas wrote:
>>> On Fri, Oct 19, 2007 at 09:17:23PM +0800, Shane Huang wrote:
>>>> Since we have little experience on PCI and MSI here, we had to try to
>>> As someone else pointed out, AMD should have *lots* of people with
>>> pci and msi experience on the payroll.  (Folks here buy AMD-designed pci
>>> chips ...)
>>>
>>>> ONLY
>>>> comment out the pci_intx() call in drivers/ata/ahci.c
>>>> My system can boot up too with MSI enabled!
>>>>
>>>> So does it mean that the root cause is our SB700 SATA controller
>>>> has a hardware bug where setting INTX_DISABLE in the PCI COMMAND
>>>> register masks MSI interrupts too? 
>>> That's what it sounds like, to me.
>>>
>>>> And what is the software solution or workaround?
>>> Not sure. Sounds like the device driver needs a quirk for this part.
>>
>> Take a look at tg3.c net driver change
>> 2fbe43f6f631dd7ce19fb1499d6164a5bdb34568 which is a similar situation.
>>
>> However, it may turn out that removing the pci_intx() stuff as a general rule
>> is easier than quirking these devices, if enough of them turn out to have this
>> hardware bug.
> 
> At a first approximation, ATI/AMD devices don't send any interrupts if 
> intx is disabled, nVidia devices send legacy interrupts in addition to MSI 
> ones if intx isn't disabled, and Intel devices actually work correctly. So 
> we need at least one kind of device quirk for intx and msi. (And doing it 
> in the drivers doesn't work, since everybody is making things driven by 
> snd_hda_intel and would like msi, afaict)

Note that INTX_DISABLE is a recent addition to PCI.  Older PCI devices 
support neither MSI nor INTX-disable, so make sure such devices don't 
creep into your sample.

In general it is documented that INTX_DISABLE should apply only to INTx# 
so devices that disable MSI based on that bit are out of spec.  But 
unfortunately that is rather irrelevant, since we see these out-of-spec 
devices in the field today.

	Jeff



