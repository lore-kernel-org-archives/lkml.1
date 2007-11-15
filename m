Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbXKOUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbXKOUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbXKOUCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:02:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60086 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426AbXKOUCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:02:08 -0500
Subject: Re: [RFC] fuse writable mmap design
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <E1Iskpw-0000qY-00@dorka.pomaz.szeredi.hu>
References: <E1IshIR-0000fE-00@dorka.pomaz.szeredi.hu>
	 <1195154530.22457.16.camel@lappy>
	 <E1IskWl-0000oJ-00@dorka.pomaz.szeredi.hu>
	 <1195155759.22457.29.camel@lappy>
	 <E1Iskpw-0000qY-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 21:01:39 +0100
Message-Id: <1195156900.22457.32.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-15 at 20:57 +0100, Miklos Szeredi wrote:
> > The next point then, I'd expect your fuse_page_mkwrite() to push
> > writeout of your 32-odd mmap pages instead of poll.
> 
> You're talking about this:
> 
> +	wait_event(fc->writeback_waitq,
> +		   fc->numwrite < FUSE_WRITEBACK_THRESHOLD);
> 
> right?  It's one of the things I need to clean out, there's no point
> in fc->numwrite, which is essentially the same as the BDI_WRITEBACK
> counter.
> 
> OTOH, I'm thinking about adding a per-fs limit (adjustable for
> privileged mounts) of dirty+writeback.
> 
> I'm not sure how hard would it be to add support for this into
> balance_dirty_pages().  So I'm thinking of a parameter in struct
> backing_dev_info that is used to clip the calculated per-bdi threshold
> below this maximum.
> 
> How would that affect the proportions algorithm?  What would happen to
> the unused portion?  Would it adapt to the slowed writeback and
> allocate it to some other writer?

The unused part is gone, I've not yet found a way to re-distribute this
fairly.

[ It's one of my open-problems, I can do a min_ratio per bdi, but not
  yet a max_ratio ]

