Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZAVAdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZAVAdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 19:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZAVAda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 19:33:30 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:53980 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbZAVAd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 19:33:29 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=11oighdZPhiawtPR7wEA:9 a=kdXy-w6Nc1e3HNxaIywA:7 a=EWxhZb3U5XxTbdGnQ5sKRPdEHNwA:4
Message-ID: <4977BED4.6010702@shaw.ca>
Date: Wed, 21 Jan 2009 18:33:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.ide,gmane.linux.kernel,gmane.linux.kernel.pci
To: Mark Lord <liml@rtr.ca>
CC: michael@ellerman.id.au, Grant Grundler <grundler@google.com>,
       Daniel Barkalow <barkalow@iabervon.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-pci@vger.kernel.org
Subject: Re: libata, devm_*, and MSI ?
References: <4975F5C1.8090107@rtr.ca>	 <alpine.LNX.1.00.0901201626090.19665@iabervon.org>	 <497698E2.7090807@rtr.ca>	 <da824cf30901202002g52fb73f9v8229fb702dcd033d@mail.gmail.com> <1232511378.11241.64.camel@localhost> <4977399F.7000104@rtr.ca>
In-Reply-To: <4977399F.7000104@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Michael Ellerman wrote:
>> On Tue, 2009-01-20 at 20:02 -0800, Grant Grundler wrote:
> ..
>>> 1) post lspci -v output to verify device (and bridges) is programmed 
>>> correctly.
>>> 2) look for chipset quirks that disable global msi
>>
>> The kernel shouldn't let you enable MSI if that's the case, ie.
>> pci_enable_msi() should fail.
> ..
> 
> Exactly.  So it shouldn't be that, then.
> 
>> It might still be worth looking at the quirks though, in case there's
>> one for a previous revision of your bridge or something.
>>
>>> 3) Make sure MMIO ranges for 0xfee00000 are routed to local APIC
>>>    ie each bridge needs to route that address somehow (negative decode
>>> is common for upstream).
>>> 4) manually trigger the MSI by doing a MMIO write to the correct
>>> 0xfee00000 address with the assigned vector in order to see if your
>>> interrupt handler gets called.
>>
>> And can you plug something directly into the PCIe bus? If so does MSI
>> work on that?
> ..
> 
> Yup.  PCIe cards have no problem with MSI in that box.
> 
> More later..

What kind of PCI-X bridge does that machine have? I know some AMD 
HyperTransport to PCI-X bridges have broken MSI, but those should be 
blacklisted already in the kernel..
