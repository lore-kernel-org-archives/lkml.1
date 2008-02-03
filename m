Return-Path: <linux-kernel-owner+w=401wt.eu-S935706AbYBCDoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935706AbYBCDoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 22:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYBCDnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 22:43:49 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:51251 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYBCDns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 22:43:48 -0500
Date: Sat, 02 Feb 2008 22:43:13 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
In-reply-to: <47A51AD7.3070102@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200802022243.13710.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <745427.71265.qm@web52907.mail.re2.yahoo.com>
 <47A51AD7.3070102@garzik.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Jeff Garzik wrote:
>Chris Rankin wrote:
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata1.00: status: { DRDY }
>> ata1: soft resetting link
>> ata1.00: configured for UDMA/66
>> ata1: EH complete
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata1.00: status: { DRDY }
>> ata1: soft resetting link
>
>Had at least one other report like this...  Sleepiness prevents me from
>recalling more at the moment, but I think the other report was fixed
>with a special ACPI switch...
>
I think that one came from me, but it also gets over 14,000 hits on google.

Now Jeff, here is the strange part.  That error was killing me, many times 
an hour and eventually crashing completely, repeatedly.

I applied that kernel argument acpi_use_timer_override once and have not 
had the error since, and that includes one test of a full let it cool for 
a minute powerdown reboot to see if it would come back, which it did not.

That argument causes the kernel to log this as its responding to that command:

[   27.097095] ENABLING IO-APIC IRQs
[   27.097287] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   27.107291] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   27.107343] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
[   27.107346] ...trying to set up timer as Virtual Wire IRQ... failed.
[   27.117353] ...trying to set up timer as ExtINT IRQ... works.

The last 4 lines above are not logged without that argument.  So my theory ATM
is that this forced the kernel to initialize something in the boards
registers that it does not initialize without that command, and that its
going fubar as shown in the msg quoted above is a totally random thing, perhaps 
dependent on the phase of one of jupiters moons as to what state it powers 
up in.  And I got lucky, so far in that my single powerdown reset didn't 
trigger it again...  And you _know_ what that knocking sound is by now. :)
 
That's my admittedly hardware oriented view of the goings on.  But I also
think it should be a good clue as to what piece of the acpi code
needs walked around in and its tires kicked again, with an eye toward 
making that item a wee bit more intelligently done.  If you can cobble
up something that will extract the data and prove what fails, I'll be 
glad to play guinea pig.  With ccache, a kernel build is < 15 minutes to
actually running it.

My $0.02 in 1934 dollars.  Adjust for inflation since.

>/me puts in pile for Monday...
>
>	Jeff

Thanks Jeff.  I'm glad to see that this isn't scheduled to 'fall through
the cracks' as does happen when folks get busy.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
What!?  Me worry?
		-- Alfred E. Newman
