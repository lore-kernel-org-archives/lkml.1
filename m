Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZDCDFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZDCDFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZDCDF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:05:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58223 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZDCDF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:05:28 -0400
Message-ID: <49D57CF2.5020206@garzik.org>
Date: Thu, 02 Apr 2009 23:05:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D53787.9060503@garzik.org> <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain> <49D56DF6.5020300@garzik.org> <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 2 Apr 2009, Jeff Garzik wrote:
>> The most interesting thing I found:  the SSD does 80 MB/s for the first ~1 GB
>> or so, then slows down dramatically.  After ~2GB, it is down to 32 MB/s.
>> After ~4GB, it reaches a steady speed around 23 MB/s.
> 
> Are you sure that isn't an effect of double and triple indirect blocks 
> etc? The metadata updates get more complex for the deeper indirect blocks.

> Or just our page cache lookup? Maybe our radix tree thing hits something 
> stupid. Although it sure shouldn't be _that_ noticeable.

Indirect block overhead increased as the file grew to 23 GB, I'm sure...

I should probably re-test pre-creating the file, _then_ running 
overwrite.c.  That would at least guarantee the filesystem isn't 
allocating new blocks and metadata.

I was really surprised the performance was so high at first, then fell 
off so dramatically, on the SSD here.

Unfortunately I cannot trash these blkdevs, so the raw blkdev numbers 
are not immediately measurable.


>> There is a similar performance fall-off for the Seagate, but much less
>> pronounced:
>> 	After 1GB:	52 MB/s
>> 	After 2GB:	44 MB/s
>> 	After 3GB:	steady state
> 
> That would seem to indicate that it's something else than the disk speed. 
> 
>> There appears to be a small increase in system time with "-f" (use fadvise),
>> but I'm guessing time(1) does not really give a good picture of overall system
>> time used, when you include background VM activity.
> 
> It would also be good to just compare it to something like
> 
> 	time sh -c "dd + sync"

I'll add that to the next run...

	Jeff


