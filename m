Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYGICyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYGICyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 22:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYGICya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 22:54:30 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55066 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752720AbYGICya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 22:54:30 -0400
Date: Tue, 8 Jul 2008 22:53:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Duane Griffin <duaneg@dghda.com>
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       Mingming <cmm@us.ibm.com>, Sami Liedes <sliedes@cc.hut.fi>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: handle deleting corrupted indirect blocks
Message-ID: <20080709025304.GG9957@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Duane Griffin <duaneg@dghda.com>, akpm@linux-foundation.org,
	sct@redhat.com, adilger@clusterfs.com, Mingming <cmm@us.ibm.com>,
	Sami Liedes <sliedes@cc.hut.fi>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1215528121-26934-1-git-send-email-duaneg@dghda.com> <1215528121-26934-2-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215528121-26934-2-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 03:42:00PM +0100, Duane Griffin wrote:
> +		if (bh2jh(this_bh))
> +			ext4_journal_dirty_metadata(handle, this_bh);
> +		else
> +			ext4_error(inode->i_sb, __func__,
> +				   "circular indirect block detected, "
> +				   "inode=%lu, block=%lu",
> +				   inode->i_ino, this_bh->b_blocknr);

this_bh->b_blocknr is a sector_t, which could be 64-bits.  So this
should be:

			ext4_error(inode->i_sb, __func__,
				   "circular indirect block detected, "
				   "inode=%lu, block=%llu",
				   inode->i_ino,
				   (unsigned long long) this_bh->b_blocknr);

I think.

With this change, I've included your three patches into the ext4 patch
queue.

						- Ted

