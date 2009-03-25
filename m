Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZCYU0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZCYU0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZCYU01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:26:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33391 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbZCYU00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:26:26 -0400
Message-ID: <49CA9346.6040108@garzik.org>
Date: Wed, 25 Mar 2009 16:25:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk>
In-Reply-To: <20090325194341.GB27476@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Mar 25 2009, Jeff Garzik wrote:
>> Stating "fsync already does that" borders on false, because that assumes
>> (a) the user has a fs that supports barriers
>> (b) the user is actually aware of a 'barriers' mount option and what it  
>> means
>> (c) the user has turned on an option normally defaulted to off.
>>
>> Or in other words, it pretty much never happens.
> 
> That is true, except if you use xfs/ext4. And this discussion is fine,
> as was the one a few months back that got ext4 to enable barriers by
> default. If I had submitted patches to do that back in 2001/2 when the
> barrier stuff was written, I would have been shot for introducing such a
> slow down. After people found out that it just wasn't something silly,
> then you have a way to enable it.
> 
> I'd still wager that most people would rather have a 'good enough
> fsync' on their desktops than incur the penalty of barriers or write
> through caching. I know I do.

That's a strawman argument:  The choice is not between "good enough 
fsync" and full use of barriers / write-through caching, at all.

It is clearly possible to implement an fsync(2) that causes FLUSH CACHE 
to be issued, without adding full barrier support to a filesystem.  It 
is likely doable to avoid touching per-filesystem code at all, if we 
issue the flush from a generic fsync(2) code path in the kernel.

Thus, you have a "third way":  fsync(2) gives the guarantee it is 
supposed to, but you do not take the full performance hit of 
barriers-all-the-time.

Remember, fsync(2) means that the user _expects_ a performance hit.

And they took the extra step to call fsync(2) because they want a 
guarantee, not a lie.

	Jeff



