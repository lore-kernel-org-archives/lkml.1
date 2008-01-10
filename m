Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbYAJXEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbYAJXEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYAJXEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:04:22 -0500
Received: from styx.suse.cz ([82.119.242.94]:47258 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbYAJXEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:04:22 -0500
Date: Fri, 11 Jan 2008 00:04:20 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/16] udf: check if udf_load_logicalvol failed
Message-ID: <20080110230420.GA17430@duck.suse.cz>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-5-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200002792-8449-5-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-01-08 23:06:20, marcin.slusarz@gmail.com wrote:
> udf_load_logicalvol may fail eg in out of memory conditions - check it
> and propagate error further
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> CC: Jan Kara <jack@suse.cz>
> CC: Christoph Hellwig <hch@infradead.org>
  Acked-by: Jan Kara <jack@suse.cz>

> ---
>  fs/udf/super.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3f5b632..9257796 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1263,7 +1263,10 @@ static int udf_process_sequence(struct super_block *sb, long block,
>  			if (i == VDS_POS_PRIMARY_VOL_DESC) {
>  				udf_load_pvoldesc(sb, bh);
>  			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
> -				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
> +				if (udf_load_logicalvol(sb, bh, fileset)) {
> +					brelse(bh);
> +					return 1;
> +				}
>  			} else if (i == VDS_POS_PARTITION_DESC) {
>  				struct buffer_head *bh2 = NULL;
>  				if (udf_load_partdesc(sb, bh)) {
> -- 
> 1.5.3.7
> 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
