Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZFDTBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZFDTBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZFDTBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:01:40 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55770 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751091AbZFDTBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:01:40 -0400
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Message-Id: <5DFB5844-7C2C-4987-BC20-6CC81E0BF1BD@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Artem Bityutskiy <dedekind@infradead.org>
In-Reply-To: <1244112114-23144-2-git-send-email-dedekind@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH v2 01/17] VFS: introduce helpers for manipulation s_dirty flag
Date: Thu, 4 Jun 2009 14:01:40 -0500
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org> <1244112114-23144-2-git-send-email-dedekind@infradead.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 4, 2009, at 5:41 AM, Artem Bityutskiy wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>
> This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
> 'mark_sb_clean()', and 'sb_is_dirty()'.

Should the name be is_sb_dirty() for consistency?

Felix

> The helpers simply
> set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
> every FS use these helpers instead of manipulating
> 'sb->s_dirt' directly. And the further plan is to stop the
> periodic write-back when there is no dirt.
>
> This patch is just a preparation. No functional changes yet.
>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
> include/linux/fs.h |   17 +++++++++++++++++
> 1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 73242c3..2d67017 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1782,6 +1782,23 @@ extern int get_sb_pseudo(struct  
> file_system_type *, char *,
> extern void simple_set_mnt(struct vfsmount *mnt, struct super_block  
> *sb);
> int __put_super_and_need_restart(struct super_block *sb);
>
> +/*
> + * Note, VFS does not provide any protection for the super block  
> clean/dirty
> + * state. File-systems should take care of this.
> + */
> +static inline void mark_sb_dirty(struct super_block *sb)
> +{
> +	sb->s_dirt = 1;
> +}
> +static inline void mark_sb_clean(struct super_block *sb)
> +{
> +	sb->s_dirt = 0;
> +}
> +static inline int sb_is_dirty(struct super_block *sb)
> +{
> +	return sb->s_dirt;
> +}
> +
> /* Alas, no aliases. Too much hassle with bringing module.h  
> everywhere */
> #define fops_get(fops) \
> 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
> -- 
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

