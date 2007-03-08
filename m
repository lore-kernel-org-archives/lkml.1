Return-Path: <linux-kernel-owner+w=401wt.eu-S1750696AbXCHKVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750696AbXCHKVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 05:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbXCHKVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 05:21:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39971 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXCHKVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 05:21:18 -0500
Date: Thu, 8 Mar 2007 10:21:05 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070308102105.GA21119@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Davide Libenzi <davidel@xmailserver.org>,
	Avi Kivity <avi@argo.co.il>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <45ED1A3C.6030707@argo.co.il> <200703071831.36930.dada1@cosmosbay.com> <20070308085631.GA7373@infradead.org> <200703081042.21454.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703081042.21454.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 10:42:21AM +0100, Eric Dumazet wrote:
> @@ -1823,6 +1823,9 @@ char * d_path(struct dentry *dentry, str
>  	struct vfsmount *rootmnt;
>  	struct dentry *root;
>  
> +	if (dentry->d_op && dentry->d_op->d_dname)
> +		return (dentry->d_op->d_dname)(dentry, buf, buflen);

Please don't put braces around the function pointer call.  Also I
think we really want a comment here why we need this call.

> +static char * pipefs_dname(struct dentry *dentry, char *buffer, int buflen)

normally this would be:

	
static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)

> +static char * sockfs_dname(struct dentry *dentry, char *buffer, int buflen)

same here.

> -	char name[32];
>  
> -	this.len = sprintf(name, "[%lu]", SOCK_INODE(sock)->i_ino);
> -	this.name = name;
> +	this.len = 0;
> +	this.name = "";
>  	this.hash = 0;

Can you add a helper to init this one?

