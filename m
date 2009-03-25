Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZCYUxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZCYUxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZCYUww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:52:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbZCYUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:52:51 -0400
Date: Wed, 25 Mar 2009 13:45:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090325185824.GO32307@mit.edu>
Message-ID: <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
References: <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu>
 <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Theodore Tso wrote:
> 
> Now, there are three ways of solving this problem.

You seem to disregard the "write in the right order" approach. Or is that 
your:

> The third potential solution we can try doing is to make some tuning
> adjustments to the VM so that we start pushing out these data blocks
> much more aggressively out to the disk.

Yes. but at least one problem is, as mentioned, that when the VM calls 
writepage[s]() to start async writeback, many filesystems do seem to just 
_block_ on it.

So the VM has a really hard time doing anything sanely early - the 
filesystems seem to take a perverse pleasure in synchronizing things using 
blocking semaphores.

			Linus
