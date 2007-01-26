Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbXAZMbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbXAZMbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 07:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXAZMbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 07:31:42 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:45127 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXAZMbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 07:31:41 -0500
Message-ID: <45B9F73C.4070700@openvz.org>
Date: Fri, 26 Jan 2007 15:42:36 +0300
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] make static counters in new_inode and iunique be
 32 bits
References: <200612291911.kBTJB5dO019099@dantu.rdu.redhat.com>
In-Reply-To: <200612291911.kBTJB5dO019099@dantu.rdu.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Kirill Korotaev <dev@openvz.org>

hit it today as well :/

> When a 32-bit program that was not compiled with large file offsets does a
> stat and gets a st_ino value back that won't fit in the 32 bit field, glibc
> (correctly) generates an EOVERFLOW error. We can't do anything about fs's
> with larger permanent inode numbers, but when we generate them on the fly,
> we ought to try and have them fit within a 32 bit field.
> 
> This patch takes the first step toward this by making the static counters in
> these two functions be 32 bits.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index bf21dc6..23fc1fd 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -524,7 +524,8 @@ repeat:
>   */
>  struct inode *new_inode(struct super_block *sb)
>  {
> -	static unsigned long last_ino;
> +	/* 32 bits for compatability mode stat calls */
> +	static unsigned int last_ino;
>  	struct inode * inode;
>  
>  	spin_lock_prefetch(&inode_lock);
> @@ -683,7 +684,8 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
>   */
>  ino_t iunique(struct super_block *sb, ino_t max_reserved)
>  {
> -	static ino_t counter;
> +	/* 32 bits for compatability mode stat calls */
> +	static unsigned int counter;
>  	struct inode *inode;
>  	struct hlist_head * head;
>  	ino_t res;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

