Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYJBGN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYJBGN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYJBGMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:12:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbYJBGMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:12:23 -0400
Date: Wed, 1 Oct 2008 23:11:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       tao.ma@oracle.com, mfasheh@suse.com
Subject: Re: [PATCH 10/39] ocfs2: Add helper function in uptodate.c for
 removing xattr clusters
Message-Id: <20081001231156.c52c98b5.akpm@linux-foundation.org>
In-Reply-To: <1222293680-15451-11-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-11-git-send-email-mfasheh@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:51 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +/* Called when we remove xattr clusters from an inode. */
> +void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
> +					    sector_t block,
> +					    u32 c_len)
> +{
> +	u64 i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
> +
> +	for (i = 0; i < b_len; i++, block++)
> +		ocfs2_remove_block_from_cache(inode, block);
> +}

I really really hope that `i' and `b_len' didn't really need to be
64-bit here.
