Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYAGLhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYAGLhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbYAGLhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:37:22 -0500
Received: from styx.suse.cz ([82.119.242.94]:48594 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757264AbYAGLhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:37:20 -0500
Date: Mon, 7 Jan 2008 12:37:19 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 24/24] udf: fix sparse warnings (shadowing & mismatch
	between declaration and definition)
Message-ID: <20080107113719.GG12589@duck.suse.cz>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-25-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198374674-12128-25-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-12-07 02:51:14, marcin.slusarz@gmail.com wrote:
> fix warnings:
> fs/udf/super.c:1370:24: warning: symbol 'bh' shadows an earlier one
> fs/udf/super.c:1288:21: originally declared here
> fs/udf/super.c:450:6: warning: symbol 'udf_write_super' was not declared. Should it be static?
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> CC: Jan Kara <jack@suse.cz>
  Looks fine. Acked-by: Jan Kara <jack@suse.cz>

											Honza

> ---
>  fs/udf/super.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index f6c911b..da68130 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -447,7 +447,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
>  	return 1;
>  }
>  
> -void udf_write_super(struct super_block *sb)
> +static void udf_write_super(struct super_block *sb)
>  {
>  	lock_kernel();
>  
> @@ -1367,7 +1367,6 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
>  				map->s_type_specific.s_virtual.s_num_entries =
>  					(udf_sb_vat_inode(sb)->i_size - 36) >> 2;
>  			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
> -				struct buffer_head *bh = NULL;
>  				uint32_t pos;
>  
>  				pos = udf_block_map(udf_sb_vat_inode(sb), 0);
> -- 
> 1.5.3.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
