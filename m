Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZC0HqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZC0HqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZC0HqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:46:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39746 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbZC0HqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:46:04 -0400
Date: Fri, 27 Mar 2009 08:46:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: unlisted-recipients: no@kernel.dk, To-header@kernel.dk, on@kernel.dk,
       "input <"@kernel.dk,
       ";
	Linus Torvalds" <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Linus Torvalds <torvalds@linux-foundation.org>
			^-extraneous tokens in mailbox, missing end of mailbox
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Linus Torvalds <torvalds@linux-foundation.org>
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: Linux 2.6.29
Message-ID: <20090327074559.GS27476@kernel.dk>
References: <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CA9346.6040108@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jeff, if you drop my CC on reply, I wont see your messages for ages.

On Wed, Mar 25 2009, Jeff Garzik wrote:
> Jens Axboe wrote:
>> On Wed, Mar 25 2009, Jeff Garzik wrote:
>>> Stating "fsync already does that" borders on false, because that assumes
>>> (a) the user has a fs that supports barriers
>>> (b) the user is actually aware of a 'barriers' mount option and what 
>>> it  means
>>> (c) the user has turned on an option normally defaulted to off.
>>>
>>> Or in other words, it pretty much never happens.
>>
>> That is true, except if you use xfs/ext4. And this discussion is fine,
>> as was the one a few months back that got ext4 to enable barriers by
>> default. If I had submitted patches to do that back in 2001/2 when the
>> barrier stuff was written, I would have been shot for introducing such a
>> slow down. After people found out that it just wasn't something silly,
>> then you have a way to enable it.
>>
>> I'd still wager that most people would rather have a 'good enough
>> fsync' on their desktops than incur the penalty of barriers or write
>> through caching. I know I do.
>
> That's a strawman argument:  The choice is not between "good enough  
> fsync" and full use of barriers / write-through caching, at all.

Then let me rephrase that to "most users don't care about full integrity
fsync()". If it kills their firefox performance, most will wont to turn
it off. Personally I'd never use it on my notebook or desktop box,
simply because I don't care strongly enough. I'd rather fix things up in
the very unlikely event of a crash WITH corruption.

> It is clearly possible to implement an fsync(2) that causes FLUSH CACHE  
> to be issued, without adding full barrier support to a filesystem.  It  
> is likely doable to avoid touching per-filesystem code at all, if we  
> issue the flush from a generic fsync(2) code path in the kernel.

Of course, it would be trivial. Just add a blkdev_issue_flush() to
vfs_fsync().

> Thus, you have a "third way":  fsync(2) gives the guarantee it is  
> supposed to, but you do not take the full performance hit of  
> barriers-all-the-time.
>
> Remember, fsync(2) means that the user _expects_ a performance hit.
>
> And they took the extra step to call fsync(2) because they want a  
> guarantee, not a lie.

s/user/application.

-- 
Jens Axboe

