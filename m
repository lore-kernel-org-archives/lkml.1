Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbZFCP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbZFCP5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZFCP5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:57:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbZFCP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:57:12 -0400
Date: Wed, 3 Jun 2009 11:56:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, wli@holomorphy.com, hch@infradead.org,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] vfs: Split generic_forget_inode() so that hugetlbfs
	does not have to copy it
Message-ID: <20090603155638.GA29914@infradead.org>
References: <1243959634-22067-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243959634-22067-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 06:20:34PM +0200, Jan Kara wrote:
> Hugetlbfs needs to do special things instead of truncate_inode_pages().
> Currently, it copied generic_forget_inode() except for truncate_inode_pages()
> call which is asking for trouble (the code there isn't trivial). So create a
> separate function generic_detach_inode() which does all the list magic done in
> generic_forget_inode() and call it from hugetlbfs_forget_inode().

Looks good to me, but long term I'd just prefer to have
truncate_inode_pages do the right thing for huge pages..

> +/*
> + * Remove inode from inode lists, write it if it's dirty.
> + *
> + * Returns 1 if inode should be completely destroyed.
> + */

Please make this a kerneldoc comment.  And mention that this is just
and internal helper that can go away any time.

