Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYAXVPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYAXVPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbYAXVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:15:14 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53824 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703AbYAXVPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:15:11 -0500
Subject: Re: [patch 19/26] mount options: fix jfs
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080124193445.807705054@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
	 <20080124193445.807705054@szeredi.hu>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 15:15:01 -0600
Message-Id: <1201209301.32767.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-24 at 20:34 +0100, Miklos Szeredi wrote:
> plain text document attachment (jfs_opts.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add iocharset= and errors= options to /proc/mounts for jfs
> filesystems.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Andrew,
Would you like me to add this to the jfs git tree, or would you like to
handle these patches as a set?

Thanks,
Shaggy

> ---
> 
> Index: linux/fs/jfs/super.c
> ===================================================================
> --- linux.orig/fs/jfs/super.c	2008-01-17 19:00:55.000000000 +0100
> +++ linux/fs/jfs/super.c	2008-01-21 19:39:30.000000000 +0100
> @@ -602,6 +602,12 @@ static int jfs_show_options(struct seq_f
>  		seq_printf(seq, ",umask=%03o", sbi->umask);
>  	if (sbi->flag & JFS_NOINTEGRITY)
>  		seq_puts(seq, ",nointegrity");
> +	if (sbi->nls_tab)
> +		seq_printf(seq, ",iocharset=%s", sbi->nls_tab->charset);
> +	if (sbi->flag & JFS_ERR_CONTINUE)
> +		seq_printf(seq, ",errors=continue");
> +	if (sbi->flag & JFS_ERR_PANIC)
> +		seq_printf(seq, ",errors=panic");
>  
>  #ifdef CONFIG_QUOTA
>  	if (sbi->flag & JFS_USRQUOTA)
> 
> --
-- 
David Kleikamp
IBM Linux Technology Center

