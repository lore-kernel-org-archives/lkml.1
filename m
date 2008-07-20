Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYGTMhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYGTMhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYGTMg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:36:59 -0400
Received: from fallback.mail.ru ([194.67.57.14]:24367 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808AbYGTMg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:36:58 -0400
Date: Sun, 20 Jul 2008 11:37:35 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <aviro@redhat.com>
Subject: Re: [RFC] parser: add const to parser token table
Message-ID: <20080720073735.GA12331@rain>
Mail-Followup-To: Steven Whitehouse <swhiteho@redhat.com>,
	linux-kernel@vger.kernel.org, Alexander Viro <aviro@redhat.com>
References: <1216300972.4011.291.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216300972.4011.291.camel@quoit>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:22:52PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> Any objections to the following patch? If not I'll send it on to Linus.
> 
> This patch adds a "const" to the parser token table. I've done an
> allmodconfig build to see if this produces any warnings/failures and the
> patch includes a fix for the only warning that was produced.
> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Alexander Viro <aviro@redhat.com>
> Cc: Evgeniy Dushistov <dushistov@mail.ru>
> 
> 
> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index 85b22b5..506f724 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -1232,7 +1232,7 @@ static int ufs_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  {
>  	struct ufs_sb_info *sbi = UFS_SB(vfs->mnt_sb);
>  	unsigned mval = sbi->s_mount_opt & UFS_MOUNT_UFSTYPE;
> -	struct match_token *tp = tokens;
> +	const struct match_token *tp = tokens;
>  
>  	while (tp->token != Opt_onerror_panic && tp->token != mval)
>  		++tp;
> diff --git a/include/linux/parser.h b/include/linux/parser.h
> index 7dcd050..cc554ca 100644
> --- a/include/linux/parser.h
> +++ b/include/linux/parser.h
> @@ -14,7 +14,7 @@ struct match_token {
>  	const char *pattern;
>  };
>  
> -typedef struct match_token match_table_t[];
> +typedef const struct match_token match_table_t[];
>  
>  /* Maximum number of arguments that match_token will find in a pattern */
>  enum {MAX_OPT_ARGS = 3};
> 
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>

-- 
/Evgeniy

