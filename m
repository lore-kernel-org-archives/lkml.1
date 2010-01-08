Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405Ab0AHMlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0AHMlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344Ab0AHMlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:41:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab0AHMli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:41:38 -0500
Date: Fri, 8 Jan 2010 13:41:39 +0100
From: Jan Kara <jack@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Greg KH <gregkh@suse.de>,
       Thomas Voegtle <tv@lio96.de>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] quota: fix reserved space management for ordinary fs
Message-ID: <20100108124139.GC3354@quack.suse.cz>
References: <20100106234533.GC1960@kroah.com>
 <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
 <20100107180449.GA17495@suse.de>
 <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
 <20100107194131.GA22983@suse.de>
 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
 <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
 <20100107220213.GA24882@suse.de>
 <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
 <87wrztpgbh.fsf_-_@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wrztpgbh.fsf_-_@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-01-10 03:53:54, Dmitry Monakhov wrote:
> 
> In fact inode_get_rsv_space() function is special in comparison
> with inode_{add,sub,claim}_rsv_space() functions, because
> it may return correct result even for fs without reserved space
> support(correct val == 0). Add trivial check for that case.
> The patch fix regression(BUG at fs/quota/dquot.c:1350) introduced
> in following commit: fd8fbfc1709822bd94247c5b2ab15a5f5041e103
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Acked-by: Jan Kara <jack@suse.cz>

Greg, please merge this patch to stable series. I'll push the same
patch I have in my tree to Linus on Monday.

								Honza
> ---
>  fs/quota/dquot.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index dea86ab..d9f06cf 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1377,6 +1377,8 @@ static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
>  static qsize_t inode_get_rsv_space(struct inode *inode)
>  {
>  	qsize_t ret;
> +	if (!inode->i_sb->dq_op->get_reserved_space)
> +		return 0;
>  	spin_lock(&inode->i_lock);
>  	ret = *inode_reserved_space(inode);
>  	spin_unlock(&inode->i_lock);
> -- 
> 1.6.3.3
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
