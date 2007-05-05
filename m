Return-Path: <linux-kernel-owner+w=401wt.eu-S1423130AbXEEAWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423130AbXEEAWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 20:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423143AbXEEAWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 20:22:32 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:19936 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423130AbXEEAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 20:22:31 -0400
Date: Fri, 04 May 2007 18:22:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <200705041406.59584.jesse.barnes@intel.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <463BCE3B.8090007@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca> <4639229C.4030208@shaw.ca>
 <200705021654.23730.jbarnes@virtuousgeek.org>
 <200705041406.59584.jesse.barnes@intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, May 2, 2007 4:54 pm Jesse Barnes wrote:
>>> What happens if you take out the chipset register detection, does
>>> the MCFG table give you the same result? Wonder if they're doing
>>> something funny with start/end bus values or something in their
>>> table. There's some code in my patch that prints out the important
>>> data from the MCFG table, can you tell me what that shows with the
>>> chipset detection taken out?
>> Yeah, I'll look a little more closely.  It could also be that another
>> register needs tweaking somewhere to actually get the bridge to
>> decode the space.
>>
>>> If that doesn't provide any useful information, I think we may need
>>> some assistance from Intel chipset/motherboard people to figure out
>>> what is going on here..
>> I'm talking with them now, hopefully they'll shed some light on it.
> 
> I did a little more debugging this morning, and found that I can 
> actually do reads from the space described by ACPI and the device 
> register, but later when ACPI actually scans the root bridges, it 
> hangs.  Specifically the call to pci_acpi_scan_root in 
> pci_root.c:acpi_pci_root_add() never seems to return.
> 
> I'll walk through that logic when I get back to my test box, but it's 
> also worth noting that Vista's MCFG on this machine apparently works ok 
> too.

I would try sticking some debug in arch/x86_64/pci/mmconfig.c at the 
beginning and end of pci_mmcfg_read and pci_mmcfg_write to print the 
seg, bus, devfn and reg for each read and write. Hopefully that will 
track down the one that is causing the lockup, if it is an actual 
MMCONFIG access that's doing it..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
