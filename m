Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbXGDURk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbXGDURk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXGDURc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:17:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:24748 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbXGDURa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=d9/EktSeEleYXveLZT55HgFuKzdqT1OX5s7jggqpVqyK9DoHuIpIUTrWdOvNXBg52bhxiPZ9MzG2i/ywo1gFlc85i4VDB6zn7rvLpTYZ6zCRQMV1BnnpLqE94Cnv3bUT07ktc8DNJBUNxm23pL95EKoR/IzwJsl4qau2JwqQeWk=
Date: Thu, 5 Jul 2007 00:17:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix error handling in ext4_create_journal
Message-ID: <20070704201725.GA5812@martell.zuzino.mipt.ru>
References: <20070701221111.GA8627@gollum.tnic> <20070703152543.e58ad39a.akpm@linux-foundation.org> <20070704193024.GA6802@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704193024.GA6802@gollum.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 09:30:24PM +0200, Borislav Petkov wrote:
> Fix error handling in ext4_create_journal according to kernel conventions.

> --- linux-2.6.22-rc7/fs/ext4/super.c.orig
> +++ linux-2.6.22-rc7/fs/ext4/super.c
> @@ -2150,6 +2150,7 @@
>  			       unsigned int journal_inum)
>  {
>  	journal_t *journal;
> +	int err;
>  
>  	if (sb->s_flags & MS_RDONLY) {
>  		printk(KERN_ERR "EXT4-fs: readonly filesystem when trying to "
> @@ -2157,13 +2158,15 @@
>  		return -EROFS;
>  	}
>  
> -	if (!(journal = ext4_get_journal(sb, journal_inum)))
> +	journal = ext4_get_journal(sb, journal_inum);
> +	if (!journal)
>  		return -EINVAL;

OK.

>  	printk(KERN_INFO "EXT4-fs: creating new journal on inode %u\n",
>  	       journal_inum);
>  
> -	if (jbd2_journal_create(journal)) {
> +	err = jbd2_journal_create(journal);
> +	if (err) {
>  		printk(KERN_ERR "EXT4-fs: error creating journal.\n");
>  		jbd2_journal_destroy(journal);
>  		return -EIO;

Original code is fine.

