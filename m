Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYFUWyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYFUWyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYFUWym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:54:42 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:38716 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYFUWyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:54:41 -0400
Message-ID: <485D86BD.5050803@keyaccess.nl>
Date: Sun, 22 Jun 2008 00:54:53 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: regression, 2.6.26-rc7, pnp: quirk_system_pci_resources()
References: <485C6388.1050903@keyaccess.nl> <485D356A.402@keyaccess.nl>
In-Reply-To: <485D356A.402@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-06-08 19:07, Rene Herman wrote:

> On 21-06-08 04:12, Rene Herman wrote:
> 
>> I have been running with pnpacpi=off due to testing ISAPnP/PnPBIOS but 
>> when testing some other ACPI related problem tonight I removed that 
>> and found that unfortunately something seems to have regressed. My 
>> soundcard driver (snd-es1968) won't load anymore on current mainline:
>>
>> ===
>> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 10 (level, 
>> low) -> IRQ 10
>> PCI: Unable to reserve I/O region #1:100@de00 for device 0000:00:0a.0
>> ACPI: PCI interrupt for device 0000:00:0a.0 disabled
>> ES1968 (ESS Maestro): probe of 0000:00:0a.0 failed with error -16
>> ===
>>
>> 00:01 (PNP0c02) is keeping its I/O region occupied:
>>
>> ===
>> # cat /sys/bus/pnp/devices/00\:01/resources
>> state = active
>> io 0xde00-0xde03
>> ===
>>
>> Sound used to work back when I wasn't yet booting with pnpacpi=off but 
>> I don't quite recall when I started doing that nor have I looked yet 
>> at why quirk_system_pci_resources() isn't doing its job. I'll 
>> investigate if you need me to but thought I'd first throw a heap of 
>> information your way and hope you'll have a patch for me when I wake 
>> up :-/
> 
> Well, why the quirk wasn't helping is fairly obvious -- but given that I 
> definitely didn't need anything like this on .25 I wonder why PnPACPI is 
> all of a sudden claiming those 4 ports in the first place.
> 
> As in, this works for me and might not be bogus due to the symmetry and 
> all but still needs some head scratching. In any case, I do definitely 
> need something for .26...
> 
> I'll go recompile .25 onto here and see if's just my BIOS being funny or 
> something to do with the kernel.
> 
> Signed-off-by: Rene Herman <rene.herman@gmail.com>

My BIOS is being funny. I all of a sudden have the same behaviour back 
on .25 and .24. Quite frankly, I haven't a single clue what's going on 
and why my BIOS is grabbing 0xde00-0xde03. The BIOS didn't change, it's 
BIOS SETTINGS didn't change. I did remove the soundcard, booted without 
it and put it back later (same slot) which may have triggered some odd 
BIOS reconfig. Already tried resetting the ESCD which isn't making a 
difference.

You'll have to decide if the patch as posted in parent makes sense. I 
guess it's not a kernel regression as such after all, but I do still 
need something like it to have my soundcard functional.

Rene.
