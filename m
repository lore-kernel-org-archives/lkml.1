Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbZASNSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbZASNSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbZASNSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:18:30 -0500
Received: from styx.suse.cz ([82.119.242.94]:58850 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751835AbZASNS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:18:29 -0500
Date: Mon, 19 Jan 2009 14:18:28 +0100
From: Jan Kara <jack@suse.cz>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: jack@suse.cz, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sector_t last is unsigned, so cannot be less than 0.
Message-ID: <20090119131828.GC10193@duck.suse.cz>
References: <4973B0F9.7010603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4973B0F9.7010603@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Roel,

On Sun 18-01-09 23:45:13, Roel Kluin wrote:
> sector_t last is unsigned, so cannot be less than 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index e25e701..1f3941d 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -721,7 +721,7 @@ static sector_t udf_scan_anchors(struct super_block *sb, sector_t lastblock)
>  	 *  however, if the disc isn't closed, it could be 512 */
>  
>  	for (i = 0; i < ARRAY_SIZE(last); i++) {
> -		if (last[i] < 0)
> +		if (last[i] > lastblock + 1)
>  			continue;
>  		if (last[i] >= sb->s_bdev->bd_inode->i_size >>
>  				sb->s_blocksize_bits)
  I already have your cleanup of this check in my UDF tree. I'm sorry it's not
in Linus's tree yet but I forgot to merge it with Linus during the merge
window..

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
