Return-Path: <linux-kernel-owner+w=401wt.eu-S937154AbZDCV5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937154AbZDCV5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbZDCV5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:57:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44346 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbZDCV5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:57:35 -0400
Message-ID: <49D68631.4030706@garzik.org>
Date: Fri, 03 Apr 2009 17:57:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Mark Lord <lkml@rtr.ca>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel>
In-Reply-To: <20090403212847.GC25887@aniel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janne Grunau wrote:
> On Fri, Apr 03, 2009 at 03:57:52PM -0400, Jeff Garzik wrote:
>> Mark Lord wrote:
>>> Grab that file and try it out.  Instructions are included within.
>>> Report back again and let us know if it makes any difference.
>>>
>>> Someday I may try and chase down the exact bug that causes mythbackend
>>> to go fsyncing berserk like that, but for now this workaround is fine.
> 
> that sounds if it indeed syncs every 100ms instead of once per second
> over the whole recording. It's inteneded behaviour for the first 64K.
> 
>> mythtv/libs/libmythtv/ThreadedFileWriter.cpp is a good place to start 
>> (Sync method... uses fdatasync if available, fsync if not).
>>
>> mythtv is definitely a candidate for sync_file_range() style output, IMO.

> yeah, I'm on it.

Just curious, does MythTV need fsync(), or merely to tell the kernel to 
begin asynchronously writing data to storage?

sync_file_range(..., SYNC_FILE_RANGE_WRITE) might be enough, if you do 
not need to actually wait for completion.

This may be the case, if the idea behind MythTV's fsync(2) is simply to 
prevent the kernel from building up a huge amount of dirty pages in the 
pagecache [which, in turn, produces bursty write-out behavior].

	Jeff


