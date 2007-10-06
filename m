Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbXJFSse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbXJFSse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbXJFSs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:48:27 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49381 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888AbXJFSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:48:26 -0400
Date: Sat, 06 Oct 2007 12:48:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: cx88 pci_abort messages
In-reply-to: <fa.m+2QwZVzW3oTWJBsJ4fdAiUZWkM@ifi.uio.no>
To: Scott <linux-kernel@bluecamel.eml.cc>
Cc: linux-kernel@vger.kernel.org
Message-id: <4707D876.8080306@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.9BwFZjxkV7dKD7EmsWMTtKId3Qc@ifi.uio.no>
 <fa.m+2QwZVzW3oTWJBsJ4fdAiUZWkM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott wrote:
> 
> On Oct 4, 2007, at 11:52 AM, Scott wrote:
> 
>> I'm having what I think is a PCI bus problem.
>>
>> I have a ASUS P5B Intel 965 motherboard and a DVICO Fusion HDTV5 RT
>> adapter on the PCI bus. When this adapter is recording (anything) I see
>> pci_abort messages repeating in the /var/log/messages file. As a result
>> I see some minor video corruption during playback. I've installed the
>> adapter into a PCI slot that shares an IRQ with the onboard USB.
>> However, I've also disabled all USB support in BIOS, so the adapter is
>> the only thing on the IRQ, and still see the same errors.
>>
>> Any suggestions for further troubleshooting? Is this a PCI bus quirk on
>> this motherboard? A copy of my .config is at
>> http://donpoo.net/kernel_config
>>
>> Oct  2 21:59:12 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
>> Oct  2 21:59:12 htpc cx88[0]/2-mpeg: general errors: 0x00080000
>> Oct  2 21:59:20 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
>> Oct  2 21:59:20 htpc cx88[0]/2-mpeg: general errors: 0x00080000
>> Oct  2 21:59:32 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
>> Oct  2 21:59:32 htpc cx88[0]/2-mpeg: general errors: 0x0008000
> 
> I was poking around the PCI bus with setpci/lspci last night and tried 
> adjusting the latency from 64 to 32. This didn't make a difference. I 
> also changed my core2duo speedstep governor from ondemand to performance 
> to prevent the CPUs from changing speed. I eventualy saw the same 
> pci_abort message but I might have seen less of them.
> 
> Is there a way to log every device pci device that throws an interrupt? 
> I'm thinking if I could find out which pci device was stealing the 
> interrupt that I could disable it or look at the code and see what it 
> was doing.

PCI aborts won't have anything to do with interrupts. It's a PCI DMA 
transfer that either the initiator (here, the TV card) or the target 
(the chipset host bridge) decided to puke on for some reason. Possibly 
parity errors?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

