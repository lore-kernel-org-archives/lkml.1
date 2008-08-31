Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYHaKJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYHaKJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYHaKIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:08:53 -0400
Received: from nat.xms.se ([212.181.93.157]:63827 "EHLO arwen.xms.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756725AbYHaKIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:08:51 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2008 06:08:50 EDT
Message-ID: <48BA6BD6.3050907@xms.se>
Date: Sun, 31 Aug 2008 12:00:54 +0200
From: "Jonas Petersson" <jonas.petersson@xms.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-ide@vger.kernel.org, smartmontools-support@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] exception Emask 0x0 SAct 0x0 SErr 0x0
 action 0x2 frozen
References: <48B91198.3020803@xms.se>	<alpine.DEB.1.10.0808300708330.19513@p34.internal.lan>	<48B9AE15.7010605@xms.se>	<alpine.DEB.1.10.0808301710380.11166@p34.internal.lan>	<48B9C261.4010609@xms.se> <alpine.DEB.1.10.0808301804290.11166@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0808301804290.11166@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Justin,

Justin Piszcz skrev:
> On Sat, 30 Aug 2008, Jonas Petersson wrote:
>> Justin Piszcz skrev:
>>> On Sat, 30 Aug 2008, Jonas Petersson wrote:
>>>> [...]
>>> smartctl -a would be useful (#1)
>> # smartctl -a /dev/sda
>> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
>> Home page is http://smartmontools.sourceforge.net/
> 
> I have the same controller in my host as well, but it does not appear to
> matter whether it happens on the ICH8 controller or other controllers.
> 
> I have noticed on Velociraptors I seem to get the same/similar error that
> you do as well, and I ran all the same tests as you, to no avail as to getting
> any closer to finding the root cause/problem.
> (.. more so than the regular old raptor150s)
> 
> Besides the annoying messages in the kernel log/syslog/dmesg, does it
> affect your system stability in any way as of yet?

Very much so, yes.

At best, all disk access will hang for a while and then resume after the 
reset has worked out - this often happens a couple of times per day now.

At worst, the reset will not work and the disk is remounted read-only 
and I can sort of use the system a bit this way. It seems somewhat 
random how much still works: Up until today I could at least always use 
dmesg and tail various logs to try to hunt down what happened, but this 
morning dmesg could not be found and I got I/O errors when accessing 
anything in /var/log. Rebooting helped as usual.

This fatal variant has happened about every second day lately.

The first two weeks I had the system showed nothing at all like this: I 
have log files since July 26 and the first recorded (reset-able) glitch 
is from Aug 16. Obviously, any non-resetable problem would have been 
easy to spot.

> I must add a very important note here though, you are using an ICH8 chipset
> and so am I, we both have same/similar problems-- however, I also have
> another machine setup VERY similarly (except different HDDs) for the RAID5
> but the RAID1 is the same as one of my ICH8 boxes (dual raptor150s)--
> and to date it has never? or rarely thrown the frozen error except when a disk 
> actually failed (or when NCQ is enabled for a WD drive), (NCQ+Linux for WD) is
> broken.

Yes, I would not point fingers to the ICH8 chipset either: The other 
MacBookPro I have experimented with now is a 2,2 (ATI based) and has 
ICH7, but I'm 99.9% sure my previous MacBookPro 3,1 (nvidia based) was 
ICH8 and it worked flawlessly (I saw no reason to swap for the 4,1 
version, but it was stolen from me in June). As far as I know the 
significant differences with my current MBP are just: higher screen 
resolution, multitouch ("iphone") touchpad and more memory. Alas, I 
didn't keep a lshw dump.

> [...]
> CC'ing linux-ide and linux-kernel with your original error from the start
> of this e-mail thread:
> 
> Here is a snippet from this morning - this time it came back to life:
> 
> [46874.898690] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> frozen
> [46874.898703] ata3.00: cmd c8/00:08:90:3c:59/00:00:00:00:00/ef tag 0
> dma 4096 in
> [46874.898705]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [46874.898709] ata3.00: status: { DRDY }
> [46879.643962] ata3: port is slow to respond, please be patient (Status
> 0xd0)
> [46884.473195] ata3: device not ready (errno=-16), forcing hardreset
> [46884.473202] ata3: soft resetting link
> [46912.740010] ata3.00: qc timeout (cmd 0xec)
> [46912.740020] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [46912.740023] ata3.00: revalidation failed (errno=-5)
> [46912.740028] ata3: failed to recover some devices, retrying in 5 secs
> [46917.458070] ata3: soft resetting link
> [46917.636464] ata3.00: configured for UDMA/100
> [46917.636482] ata3: EH complete
> [46917.699224] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors
> (250059 MB)
> [46917.699257] sd 2:0:0:0: [sda] Write Protect is off
> [46917.699263] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [46917.699300] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA

I'll just clarify that the errno after "revalidation failed" is not 
always -5. When it ends up fatal I've also seen -3 and possibly 
something else too. I would have taken a screen shot this morning if 
only dmesg had worked. :-(


> What is the root cause of this? It still seems to be a mystery to most as far
> as I can tell, but the one thing in common is we are both using ICH8 chipsets,
> which, just may happen to be part of the problem?

For the record: My current theory is that it is some kind of hardware 
problem - either in the disk or on the motherboard so I have persuaded 
my local AppleStore to swap the harddisk on Monday and then they will 
run their full hardware stress test (4+ hours according to him). The 
stress test was apparently suggested from the central repair people (who 
have no idea I run Linux on it - the local techie knows, but has no 
problem with it as long as I keep a small OSX partition) so I guess this 
sort of hints that they are aware of hardware issues.

(Note: I've had the same techie replace a broken motherboard in the past 
when the Linux messages where at least as clear as the OSX ones - in 
that case drives would in the end only show up in the boot menue when 
the system had cooled down for at least 20 minutes. To be on the safe 
side, I've upped the minimum fan speed by 50% to ensure all sensors give 
me happy readings all the time - luckily the 4,1 fans are very silent 
compared to the 2,2)

I hope to have everything back in shape on Wednesday and I'll let you 
know how it fares.

BTW: For a while I displayed the hddtemp sensor all the time along with 
coretemp etc, but I now understand that this is also SMART based so I've 
turned it off in the past weeks experimentation. Again, it seemed to 
work flawlessly for months on my previous (stolen) MBP 3,1.

			Best / Jonas
