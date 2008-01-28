Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbYA1TRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbYA1TRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763547AbYA1TPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:15:17 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:61879 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762549AbYA1TPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:15:14 -0500
Date: Mon, 28 Jan 2008 14:13:21 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479E2832.3070006@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281413.21347.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <479E2832.3070006@garzik.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Jeff Garzik wrote:
>Gene Heskett wrote:
>> Greeting;
>>
>> I had to reboot early this morning due to a freezeup, and I had a
>> bunch of these in the messages log:
>> ==============
>> Jan 27 19:42:11 coyote kernel: [42461.915961] ata1.00: exception Emask 0x0
>> SAct 0x0 SErr 0x0 action 0x2 frozen Jan 27 19:42:11 coyote kernel:
>> [42461.915973] ata1.00: cmd ca/00:08:b1:66:46/00:00:00:00:00/e8 tag 0 dma
>> 4096 out Jan 27 19:42:11 coyote kernel: [42461.915974]          res
>> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 27 19:42:11
>> coyote kernel: [42461.915978] ata1.00: status: { DRDY } Jan 27 19:42:11
>> coyote kernel: [42461.916005] ata1: soft resetting link Jan 27 19:42:12
>> coyote kernel: [42462.078216] ata1.00: configured for UDMA/100 Jan 27
>> 19:42:12 coyote kernel: [42462.078232] ata1: EH complete
>> Jan 27 19:42:12 coyote kernel: [42462.090700] sd 0:0:0:0: [sda] 390721968
>> 512-byte hardware sectors (200050 MB) Jan 27 19:42:12 coyote kernel:
>> [42462.114230] sd 0:0:0:0: [sda] Write Protect is off Jan 27 19:42:12
>> coyote kernel: [42462.115079] sd 0:0:0:0: [sda] Write cache: enabled, read
>> cache: enabled, doesn't support DPO or FUA
>> ===============
>> That one showed up about 2 hours ago, so I expect I'll be locked
>> up again before I've managed a 24 hour uptime.  This drive passed
>> a 'smartctl -t long /dev/sda' with flying colors after the reboot
>> this morning.
>>
>> Two instances were logged after I had rebooted to 2.6.24 from 2.6.24-rc8:
>>
>> Jan 24 20:46:33 coyote kernel: [    0.000000] Linux version 2.6.24
>> (root@coyote.coyote.den) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33))
>> #1 SMP Thu Jan 24 20:17:55 EST 2008
>> ----
>> Jan 27 02:28:29 coyote kernel: [193207.445158] ata1.00: exception Emask
>> 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen Jan 27 02:28:29 coyote kernel:
>> [193207.445170] ata1.00: cmd 35/00:08:f9:24:0a/00:00:17:00:00/e0 tag 0 dma
>> 4096 out Jan 27 02:28:29 coyote kernel: [193207.445172]          res
>> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 27 02:28:29
>> coyote kernel: [193207.445175] ata1.00: status: { DRDY } Jan 27 02:28:29
>> coyote kernel: [193207.445202] ata1: soft resetting link Jan 27 02:28:29
>> coyote kernel: [193207.607384] ata1.00: configured for UDMA/100 Jan 27
>> 02:28:29 coyote kernel: [193207.607399] ata1: EH complete
>> Jan 27 02:28:29 coyote kernel: [193207.609681] sd 0:0:0:0: [sda] 390721968
>> 512-byte hardware sectors (200050 MB) Jan 27 02:28:29 coyote kernel:
>> [193207.619277] sd 0:0:0:0: [sda] Write Protect is off Jan 27 02:28:29
>> coyote kernel: [193207.649041] sd 0:0:0:0: [sda] Write cache: enabled,
>> read cache: enabled, doesn't support DPO or FUA
>> Jan 27 02:30:06 coyote kernel: [193304.336929] ata1.00: exception Emask
>> 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen Jan 27 02:30:06 coyote kernel:
>> [193304.336940] ata1.00: cmd ca/00:20:69:22:a6/00:00:00:00:00/e7 tag 0 dma
>> 16384 out Jan 27 02:30:06 coyote kernel: [193304.336942]          res
>> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 27 02:30:06
>> coyote kernel: [193304.336945] ata1.00: status: { DRDY } Jan 27 02:30:06
>> coyote kernel: [193304.336972] ata1: soft resetting link Jan 27 02:30:06
>> coyote kernel: [193304.499210] ata1.00: configured for UDMA/100 Jan 27
>> 02:30:06 coyote kernel: [193304.499226] ata1: EH complete
>> Jan 27 02:30:06 coyote kernel: [193304.499714] sd 0:0:0:0: [sda] 390721968
>> 512-byte hardware sectors (200050 MB) Jan 27 02:30:06 coyote kernel:
>> [193304.499857] sd 0:0:0:0: [sda] Write Protect is off Jan 27 02:30:06
>> coyote kernel: [193304.502315] sd 0:0:0:0: [sda] Write cache: enabled,
>> read cache: enabled, doesn't support DPO or FUA
>>
>> None were logged during the time I was running an -rc7 or -rc8.
>>
>> The previous hits on this resulted in the udma speed being downgraded
>> till it was actually running in pio just before the freeze that
>> required the hardware reset button.
>
>Unfortunately there are 1001 different causes for timeouts, so we need
>to drill down into the hardware, libata version, and ACPI version (most
>notably).
>
>> I'll reboot to -rc8 right now and resume.  If its the drive, I should see
>> it. If not, then 2.6.24 is where I'll point the finger.
Both rc8 and rc7 do it.  The fedora kernels do too, but without the error 
messages being logged, I assume they are an attempt to trace this?

>There was also an ACPI update, which always affects interrupt handling
>(whose symptom can sometimes be a timeout).

I'm thinking Bingo!, please pay the man. See my posts asking about a couple of 
lines very early in the dmesg, asking for an english explanation no one has 
proffered as yet.

>Definitely interesting in test results from what you describe.
>
>	Jeff



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It's no wonder they call it WinNT; WNT = VMS++;

   -- Chris Abbey
%   
Peace, Love and Compile the kernel...

   -- Justin L. Herreman
