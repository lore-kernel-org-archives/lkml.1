Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYAWRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYAWRvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYAWRvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:51:02 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYAWRvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:51:00 -0500
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
	sys_msync()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Salikhmetov <salikhmetov@gmail.com>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org>
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083504-git-send-email-salikhmetov@gmail.com>
	 <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 18:41:06 +0100
Message-Id: <1201110066.6341.65.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 09:05 -0800, Linus Torvalds wrote:

> So here's even a patch to get you started. Do this:
> 
> 	git revert 204ec841fbea3e5138168edbc3a76d46747cc987
> 
> and then use this appended patch on top of that as a starting point for 
> something that compiles and *possibly* works.
> 
> And no, I do *not* guarantee that this is right either! I have not tested 
> it or thought about it a lot, and S390 tends to be odd about some of these 
> things. In particular, I actually suspect that we should possibly do this 
> the same way we do
> 
> 	ptep_clear_flush_young()
> 
> except we would do "ptep_clear_flush_wrprotect()". So even though this is 
> a revert plus a simple patch to make it compile again (we've changed how 
> we do dirty bits), I think a patch like this needs testing and other 
> people like Nick and Peter to ack it.
> 
> Nick? Peter? Testing? Other comments?

It would need some addition piece to not call msync_interval() for
MS_SYNC, and remove the balance_dirty_pages_ratelimited_nr() stuff.

But yeah, this pte walker is much better. 

As for s390, I think they only differ on the dirty bit, and we should
not be touching that.

