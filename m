Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbZLRGKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbZLRGKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 01:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZLRGKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 01:10:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZLRGKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 01:10:53 -0500
Date: Fri, 18 Dec 2009 06:10:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] anonfd: Make file read-only if fops->write is not set
Message-ID: <20091218061049.GI18217@ZenIV.linux.org.uk>
References: <adaws0k3kd8.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaws0k3kd8.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:46:11PM -0800, Roland Dreier wrote:
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index 2c99459..097f91f 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -121,13 +121,13 @@ struct file *anon_inode_getfile(const char *name,
>  	d_instantiate(path.dentry, anon_inode_inode);
>  
>  	error = -ENFILE;
> -	file = alloc_file(&path, FMODE_READ | FMODE_WRITE, fops);
> +	file = alloc_file(&path, FMODE_READ | (fops->write ? FMODE_WRITE : 0), fops);

Good grief, what for?  We are already passing O_NDELAY in flags argument,
why not add O_RDWR/O_RDONLY to it?  It's not as if we had that many
callers, after all...
