Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbZADTTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbZADTTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZADTTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:19:15 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:24800 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752164AbZADTTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:19:14 -0500
Date: Sun, 4 Jan 2009 22:15:59 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ufs: validate maximum fast symlink size from
	superblock
Message-ID: <20090104191558.GA23805@rain>
Mail-Followup-To: Duane Griffin <duaneg@dghda.com>,
	linux-kernel@vger.kernel.org
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230742208-23972-1-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 04:50:05PM +0000, Duane Griffin wrote:
> The maximum fast symlink size is set in the superblock of certain types
> of UFS filesystem. Before using it we need to check that it isn't longer
> than the available space we have in the inode.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>  fs/ufs/super.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> +		printk(KERN_WARNING "ufs_read_super: excessive maximum fast "
> +		       "symlink size (%u)\n", uspi->s_maxsymlinklen);
> +		uspi->s_maxsymlinklen = maxsymlen;
> +	}
> +

Better and logically to use ufs_warning here, because of it show device id,
in case person has serveral ufs formated partitions and mount happened
during system boot time.

-- 
/Evgeniy

