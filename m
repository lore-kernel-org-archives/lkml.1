Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYAYOhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYAYOhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYAYOh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:37:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41810 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbYAYOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:37:25 -0500
Date: Fri, 25 Jan 2008 15:37:24 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>,
       Mingming Cao <cmm@us.ibm.com>
Subject: Re: [patch 12/26] mount options: fix ext4
Message-ID: <20080125143724.GB28856@atrey.karlin.mff.cuni.cz>
References: <20080124193341.166753833@szeredi.hu> <20080124193432.492168716@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124193432.492168716@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add stripe= option to /proc/mounts for ext4 filesystems.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
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
  I think this should go via ext4 patch queue... Besides that the patch
is fine. Mingming, will you pickup the patch?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
