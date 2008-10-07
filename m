Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbYJGLs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbYJGLs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYJGLsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:48:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYJGLsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:48:19 -0400
Date: Tue, 7 Oct 2008 07:48:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC PATCH] i_version: remount support
Message-ID: <20081007114817.GA7024@infradead.org>
References: <10dbd13724581b0dca8d77ae944aaf3c70b93137.1223341927.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10dbd13724581b0dca8d77ae944aaf3c70b93137.1223341927.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 07:30:48AM -0400, Mimi Zohar wrote:
> Add support for remounting a filesystem with the i_version option.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
> diff --git a/fs/super.c b/fs/super.c
> index e931ae9..3758cbe 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -641,6 +641,8 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>  			return retval;
>  	}
>  	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
> +	if (flags & MS_I_VERSION)
> +		sb->s_flags |= MS_I_VERSION;

The proper way would be to add it to MS_RMT_MASK.

