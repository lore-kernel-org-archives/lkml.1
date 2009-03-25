Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZCYTd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZCYTd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZCYTdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:33:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49395 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbZCYTdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:33:20 -0400
Message-ID: <49CA86BD.6060205@garzik.org>
Date: Wed, 25 Mar 2009 15:32:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk>
In-Reply-To: <20090325093913.GJ27476@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Mar 24 2009, Jeff Garzik wrote:
>> Linus Torvalds wrote:
>>> But I really don't understand filesystem people who think that "fsck" 
>>> is the important part, regardless of whether the data is valid or not. 
>>> That's just stupid and _obviously_ bogus.
>> I think I can understand that point of view, at least:
>>
>> More customers complain about hours-long fsck times than they do about  
>> silent data corruption of non-fsync'd files.
>>
>>
>>> The point is, if you write your metadata earlier (say, every 5 sec) and 
>>> the real data later (say, every 30 sec), you're actually MORE LIKELY to 
>>> see corrupt files than if you try to write them together.
>>>
>>> And if you write your data _first_, you're never going to see 
>>> corruption at all.
>> Amen.
>>
>> And, personal filesystem pet peeve:  please encourage proper FLUSH CACHE  
>> use to give users the data guarantees they deserve.  Linux's sync(2) and  
>> fsync(2) (and fdatasync, etc.) should poke the block layer to guarantee  
>> a media write.
> 
> fsync already does that, at least if you have barriers enabled on your
> drive.

Erm, no, you don't enable barriers on your drive, they are not a 
hardware feature.  You enable barriers via your filesystem.

Stating "fsync already does that" borders on false, because that assumes
(a) the user has a fs that supports barriers
(b) the user is actually aware of a 'barriers' mount option and what it 
means
(c) the user has turned on an option normally defaulted to off.

Or in other words, it pretty much never happens.

Furthermore, a blatantly obvious place to flush data to media -- 
fsync(2), fdatasync(2) and sync_file_range(2) -- should cause the block 
layer to issue a FLUSH CACHE for __any__ filesystem.  But that doesn't 
happen either.

So, no, for 95% of Linux users, fsync does _not_ already do that.  If 
you are lucky enough to use XFS or ext4, you're covered.  That's it.

	Jeff



