Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYDDVfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYDDVfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYDDVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:35:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27776 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYDDVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:35:20 -0400
Date: Fri, 4 Apr 2008 14:34:53 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ocfs2: replace remaining __PRETTY_FUNCTION__
	occurrences
Message-ID: <20080404213453.GL32107@mail.oracle.com>
Mail-Followup-To: Harvey Harrison <harvey.harrison@gmail.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1207344480.18838.96.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207344480.18838.96.camel@brick>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 02:28:00PM -0700, Harvey Harrison wrote:
> The kernel is written in C, not C++, use __func__

__PRETTY_FUNCTION__ is GNU C, but __func__ is still better.
Acked-by: Joel Becker <joel.becker@oracle.com>

> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/ocfs2/cluster/masklog.h |    2 +-
>  fs/ocfs2/dlmglue.c         |    2 +-
>  fs/ocfs2/super.h           |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
> index 597e064..8bdb182 100644
> --- a/fs/ocfs2/cluster/masklog.h
> +++ b/fs/ocfs2/cluster/masklog.h
> @@ -193,7 +193,7 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
>   */
>  #define __mlog_printk(level, fmt, args...)				\
>  	printk(level "(%u,%lu):%s:%d " fmt, task_pid_nr(current),	\
> -	       __mlog_cpu_guess, __PRETTY_FUNCTION__, __LINE__ ,	\
> +	       __mlog_cpu_guess, __func__, __LINE__ ,	\
>  	       ##args)
>  
>  #define mlog(mask, fmt, args...) do {					\
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 1f1873b..5a3f1f4 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -105,7 +105,7 @@ static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
>  				     struct ocfs2_lock_res *lockres);
>  
> 
> -#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
> +#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __func__, __LINE__, __lockres)
>  
>  /* This aids in debugging situations where a bad LVB might be involved. */
>  static void ocfs2_dump_meta_lvb_info(u64 level,
> diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
> index 783f527..15e2d98 100644
> --- a/fs/ocfs2/super.h
> +++ b/fs/ocfs2/super.h
> @@ -36,13 +36,13 @@ void __ocfs2_error(struct super_block *sb,
>  		   const char *fmt, ...)
>  	__attribute__ ((format (printf, 3, 4)));
>  
> -#define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
> +#define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __func__, fmt, ##args)
>  
>  void __ocfs2_abort(struct super_block *sb,
>  		   const char *function,
>  		   const char *fmt, ...)
>  	__attribute__ ((format (printf, 3, 4)));
>  
> -#define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##args)
> +#define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __func__, fmt, ##args)
>  
>  #endif /* OCFS2_SUPER_H */
> -- 
> 1.5.5.rc1.135.g8527
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 

 "I'm living so far beyond my income that we may almost be said
 to be living apart."
         - e e cummings

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
