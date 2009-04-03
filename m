Return-Path: <linux-kernel-owner+w=401wt.eu-S935757AbZDCT6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757AbZDCT6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbZDCT61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:58:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43572 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbZDCT6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:58:25 -0400
Message-ID: <49D66A40.5020503@garzik.org>
Date: Fri, 03 Apr 2009 15:57:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca>
In-Reply-To: <49D625A0.1030202@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Lennart Sorensen wrote:
>>
>> Well the system is setup like this:
>>
>> Core 2 Quad Q6600 CPU (2.4GHz quad core).
>> Asus P5K mainboard (Intel P35 chipset)
>> 6GB of ram
>> PVR500 dual NTSC tuner pci card
> ..
>> So the behaviour with cfq is:
>> Disk light seems to be constantly on if there is any disk activity.  
>> iotop
>> can show a total io of maybe 1MB/s and the disk light is on constantly.
> ..
> 
> Lennart,
> 
> I wonder if the problem with your system is really a Myth/driver issue?
> 
> Curiously, I have a HVR-1600 card here, and when recording analog TV with
> it the disk lights are on constantly.  The problem with it turns out to
> be mythbackend doing fsync() calls ten times a second.
> 
> My other tuner cards don't have this problem.
> 
> So perhaps the PVR-500 triggers the same buggy behaviour as the HVR-1600?
> To work around it here, I decided to use a preload library that replaces
> the frequent fsync() calls with a more moderated behaviour:
> 
>   http://rtr.ca/hvr1600/libfsync.tar.gz
> 
> Grab that file and try it out.  Instructions are included within.
> Report back again and let us know if it makes any difference.
> 
> Someday I may try and chase down the exact bug that causes mythbackend
> to go fsyncing berserk like that, but for now this workaround is fine.

mythtv/libs/libmythtv/ThreadedFileWriter.cpp is a good place to start 
(Sync method... uses fdatasync if available, fsync if not).

mythtv is definitely a candidate for sync_file_range() style output, IMO.

	Jeff


