Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYG3Sd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYG3Sd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYG3SdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:33:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52071 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYG3SdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:33:16 -0400
To: jens.axboe@oracle.com
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <20080730175406.GN20055@kernel.dk> (message from Jens Axboe on
	Wed, 30 Jul 2008 19:54:07 +0200)
Subject: Re: [patch v3] splice: fix race with page invalidation
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk>
Message-Id: <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 20:32:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Jens Axboe wrote:
> On Wed, Jul 30 2008, Miklos Szeredi wrote:
> > On Wed, 30 Jul 2008, Linus Torvalds wrote:
> > > On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> > > > 
> > > > There are no real disadvantages: splice() from a file was
> > > > originally meant to be asynchronous, but in reality it only did
> > > > that for non-readahead pages, which happen rarely.
> > > 
> > > I still don't like this. I still don't see the point, and I still
> > > think there is something fundamentally wrong elsewhere.
> 
> You snipped the part where Linus objected to dismissing the async
> nature, I fully agree with that part.
> 
> > We discussed the possible solutions with Nick, and came to the
> > conclusion, that short term (i.e. 2.6.27) this is probably the best
> > solution.
> 
> Ehm where?

http://lkml.org/lkml/2008/7/7/476

>  Nick also said that he didn't like removing the ->confirm()
> bits as they are completely related to the async nature of splice. You
> already submitted this exact patch earlier and it was nak'ed.

That's not true.  The resubmitted patch didn't remove the ->confirm()
calls, which is what Nick objected to, I think.

> > Long term sure, I have no problem with implementing async splice.
> > 
> > In fact, I may even have personal interest in looking at splice,
> > because people are asking for a zero-copy interface for fuse.
> > 
> > But that is definitely not 2.6.27, so I think you should reconsider
> > taking this patch, which is obviously correct due to its simplicity,
> > and won't cause any performance regressions either.
> 
> Then please just fix the issue, instead of removing the bits that make
> this possible.

I tried to fix it, but Nick didn't like my fix.  Ideas are of course
welcome.

Thanks,
Miklos
