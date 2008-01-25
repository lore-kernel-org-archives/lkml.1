Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbYAYUYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbYAYUYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYAYUXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:23:51 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:47941 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYAYUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:23:50 -0500
Date: Thu, 24 Jan 2008 23:41:31 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [patch 12/26] mount options: fix ext4
In-reply-to: <20080124193432.492168716@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>
Mail-followup-to: Miklos Szeredi <miklos@szeredi.hu>,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@MIT.EDU>
Message-id: <20080125064131.GR18433@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080124193341.166753833@szeredi.hu>
 <20080124193432.492168716@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2008  20:33 +0100, Miklos Szeredi wrote:
> Add stripe= option to /proc/mounts for ext4 filesystems.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: Andreas Dilger <adilger@sun.com>

> Index: linux/fs/ext4/super.c
> ===================================================================
> --- linux.orig/fs/ext4/super.c	2008-01-23 12:57:07.000000000 +0100
> +++ linux/fs/ext4/super.c	2008-01-23 21:43:51.000000000 +0100
> @@ -742,7 +742,8 @@ static int ext4_show_options(struct seq_
>  		seq_puts(seq, ",nomballoc");
>  	if (!test_opt(sb, DELALLOC))
>  		seq_puts(seq, ",nodelalloc");
> -
> +	if (sbi->s_stripe)
> +		seq_printf(seq, ",stripe=%lu", sbi->s_stripe);
>  
>  	/*
>  	 * journal mode get enabled in different ways

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

