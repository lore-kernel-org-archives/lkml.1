Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbZKWLY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbZKWLY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZKWLY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:24:58 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:38498 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbZKWLY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:24:57 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 06:24:56 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=blYPQppUPDyfOc0Bfmayif+COcNEr+bLr7vQ+YF1MA7Z1d5WNYXhkREbuW7VTGbrkw
         jW4zxSFiYZZf1nyB1dKVh5grUh1aJ4ez6Grlmjqu17akDJVPQRkoMmRFlNJOopM7g8vJ
         S3QrfkZU4BiQWlqkjbz4o/dQeb4OvrE7DAg9E=
Date: Mon, 23 Nov 2009 13:17:44 +0200
From: Dan Carpenter <error27@gmail.com>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 5/17] [LogFS] dir.c
Message-ID: <20091123111744.GA17527@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <20091120181113.GA2159@logfs.org> <E1NBZIP-0003g2-0r@longford.logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NBZIP-0003g2-0r@longford.logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:37:29PM +0100, Joern Engel wrote:
> +static int logfs_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	struct logfs_super *super = logfs_super(dir->i_sb);
> +	struct inode *inode = dentry->d_inode;
> +	struct logfs_transaction *ta;
> +	struct page *page;
> +	pgoff_t index;
> +	int ret;
> +
> +	ta = kzalloc(sizeof(*ta), GFP_KERNEL);
> +	if (!ta)
> +		return -ENOMEM;
> +
> +	ta->state = UNLINK_1;
> +	ta->ino = inode->i_ino;
> +
> +	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +
> +	page = logfs_get_dd_page(dir, dentry);
> +	if (!page)

kfree(ta);

> +		return -ENOENT;
> +	if (IS_ERR(page))

kfree(ta);

> +		return PTR_ERR(page);

regards,
dan carpenter
