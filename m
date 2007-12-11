Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXLKTUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXLKTUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbXLKTT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:19:57 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:59997 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbXLKTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:19:55 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.165
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+UAR4AHtdZIWergcJhUAmY
Message-ID: <475EE2CA.6020601@reed.com>
Date: Tue, 11 Dec 2007 14:19:38 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<20071211143224.15900995@tux.DEF.witbe.net>	<475E9B9B.2050709@keyaccess.nl>	<475EACB8.7080608@keyaccess.nl>	<20071211163706.2dc82275@tux.DEF.witbe.net>	<475EB263.2050405@keyaccess.nl>	<475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu>
In-Reply-To: <20071211173231.2b87a81f@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Cox wrote:
>
> The vga driver is somewhat misnamed. In console mode we handle everything
> back to MDA/HGA and some HGA adapters do need delays.
>
>   
No they don't.   I really, really, really know this for a fact.  I wrote 
ASM drivers for every early video adapter and ran them all through Lotus 
QA and Software Arts QA.   Personally.  The only delay needed is caused 
by not having dual-ported video frame buffers on the original CGA in 
high res character mode. This caused "snow" when a memory write was done 
concurrently with the read being done by the scanline character 
generator. And that delay was done by waiting for a bit in the I/O port 
space to change.  There was NO reason to do waits between I/O 
instructions.  Produce a spec sheet, or even better a machine.   I may 
have an original PC-XT still lying around in the attic, don't know if I 
can fire it up, but it had such graphics cards.  I also have several 
early high-speed clones that were "overclocked".

>> I do remind all that 0x80 is a BIOS-specific standard, and is per BIOS - 
>> other ports have been used in the history of the IBM PC family by some 
>> vendors, and some machines have used it for DMA port mapping!!  And 
>>     
>
> All do -thats why it is suitable.
>   
Not true.  Again, I can produce machines that don't use 0x80.  Perhaps 
that is because I am many years older than you are, and have been 
writing code for PC compatibles since 1981.  (not a typo - this was 
before the first IBM PC was released to the public).
>   
>> Windows XP does NOT use it at all.  Therefore it may not be supported by 
>>     
>
> Older Windows does. Don't know about XP although DOS apps in XP will but
> they may virtualise the port.
>
>   
Show me one line of Windows code written by Microsoft that uses port 
80.  I don't know what app hackers might have done - there was no 
protection, and someone might have copied the BIOS for some reason.
>> I have a simple patch that fixes my primary concern - just change the 
>> CMOS_READ and CMOS_WRITE, 64-bit versions of I/O and bootcode vga 
>> accesses (first group below) to use the straight inb and outb code.
>>     
>
> Which requires care. Have you verified all the main chipset vendors ?
>
>   
I obviously have not.   Clearly the guys who want this port 80 hack so 
desperately have not either.  That's why we are in this pickle.  (well, 
we only to the extent that I am accepted as having useful input.  I'm 
happy to go if I'm not perceived as being helpful).
>> I may submit it so that the many others who share my pain will be made 
>>     
>
> All .. none of them ?
>   
There is a long standing set of reports of "hwclock" not working on HP 
dv.000v laptops, where the . stands for 2, 4, 6, and 9.   These are all 
nvidia MCP51 chipset AMD64's.

And if you choose to be such an insulting ****, I may just stop trying 
to be helpful.  I presume that others in the community find my comments 
helpful.
> I can do some of these off the top of my head
>
>   
>> drivers/net/8390.h
>>     
>
> Needed for some 8390 devices on ISA bus
>
>   
>> drivers/net/de600.c
>> drivers/net/de600.h
>>     
>
> Uses the parallel port which isnt guaranteed to be full ISA speed.
>
>   
>> drivers/scsi/ppa.h
>>     
>
> Parallel port
>
>   
>> drivers/serial/8250.c
>>     
>
> Some PC's need delays for certain ops.
>
>   
>> drivers/watchdog/wdt_pci.c
>>     
>
> That one is a mistake I believe, I'll dig out the docs.
>
>
>   
