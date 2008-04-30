Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbYD3T3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbYD3T3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbYD3T3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:29:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154AbYD3T3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:29:17 -0400
Date: Wed, 30 Apr 2008 12:29:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH] quota: Add a convenience macro for filesystems
Message-Id: <20080430122911.61945aa9.akpm@linux-foundation.org>
In-Reply-To: <12095679824183-git-send-email-jack@suse.cz>
References: <12095679813226-git-send-email-jack@suse.cz>
	<12095679812375-git-send-email-jack@suse.cz>
	<12095679812452-git-send-email-jack@suse.cz>
	<1209567981639-git-send-email-jack@suse.cz>
	<1209567981323-git-send-email-jack@suse.cz>
	<12095679812717-git-send-email-jack@suse.cz>
	<12095679824183-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 17:06:18 +0200
Jan Kara <jack@suse.cz> wrote:

> Note that it cannot be an inline function because we don't have struct
> super_block prototype...
> 

lame excuse ;)

> ---
>  include/linux/quota.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 52e49dc..dcddfb2 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -347,6 +347,9 @@ struct quota_info {
>  	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
>  			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
>  
> +#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
> +				  sb_has_quota_suspended(sb, GRPQUOTA))
> +
>  int register_quota_format(struct quota_format_type *fmt);
>  void unregister_quota_format(struct quota_format_type *fmt);


Here's a fun exercise:

	sb = sb_orig;
	sb_any_quota_suspended(sb++);
	printk("%d\n", sb - sb_orig);

afaict this will print 44 or thereabouts.

ho hum.
