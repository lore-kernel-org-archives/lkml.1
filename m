Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYG3URV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYG3URV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYG3URJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYG3URI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:17:08 -0400
Date: Wed, 30 Jul 2008 13:13:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0807301310130.3334@nehalem.linux-foundation.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
 <20080730194516.GO20055@kernel.dk> <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> 
> Take this patch as a bugfix.  It's not in any way showing the way
> forward: as soon as you have the time, you can revert it and start
> from the current state.
> 
> Hmm?

I dislike that mentality.

The fact is, it's not a bug-fix, it's just papering over the real problem.

And by papering it over, it then just makes people less likely to bother 
with the real issue.

For example, and I talked about this earlier - what make syou think that 
the FUSE/NFSD behaviour you don't like is at all valid in the first place?

If you depend on data not being truncated because you have it "in flight", 
tjhere's already something wrong there. It's _not_ just that people can 
see zero bytes in the reply - apparently they can see the file shrink 
before they see the read return. That kind of thing just worries me. And 
it might be a general NFS issue, not necessarily a FUSE one.

So I think your whole approach stinks. I don't agree with the "bug-fix". 
It really smells like a "bug-paper-over".

			Linus
