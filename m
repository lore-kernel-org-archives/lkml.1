Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbXEWAyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbXEWAyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbXEWAyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:54:16 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:2377 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbXEWAyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:54:15 -0400
Date: Tue, 22 May 2007 18:53:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <200705221738.09571.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <465390A1.1020307@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca>
 <200705211322.18937.jbarnes@virtuousgeek.org> <46538B67.3080007@shaw.ca>
 <200705221738.09571.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tuesday, May 22, 2007, Robert Hancock wrote:
>> Eww. I don't see where we disable the decode at all while we probe the
>> BARs on the device. That seems like a bad thing, especially with the way
>> we probe 64-bit BARs (do the low 32 bits first and then the high 32
>> bits). This means the base address effectively gets set to 0xfffffff0
>> momentarily, which might cause some issues.
> 
> I'm a bit shocked that things work as well as they do without the 
> disabling...
> 
>> I'd try adding some code inside pci_setup_device (drivers/pci/probe.c)
>> to disable PCI_COMMAND_IO and PCI_COMMAND_MEMORY on the device when
>> probing devices with the standard header type and then restoring the
>> previous command bits afterwards, and see what effect that has. It'll be
>>   interesting if it does, since obviously it seems to work as it is with
>> non-MMCONFIG access methods. Maybe the base address being set like that
>> interferes with MMCONFIG access itself somehow?
> 
> I tried that, and it seems to get past probing the graphics device at 
> least, but it hangs a bit later.  It could be that the enable/disable I 
> added wasn't correct though, I didn't check to see which one I should 
> disable in the command word, which may be a problem (just disabled them 
> both every probe).  I'll try again with more precise enable/disable 
> semantics.

It'd be interesting to see at what access it ran into trouble next, at 
least if it's consistent. Could be that some device doesn't like having 
the decode disabled..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
