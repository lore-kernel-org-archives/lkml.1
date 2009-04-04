Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZDDXDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZDDXDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 19:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZDDXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 19:03:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60679 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZDDXD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 19:03:26 -0400
Message-ID: <49D7E71B.2080301@garzik.org>
Date: Sat, 04 Apr 2009 19:02:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: David Rees <drees76@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> <49D68631.4030706@garzik.org> <72dbd3150904031553r3c60a3a5k45f16e0e7513d488@mail.gmail.com> <49D69C1D.50209@garzik.org> <20090404162954.GA5170@aniel>
In-Reply-To: <20090404162954.GA5170@aniel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janne Grunau wrote:
> On Fri, Apr 03, 2009 at 07:30:37PM -0400, Jeff Garzik wrote:
>> David Rees wrote:
>>> The *only* reason MythTV fsyncs (or fdatasyncs) the data to disk all
>>> the time is to keep a large amount of dirty pages from building up and
>>> then causing horrible latencies when that data starts getting flushed
>>> to disk.
>> sync_file_range() will definitely help that situation.
> 
> Jeff, could you please try following patch for 0.21 or update to the
> latest trunk revision. I don't have a way to reproduce the high
> latencies with fdatasync on ext3, data=ordered. Doing a parallel
> "dd if=/dev/zero of=file" on the same partition introduces even with
> sync_file_range latencies over 1 second.

Is dd + sync_file_range really a realistic comparison?  dd is streaming 
as fast as the disk can output data, whereas MythTV is streaming as fast 
as video is being recorded.  If you are maxing out your disk throughput, 
there will be obvious impact no matter what.

I would think a more accurate comparison would be recording multiple 
video streams in parallel, comparing fsync/fdatasync/sync_file_range?

IOW, what is an average MythTV setup -- what processes are actively 
reading/writing storage?  Where are you noticing latencies, and does 
sync_file_range decrease those areas of high latency?

	Jeff



