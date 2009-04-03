Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZDCCzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZDCCzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZDCCzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:55:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60643 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZDCCzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:55:03 -0400
Message-ID: <49D57A82.1030006@garzik.org>
Date: Thu, 02 Apr 2009 22:54:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu>	 <20090401210337.GB3797@csclub.uwaterloo.ca>	 <20090402110532.GA5132@aniel>	 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>	 <20090402094247.9d7ac19f.akpm@linux-foundation.org>	 <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain>	 <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>	 <49D53787.9060503@garzik.org>	 <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>	 <49D56DF6.5020300@garzik.org> <9b1675090904021938q6600bb94m2f9fa1b23316162a@mail.gmail.com>
In-Reply-To: <9b1675090904021938q6600bb94m2f9fa1b23316162a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trenton D. Adams wrote:
> On Thu, Apr 2, 2009 at 8:01 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> Linus Torvalds wrote:
>> The most interesting thing I found:  the SSD does 80 MB/s for the first ~1
>> GB or so, then slows down dramatically.  After ~2GB, it is down to 32 MB/s.
>>  After ~4GB, it reaches a steady speed around 23 MB/s.
> 
> Isn't that the kernel IO queue, and the dd averaging of transfer
> speed?  For example, once you hit the dirty ratio limit, that is when
> it starts writing to disk.  So, the first bit you'll see really fast
> speeds, as it goes to memory, but it averages out over time to a
> slower speed.  As an example...

overwrite.c is a special program that does this, in a loop:

	write(buffer-N) data to pagecache
	start buffer-N write-out to storage
	wait for buffer-(N-1) write-out to complete

It uses the sync_file_range() system call, which is like fsync() on 
steroids, wearing cool sunglasses.

Regards,

	Jeff




