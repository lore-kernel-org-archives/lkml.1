Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYHQMTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYHQMTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYHQMTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:19:16 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36772 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753246AbYHQMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:19:15 -0400
Date: Sun, 17 Aug 2008 08:19:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON sucks
Message-ID: <20080817121906.GE8774@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
	rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <20080816104658.dcdfb0db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816104658.dcdfb0db.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 10:46:58AM -0700, Andrew Morton wrote:
> >       what this code is supposed to do?
> > 
> > 	journal = handle->h_transaction->t_journal;
> > 	if (!journal_set_features(journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE)) {
> > 		J_ASSERT (!"Cannot set revoke feature!");
> > 			 ^^^^
> 
> lol.  It's been there since I merged ext3 in 2.4.15.  Probably it was
> in sct's ext3 patches in the RH kernel.
> 
> Don't change it - it might be important!

Heh!  Well, it does the right thing, and doesn't take any extra text
space assuming a vaguely competent C compiler optimizer.  :-)

I'm pretty sure that back in the 2.4 days, we didn't have BUG_ON.  We
should do a s/J_ASSERT/BUG_ON/g pass over all of fs/jbd and fs/jbd2.
I'll submit patches for application when the 2.6.27 merge window opens
up --- or is this an obvious enough and safe enough transformation
that it will get accepted mainline at this point?

     	     	 	  	      	   - Ted
