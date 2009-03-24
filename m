Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbZCXT5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbZCXT5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbZCXT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:57:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48972 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbZCXT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:57:27 -0400
Message-ID: <49C93AB0.6070300@garzik.org>
Date: Tue, 24 Mar 2009 15:55:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> But I really don't understand filesystem people who think that "fsck" is 
> the important part, regardless of whether the data is valid or not. That's 
> just stupid and _obviously_ bogus.

I think I can understand that point of view, at least:

More customers complain about hours-long fsck times than they do about 
silent data corruption of non-fsync'd files.


> The point is, if you write your metadata earlier (say, every 5 sec) and 
> the real data later (say, every 30 sec), you're actually MORE LIKELY to 
> see corrupt files than if you try to write them together.
> 
> And if you write your data _first_, you're never going to see corruption 
> at all.

Amen.

And, personal filesystem pet peeve:  please encourage proper FLUSH CACHE 
use to give users the data guarantees they deserve.  Linux's sync(2) and 
fsync(2) (and fdatasync, etc.) should poke the block layer to guarantee 
a media write.

	Jeff


P.S.  Overall, I am thrilled that this ext3/ext4 transition and 
associated slashdotting has spurred debate over filesystem data 
guarantees.  This is the kind of discussion that has needed to happen 
for years, IMO.



