Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbXCWOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbXCWOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbXCWOZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:25:58 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:21239 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbXCWOZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:25:57 -0400
Date: Fri, 23 Mar 2007 08:24:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: MCE on an NForce4 board (again)
In-reply-to: <fa.7WMpSSoKT5HrVvZw161tkP591C8@ifi.uio.no>
To: Jack Malmostoso <malmostoso@email.it>
Cc: linux-kernel@vger.kernel.org
Message-id: <4603E30E.3050203@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.7WMpSSoKT5HrVvZw161tkP591C8@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Malmostoso wrote:
> Hi there list,
> 
> this is a repost from the x86-64.org discuss list. I think it could be
> relevant here too, if not please excuse me and forget this message. I am not
> subscribed to the LKML, but I can follow the thread on usenet, so no need to
> CC. Feel free to do it if you think it's relevant!
> 
> Since a couple of days I have been experiencing weird lockups on my AMD64
> machine running Debian Sid.
> The computer is composed like this:
> 
> Asus A8N-E (NForce4 socket 939)
> Athlon64 X2 3800+
> 2x512MB Corsair TwinX
> 2x250GB Sata Western Digital
> 2xDVD/DVDRW on PATA channels
> 
> None of the components has *ever* been overclocked and the whole is one year
> old.
> 
> I have logged on in single mode and tried to find a way to reproduce the
> crash. It has been enough to do a stupid script like
> 
> while true; do
> tar -xjvf linux-2.6.20.3.tar.bz2 && rm -fr linux-2.6.20.3
> done
> 
> and regularly, after one or two cycles, the system would lockup with this
> error:
> 
> CPU 0: Machine Check Exception:		4 Bank 4: b200000000070f0f
> TSC 185ef6d81ca
> 
> It also gave me the hint to use mcelog, so I rebooted and installed it. The
> decoded error read:
> 
> CPU 0 4 northbridge TSC 185ef6d81ca 
>   Northbridge Watchdog error
>        bit57 = processor context corrupt
>        bit61 = error uncorrected
>   bus error 'generic participation, request timed out
>       generic error mem transaction
>       generic access, level generic'
> STATUS b200000000070f0f MCGSTATUS 4
> 
> I googled and found a thread on the x86-64.org discuss list [1] that blamed
> the RAM for the
> problem. So I have started doing some tests:
> 
> 1) If I use only 512MB of my RAM, alternatively, I don't get the error.
> 2) Memtest+ has been running for 10hrs and no errors have been detected.
> I'll have it running for the day just to be sure.
> 
> Additionally, right before the MCE, I could read another error:
> 
> ata3: CPB flags CMD err, flags=0x11
> 
> Googling this brought up some threads in the LKML about the sata_nv driver
> (the ADMA bit, I think).

It means the controller had an error sending commands to the drive. 
There's a possibility that if the controller is taking a long time 
retrying commands, etc. the CPU might complain about a bus transaction 
timing out. I'd check the SATA cable for that drive, maybe try a 
different one.

> 
> Since I am running a 2.6.20 kernel (a testing version from the Debian kernel
> team) I have tried booting older kernels but looks like anything I have
> tried does not work (but this is not your problem).
> 
> So I have booted a livecd (I had around an Ubuntu with a 2.6.12 kernel) and
> with my great surprise the machine worked without problems.
> 
> Now, do you think it would be even slightly possible that some regression in
> the sata_nv module could trigger an MCE? If not, would you put your money on
> the RAM, or could the motherboard be blamed? I hope it's not the CPU ;)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

