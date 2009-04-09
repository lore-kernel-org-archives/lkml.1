Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZDIVAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZDIVAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760743AbZDIVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:00:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760325AbZDIVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:00:22 -0400
Date: Thu, 9 Apr 2009 13:58:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: jeffm@suse.com, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reiserfs: fix printk format warning
Message-Id: <20090409135803.2c011dee.akpm@linux-foundation.org>
In-Reply-To: <20090403013437.GA29003@orion>
References: <20090403013437.GA29003@orion>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009 05:34:37 +0400
Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Fix following warning message
> fs/reiserfs/procfs.c:393: warning: format '%u' expects type 'unsigned int', but argument 22 has type 'long unsigned int'
> introduced in 600ed4167
> (reiserfs: audit transaction ids to always be unsigned ints)
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  include/linux/reiserfs_fs_sb.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
> index 5621d87..1d1594a 100644
> --- a/include/linux/reiserfs_fs_sb.h
> +++ b/include/linux/reiserfs_fs_sb.h
> @@ -193,7 +193,7 @@ struct reiserfs_journal {
>  	atomic_t j_wcount;	/* count of writers for current commit */
>  	unsigned long j_bcount;	/* batch count. allows turning X transactions into 1 */
>  	unsigned long j_first_unflushed_offset;	/* first unflushed transactions offset */
> -	unsigned long j_last_flush_trans_id;	/* last fully flushed journal timestamp */
> +	unsigned int j_last_flush_trans_id;	/* last fully flushed journal timestamp */
>  	struct buffer_head *j_header_bh;
>  
>  	time_t j_trans_start_time;	/* time this transaction started */

Yes, looking at the code I think it does want to be a u32.


