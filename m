Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZCYJj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZCYJj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZCYJjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:39:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50796 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZCYJjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:39:16 -0400
Date: Wed, 25 Mar 2009 10:39:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325093913.GJ27476@kernel.dk>
References: <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C93AB0.6070300@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24 2009, Jeff Garzik wrote:
> Linus Torvalds wrote:
>> But I really don't understand filesystem people who think that "fsck" 
>> is the important part, regardless of whether the data is valid or not. 
>> That's just stupid and _obviously_ bogus.
>
> I think I can understand that point of view, at least:
>
> More customers complain about hours-long fsck times than they do about  
> silent data corruption of non-fsync'd files.
>
>
>> The point is, if you write your metadata earlier (say, every 5 sec) and 
>> the real data later (say, every 30 sec), you're actually MORE LIKELY to 
>> see corrupt files than if you try to write them together.
>>
>> And if you write your data _first_, you're never going to see 
>> corruption at all.
>
> Amen.
>
> And, personal filesystem pet peeve:  please encourage proper FLUSH CACHE  
> use to give users the data guarantees they deserve.  Linux's sync(2) and  
> fsync(2) (and fdatasync, etc.) should poke the block layer to guarantee  
> a media write.

fsync already does that, at least if you have barriers enabled on your
drive.

-- 
Jens Axboe

