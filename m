Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbYAaQxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbYAaQxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbYAaQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:52:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:40530 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765177AbYAaQwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:52:45 -0500
Date: Thu, 31 Jan 2008 17:52:44 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] udf: constify udf_bitmap_lookup array
Message-ID: <20080131165244.GJ1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-11-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-11-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:04:00, marcin.slusarz@gmail.com wrote:
> udf_bitmap_lookup never changes, so constify it
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Hmm, rather than doing this, could you change the function to use
standard functions for counting set bits? I guess bitmap_weight() in
include/linux/bitmap.h should be what we need... Thanks.

								Honza

> ---
>  fs/udf/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3afe764..6bb2a5b 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1969,7 +1969,7 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	return 0;
>  }
>  
> -static unsigned char udf_bitmap_lookup[16] = {
> +static const unsigned char udf_bitmap_lookup[16] = {
>  	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
>  };
>  
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
