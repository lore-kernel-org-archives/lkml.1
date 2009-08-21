Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZHUPcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZHUPcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932305AbZHUPcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:32:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbZHUPce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:32:34 -0400
Date: Fri, 21 Aug 2009 11:32:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>, Felix Blyakher <felixb@sgi.com>,
       xfs@oss.sgi.com, Anton Altaparmakov <aia21@cantab.net>,
       linux-ntfs-dev@lists.sourceforge.net,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090821153235.GA5874@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-8-git-send-email-jack@suse.cz> <20090819162638.GE6150@infradead.org> <20090820121531.GC16486@duck.novell.com> <20090820162729.GA24659@infradead.org> <20090821152339.GD3007@duck.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821152339.GD3007@duck.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 05:23:39PM +0200, Jan Kara wrote:
>   Hmm, I can imagine it would buy us something in two cases (but looking at
> the code, neither is implemented in such a way that it would really help
> us in any way):
> 1) when an inode and it's data are stored in one block (e.g. OCFS2 or UDF) do
>    this.

>   In the first case we would wait for block with data to be written only to
> submit it again because inode was still dirty.

But we would not actually store in the pagecache or at least never
writeback it via the pacache in that case, but always just write it as
part of the inode.

