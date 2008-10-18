Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYJRU5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYJRU5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYJRU5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:57:10 -0400
Received: from 1wt.eu ([62.212.114.60]:4841 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYJRU5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:57:09 -0400
Date: Sat, 18 Oct 2008 22:56:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hugh@veritas.com>, Peter Cordes <peter@cordes.ca>,
       Bodo Eggert <7eggert@gmx.de>, David Newall <davidn@davidnewall.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: no way to swapoff a deleted swap file?
Message-ID: <20081018205647.GA29946@1wt.eu>
References: <bnlDw-5vQ-7@gated-at.bofh.it> <bnwpg-2EA-17@gated-at.bofh.it> <bnJFK-3bu-7@gated-at.bofh.it> <bnR0A-4kq-1@gated-at.bofh.it> <E1KqkZK-0001HO-WF@be1.7eggert.dyndns.org> <Pine.LNX.4.64.0810171250410.22374@blonde.site> <20081018003117.GC26067@cordes.ca> <20081018051800.GO24654@1wt.eu> <Pine.LNX.4.64.0810182058120.7154@blonde.site> <20081018204948.GA22140@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018204948.GA22140@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 04:49:48PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 18, 2008 at 09:45:14PM +0100, Hugh Dickins wrote:
> > --- 2.6.27/fs/namei.c	2008-10-09 23:13:53.000000000 +0100
> > +++ linux/fs/namei.c	2008-10-18 21:33:01.000000000 +0100
> > @@ -1407,7 +1407,7 @@ static int may_delete(struct inode *dir,
> >  	if (IS_APPEND(dir))
> >  		return -EPERM;
> >  	if (check_sticky(dir, victim->d_inode)||IS_APPEND(victim->d_inode)||
> > -	    IS_IMMUTABLE(victim->d_inode))
> > +	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
> >  		return -EPERM;
> >  	if (isdir) {
> >  		if (!S_ISDIR(victim->d_inode->i_mode))
> 
> Looks reasonable.

I like the idea and the simplicity a lot !

Willy

