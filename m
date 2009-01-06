Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZAFXcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZAFXcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbZAFXb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:31:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZAFXbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:31:55 -0500
Date: Tue, 6 Jan 2009 18:31:53 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Diego E. 'Flameeyes' Petten?" <flameeyes@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Warren Turkal <wt@penguintechs.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106233153.GA16469@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151747.c640dfd4.akpm@linux-foundation.org> <20090106231958.GA30271@infradead.org> <1231284433.5158.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231284433.5158.2.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the version you attached looks much better, and correct.

Just some minor comments:

> +++ b/fs/hfsplus/export.c
> @@ -0,0 +1,118 @@
> +/*
> + *  linux/fs/hfsplus/export.c
> + *

Please don't put filenames in top of file comments.  They don't serve
any purpose and easily get out of date.

> +	if ( be16_to_cpu(entry.type) != HFSPLUS_FOLDER_THREAD) {

no space after the opening brace, please/

> +	inode = hfsplus_iget(child->d_sb, be32_to_cpu(entry.thread.parentID));
> +	if (IS_ERR(inode)) {
> +		printk(KERN_ERR "hfs: unable to find parent, call the social services\n");
> +		return ERR_CAST(inode);
> +	}

no lines longer than 80 characters please.

> +	inode = hfsplus_iget(sb, ino);
> +	if (IS_ERR(inode))
> +		return ERR_CAST(inode);
> +
> +	/* probably superfluous but it does not seem to hurt */
> +	if (generation && inode->i_generation != generation) {
> +		/* we didn't find the right inode.. */
> +		iput(inode);
> +		return ERR_PTR(-ESTALE);
> +	}
> +	return inode;

Given that hfsplus never sets i_generation it's superflous.  So just
write the above as

	return hfsplus_iget(sb, ino);

And maybe write a little comment that there is no generation number
in hfsplus.

> +/* Yes, most of these are left as NULL!!
> + * A NULL value implies the default, which works with hfs+-like file
> + * systems, but can be improved upon.
> + */

No need for this comment I think.  All this is pretty well documented
in Documentation/filesystems/Exporting, and all the other filesystems
that just fill out these three methods don't comment on it either.

