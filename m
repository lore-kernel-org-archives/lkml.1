Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbXFXPsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbXFXPsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXFXPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:48:16 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23053 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbXFXPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:48:15 -0400
Message-ID: <467E9239.5080702@msgid.tls.msk.ru>
Date: Sun, 24 Jun 2007 19:48:09 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Jeff Garzik <jeff@garzik.org>, Carlo Wood <carlo@alinoe.com>,
       Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org> <467E5C5E.6000706@msgid.tls.msk.ru> <20070624125957.GA28067@gallifrey>
In-Reply-To: <20070624125957.GA28067@gallifrey>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> * Michael Tokarev (mjt@tls.msk.ru) wrote:
> 
> <snip>
> 
>> By the way, I did some testing of various drives, and NCQ/TCQ indeed
>> shows some difference -- with multiple I/O processes (like "server"
>> workload), IF NCQ/TCQ is implemented properly, especially in the
>> drive.
>>
>> For example, this is a good one:
>>
>> Single Seagate 74Gb SCSI drive (10KRPM)
>>
>> BlkSz Trd linRd rndRd linWr  rndWr  linR/W     rndR/W
>> 1024k   1  83.1  36.0  55.8  34.6  28.2/27.6  20.3/19.4
>>         2        45.2        44.1             36.4/ 9.9
>>         4        48.1        47.6             40.7/ 7.1
[]
>> The only thing I don't understand is why with larger I/O block
>> size we see write speed drop with multiple threads.
> 
> My guess is that something is chopping them up into smaller writes.

At least it's not in the kernel.  According to /proc/diskstats,
the requests goes in 1024kb into the drive.

>> And in contrast to the above, here's another test run, now
>> with Seagate SATA ST3250620AS ("desktop" class) 250GB
>> 7200RPM drive:
>>
>> BlkSz Trd linRd rndRd linWr rndWr   linR/W    rndR/W
>> 1024k   1  78.4  34.1  33.5  24.6  19.6/19.5  16.0/12.7
>>         2        33.3        24.6             15.4/13.8
>>         4        34.3        25.0             14.7/15.0
> 
>> And second, so far I haven't seen a case where a drive
>> with NCQ/TCQ enabled works worse than without.  I don't
>> want to say there aren't such drives/controllers, but
>> it just happen that I haven't seen any.)
> 
> Yes you have - the random writes with large blocks and 2 or 4 threads
> is significantly better for your non-NCQ drive; and getting more
> significant as you add more threads - I'm curious what happens
> on 8 threads or more.  

Both drives shown above are with [NT]CQ enabled.  And the first drive
above (74Gb SCSI, where the speed increases with the amount of threads)
is the one which has "better" TCQ implementation.  When I turn off TCQ
for that drive, there's almost no speed increase while increasing number
of threads.

(I can't test this drive now as it's in production.  The results where
gathered before I installed the system on it).

/mjt
