Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbZCXT21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbZCXT21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbZCXT2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:28:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbZCXT2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:28:10 -0400
Date: Tue, 24 Mar 2009 12:21:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090324184549.GE32307@mit.edu>
Message-ID: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu>
 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Mar 2009, Theodore Tso wrote:
>
> With ext2 after a system crash you need to run fsck.  With ext4, fsck
> isn't an issue,

Bah. A corrupt filesystem is a corrupt filesystem. Whether you have to 
fsck it or not should be a secondary concern.

I personally find silent corruption to be _worse_ than the non-silent one. 
At least if there's some program that says "oops, your inode so-and-so 
seems to be scrogged" that's better than just silently having bad data in 
it.

Of course, never having bad data _nor_ needing fsck is clearly optimal. 
data=ordered gets pretty close (and data=journal is unacceptable for 
performance reasons).

But I really don't understand filesystem people who think that "fsck" is 
the important part, regardless of whether the data is valid or not. That's 
just stupid and _obviously_ bogus.

			Linus
