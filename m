Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYJOTlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYJOTlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYJOTlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:41:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYJOTlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:41:22 -0400
Date: Wed, 15 Oct 2008 15:41:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vfs: add __d_instantiate() helper
Message-ID: <20081015194119.GA24892@infradead.org>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp> <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp> <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:58:10PM +0900, OGAWA Hirofumi wrote:
> 
> This adds __d_instantiate() for users which is already taking
> dcache_lock, and replace with it.
> 
> The part of d_add_ci() isn't equivalent. But it should be needed
> fsnotify_d_instantiate() actually, because the path is to add the
> inode to negative dentry.  fsnotify_d_instantiate() should be called
> after change from negative to positive.
> 
> __d_instantiate_unique() and d_materialise_unique() does opencoded
> optimized version. From history, it seems a intent, so just add comment.

Looks good, but I think those "optimized' version should also be
converted, a single if shouldn't matter with todays branch predictors.

