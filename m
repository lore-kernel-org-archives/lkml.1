Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZDRDMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZDRDMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 23:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZDRDMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 23:12:12 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:65010 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZDRDMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 23:12:12 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] Fix i_mutex handling in nfsd readdir. 
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, bfields@citi.umich.edu,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1240013753.21423.86.camel@macbook.infradead.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org>
Date: Sat, 18 Apr 2009 12:11:54 +0900
Message-ID: <905.1240024314@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Woodhouse:
> This patch fixes it by locking the directory's i_mutex again before
> calling the filldir functions. The original deadlocks which commit
> 14f7dd63 was designed to avoid are still avoided, because they were due
> to fs-internal locking, not i_mutex.
	:::
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1248,6 +1248,8 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
>  	int err;
>  	struct qstr this;
>  
> +	WARN_ON_ONCE(!mutex_is_locked(&base->d_inode->i_mutex));
> +
>  	err = __lookup_one_len(name, &this, base, len);

I'd suggest this checking is done only when CONFIG_DEBUG_KERNEL (or
something) is enabled. Because unconditional checking costs high for the
well-reviewed lookup code.


J. R. Okajima
