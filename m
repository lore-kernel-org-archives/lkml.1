Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbZDBWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbZDBWJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbZDBWJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:09:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51459 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758952AbZDBWJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:09:25 -0400
Message-ID: <49D53787.9060503@garzik.org>
Date: Thu, 02 Apr 2009 18:09:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 2 Apr 2009, Linus Torvalds wrote:
>> On Thu, 2 Apr 2009, Andrew Morton wrote:
>>> A suitable design for the streaming might be, every 4MB:
>>>
>>> - run sync_file_range(SYNC_FILE_RANGE_WRITE) to get the 4MB underway
>>>   to the disk
>>>
>>> - run fadvise(POSIX_FADV_DONTNEED) against the previous 4MB to
>>>   discard it from pagecache.
>> Here's an example. I call it "overwrite.c" for obvious reasons.
> 
> Oh, except my example doesn't do the fadvise. Instead, I make sure to 
> throttle the writes and the old range with
> 
> 	SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER
> 
> which makes sure that the old pages are easily dropped by the VM - and 
> they will be, since they end up always being on the cold list.

Dumb VM question, then:  I understand the logic behind the 
write-throttling part (some of my own userland code does something 
similar), but,

Does this imply adding fadvise to your overwrite.c example is (a) not 
noticable, (b) potentially less efficient, (c) potentially more efficient?

Or IOW, does fadvise purely put pages on the cold list as your 
sync_file_range incantation does, or something different?

Thanks,

	Jeff, who is already using sync_file_range in
	some server-esque userland projects


