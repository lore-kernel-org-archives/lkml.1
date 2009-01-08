Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbZAHTbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbZAHTbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZAHTbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:31:47 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:57985 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZAHTbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:31:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ChvQED+U4jDhDKNrRYWoAtsH7DWwptczgQZqbf/mRkSPaXGMTmHo7rWl+W8yu8AxAQ
         q44SFhtgUMyvGbEzESVR3L4cufU2plxwJjISDmzHK2TNX30r4CBOEInVzq37mGvlZxkT
         B/Rr4DZqsqBe9GF4mL4UOFobbldiS7Sci8KA4=
Message-ID: <49665493.4070808@gmail.com>
Date: Thu, 08 Jan 2009 14:31:31 -0500
From: Connor Behan <connor.behan@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b1pre) Gecko/20080904135032 Shredder/3.0b1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Can't allocate resources for PCI video card behind bridge
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I am trying to use two video cards. One is the built in ATI Rage 
Mobility M3 AGP card which drives the screen of my laptop (Thinkpad a22m 
2628-S1U if that matters), the other is the ATI Radeon X1550 PCI card in 
the Thinkpad Dock II which is supposed to drive an external monitor. 
X1550 is a PCI-E chipset but my card is a PCI card with an onboard PCI 
to PCI-E bridge. I first tried this with kernel 2.6.27 as packaged by 
Archlinux and got the following startup errors:

pci 0000:00:04.0: BAR 7: can't allocate resource
pci 0000:00:04.0: BAR 8: can't allocate resource
pci 0000:00:04.0: BAR 9: can't allocate resource

I've seen this problem discussed in the archives and couldn't find what 
looked like a fix. I WAS able to fix this by loading dock, pci_slot, 
pci_hotplug and acpiphp and appending pci=assign-busses. However since 
then I have run a package update to kernel 2.6.27.10 and I am once again 
getting the same problem even with the same modules and parameters. I 
have since tried appending irqpoll, pci=bios, pci=routeirq and acpi=off 
with no success. I have even rolled back my kernel to 2.6.27 (and the 
headers and a few other packages) setup my system the way it was setup 
before to the best of my knowledge but I still can't get the PCI card 
working again. Another subtle change must be responsible.

Certain PCI devices in the dock are working such as the Cardbus slots... 
but I could care less about them... is there a way I could tell the 
kernel to prioritize the video card and sacrifice Cardbus slots first if 
it can't allocate enough resources? Also my lspci output shows a large 
gap 01:00.0 to 06:00.0 so some part of my system must have expected 
other devices in that range. When I had the video card working it was 
02:00.0. I have tried changing the four IRQ numbers in the BIOS but this 
is pointless at best and sometimes causes my soundcard to be disabled. 
My dmesg, lspci and (trimmed) kernel config are pasted:

dmesg: http://pastebin.com/f3ae15a58
lspci: http://pastebin.com/f5d7dee6e
.config: http://pastebin.com/fb925760

I'm hoping for a solution that doesn't require recompiling the kernel 
but I definitely would if that's necessary. In any event I'll be much 
more vigilant about system updates if I get this working again. 
Thank-you very much for your time.
