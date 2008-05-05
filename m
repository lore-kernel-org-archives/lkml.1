Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYEELBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYEELBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbYEELAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:00:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747AbYEELAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:00:40 -0400
Date: Mon, 5 May 2008 07:00:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Paul Menage <menage@google.com>
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
Message-ID: <20080505110016.GC20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095511.217634550@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095511.217634550@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:44AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> cgroup_clone() calls vfs_mkdir() to create a directory in the cgroup
> filesystem.  Replace with explicit call to cgroup_mkdir() and
> fsnotify_mkdir().
> 
> This is equivalent, except that the following functions are not called
> before cgroup_mkdir():
> 
>  - may_create()
>  - security_inode_mkdir()
>  - DQUOT_INIT()
> 
> Permission to clone the cgroup has already been checked in
> copy_namespaces() (requiring CAP_SYS_ADMIN).  Additional file system
> related capability checks are inappropriate and confusing.
> 
> The quota check is unnecessary, as quotas don't make any sense for
> this filesystem.

Looks correct but I don't think it's a good idea.  Spreading more logic
into filesystems without a good reason is rarely a good idea.

