Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbYJRUuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbYJRUuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYJRUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:50:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbYJRUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:50:05 -0400
Date: Sat, 18 Oct 2008 16:49:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Willy Tarreau <w@1wt.eu>, Peter Cordes <peter@cordes.ca>,
       Bodo Eggert <7eggert@gmx.de>, David Newall <davidn@davidnewall.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: no way to swapoff a deleted swap file?
Message-ID: <20081018204948.GA22140@infradead.org>
References: <bnlDw-5vQ-7@gated-at.bofh.it> <bnwpg-2EA-17@gated-at.bofh.it> <bnJFK-3bu-7@gated-at.bofh.it> <bnR0A-4kq-1@gated-at.bofh.it> <E1KqkZK-0001HO-WF@be1.7eggert.dyndns.org> <Pine.LNX.4.64.0810171250410.22374@blonde.site> <20081018003117.GC26067@cordes.ca> <20081018051800.GO24654@1wt.eu> <Pine.LNX.4.64.0810182058120.7154@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810182058120.7154@blonde.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 09:45:14PM +0100, Hugh Dickins wrote:
> --- 2.6.27/fs/namei.c	2008-10-09 23:13:53.000000000 +0100
> +++ linux/fs/namei.c	2008-10-18 21:33:01.000000000 +0100
> @@ -1407,7 +1407,7 @@ static int may_delete(struct inode *dir,
>  	if (IS_APPEND(dir))
>  		return -EPERM;
>  	if (check_sticky(dir, victim->d_inode)||IS_APPEND(victim->d_inode)||
> -	    IS_IMMUTABLE(victim->d_inode))
> +	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
>  		return -EPERM;
>  	if (isdir) {
>  		if (!S_ISDIR(victim->d_inode->i_mode))

Looks reasonable.
