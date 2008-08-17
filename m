Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYHQQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYHQQeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYHQQeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 12:34:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbYHQQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 12:34:07 -0400
Date: Sun, 17 Aug 2008 09:33:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON sucks
Message-Id: <20080817093309.a5d68eb0.akpm@linux-foundation.org>
In-Reply-To: <20080817121906.GE8774@mit.edu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru>
	<20080816104658.dcdfb0db.akpm@linux-foundation.org>
	<20080817121906.GE8774@mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 08:19:06 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Sat, Aug 16, 2008 at 10:46:58AM -0700, Andrew Morton wrote:
> > >       what this code is supposed to do?
> > > 
> > > 	journal = handle->h_transaction->t_journal;
> > > 	if (!journal_set_features(journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE)) {
> > > 		J_ASSERT (!"Cannot set revoke feature!");
> > > 			 ^^^^
> > 
> > lol.  It's been there since I merged ext3 in 2.4.15.  Probably it was
> > in sct's ext3 patches in the RH kernel.
> > 
> > Don't change it - it might be important!
> 
> Heh!  Well, it does the right thing, and doesn't take any extra text
> space assuming a vaguely competent C compiler optimizer.  :-)
> 
> I'm pretty sure that back in the 2.4 days, we didn't have BUG_ON.  We
> should do a s/J_ASSERT/BUG_ON/g pass over all of fs/jbd and fs/jbd2.
> I'll submit patches for application when the 2.6.27 merge window opens
> up --- or is this an obvious enough and safe enough transformation
> that it will get accepted mainline at this point?
> 

May as well get it over and done with.

We presently have a mix of J_ASSERT, J_ASSERT_JH and J_ASSERT_BH.  That
will become BUG_ON, J_ASSERT_JH and J_ASSERT_BH.  Which a is slightly
unpleasing loss of consistency but whatever.


