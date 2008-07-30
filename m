Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbYG3Raa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbYG3Raa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYG3RaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:30:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41519 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYG3RaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:30:08 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org>
	(message from Linus Torvalds on Wed, 30 Jul 2008 10:00:28 -0700 (PDT))
Subject: Re: [patch v3] splice: fix race with page invalidation
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org>
Message-Id: <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 19:29:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Linus Torvalds wrote:
> On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> > 
> > There are no real disadvantages: splice() from a file was
> > originally meant to be asynchronous, but in reality it only did
> > that for non-readahead pages, which happen rarely.
> 
> I still don't like this. I still don't see the point, and I still
> think there is something fundamentally wrong elsewhere.

We discussed the possible solutions with Nick, and came to the
conclusion, that short term (i.e. 2.6.27) this is probably the best
solution.

Long term sure, I have no problem with implementing async splice.

In fact, I may even have personal interest in looking at splice,
because people are asking for a zero-copy interface for fuse.

But that is definitely not 2.6.27, so I think you should reconsider
taking this patch, which is obviously correct due to its simplicity,
and won't cause any performance regressions either.

Thanks,
Miklos
