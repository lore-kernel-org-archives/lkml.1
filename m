Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYJOUsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYJOUsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYJOUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:48:46 -0400
Received: from mx2.netapp.com ([216.240.18.37]:13164 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYJOUsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:48:45 -0400
X-IronPort-AV: E=Sophos;i="4.33,418,1220252400"; 
   d="scan'208";a="73933507"
Subject: Re: [PATCH 3/6] vfs: add __d_instantiate() helper
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <87wsg9oan7.fsf@devron.myhome.or.jp>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	 <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	 <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	 <20081015194119.GA24892@infradead.org> <87wsg9oan7.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Wed, 15 Oct 2008 16:47:47 -0400
Message-Id: <1224103667.7371.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 15 Oct 2008 20:48:44.0098 (UTC) FILETIME=[69ACD220:01C92F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 05:39 +0900, OGAWA Hirofumi wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Wed, Oct 15, 2008 at 10:58:10PM +0900, OGAWA Hirofumi wrote:
> >> 
> >> This adds __d_instantiate() for users which is already taking
> >> dcache_lock, and replace with it.
> >> 
> >> The part of d_add_ci() isn't equivalent. But it should be needed
> >> fsnotify_d_instantiate() actually, because the path is to add the
> >> inode to negative dentry.  fsnotify_d_instantiate() should be called
> >> after change from negative to positive.
> >> 
> >> __d_instantiate_unique() and d_materialise_unique() does opencoded
> >> optimized version. From history, it seems a intent, so just add comment.
> >
> > Looks good, but I think those "optimized' version should also be
> > converted, a single if shouldn't matter with todays branch predictors.
> 
> Me too.
> 
> Trond, do you care the following convert? E.g.
> 
> in d_materialise_unique():
> 
> from
> 		dentry->d_inode = NULL;
> 		goto found_lock;
> to
> 		__d_instantiate(dentry, NULL);
> 		goto found_lock;

That would be fine by me.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
