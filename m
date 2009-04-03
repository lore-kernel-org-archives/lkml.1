Return-Path: <linux-kernel-owner+w=401wt.eu-S936209AbZDCWcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936209AbZDCWcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763206AbZDCWcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:32:45 -0400
Received: from tichy.grunau.be ([85.131.189.73]:41192 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZDCWcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:32:45 -0400
Date: Sat, 4 Apr 2009 00:32:18 +0200
From: Janne Grunau <j@jannau.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <lkml@rtr.ca>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403223218.GD25887@aniel>
References: <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> <49D68631.4030706@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D68631.4030706@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 05:57:05PM -0400, Jeff Garzik wrote:
> Janne Grunau wrote:
> > On Fri, Apr 03, 2009 at 03:57:52PM -0400, Jeff Garzik wrote:
> >> mythtv/libs/libmythtv/ThreadedFileWriter.cpp is a good place to start 
> >> (Sync method... uses fdatasync if available, fsync if not).
> >>
> >> mythtv is definitely a candidate for sync_file_range() style output, IMO.
> 
> > yeah, I'm on it.
> 
> Just curious, does MythTV need fsync(), or merely to tell the kernel to 
> begin asynchronously writing data to storage?

quoting the TheadedFileWriter comments

/*
 *   NOTE: This doesn't even try flush our queue of data.
 *   This only ensures that data which has already been sent
 *   to the kernel for this file is written to disk. This 
 *   means that if this backend is writing the data over a 
 *   network filesystem like NFS, then the data will be visible
 *   to the NFS server after this is called. It is also useful
 *   in preventing the kernel from buffering up so many writes
 *   that they steal the CPU for a long time when the write
 *   to disk actually occurs.
 */
 
> sync_file_range(..., SYNC_FILE_RANGE_WRITE) might be enough, if you do 
> not need to actually wait for completion.
>
> This may be the case, if the idea behind MythTV's fsync(2) is simply to 
> prevent the kernel from building up a huge amount of dirty pages in the 
> pagecache [which, in turn, produces bursty write-out behavior].

see above, we care only about the write-out. The f{data}*sync calls are
already in a seperate thread doing nothing else.

Janne
