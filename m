Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYEERW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYEERW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYEERWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:22:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7163 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYEERWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:22:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=AadL3LWr0xGgahPSkQd2bdRZYTue6UeqIftWWjLxTDELoBuHrD4nU5Rdc4fprn+PM
	WVJ2G2RUNrn9zV3Oz06/w==
Message-ID: <6599ad830805051022g24a07324g395b39b003751791@mail.gmail.com>
Date: Mon, 5 May 2008 10:22:37 -0700
From: "Paul Menage" <menage@google.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080505095511.217634550@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505095440.820370974@szeredi.hu>
	 <20080505095511.217634550@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 2:54 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
>  cgroup_clone() calls vfs_mkdir() to create a directory in the cgroup
>  filesystem.  Replace with explicit call to cgroup_mkdir() and
>  fsnotify_mkdir().
>
>  This is equivalent, except that the following functions are not called
>  before cgroup_mkdir():
>
>   - may_create()
>   - security_inode_mkdir()
>   - DQUOT_INIT()
>
>  Permission to clone the cgroup has already been checked in
>  copy_namespaces() (requiring CAP_SYS_ADMIN).  Additional file system
>  related capability checks are inappropriate and confusing.
>
>  The quota check is unnecessary, as quotas don't make any sense for
>  this filesystem.
>
>  Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>  CC: Paul Menage <menage@google.com>

This looks like it behaves correctly, but I don't really have any view
on whether the change is the right thing to do - I'll leave that to
the VFS gurus. FWIW, I'd regard cgroup_clone() as being outside the
filesystem rather than inside. It does have some knowledge of the
cgroupfs internals, but it tries to leave as much as possible up to
the real filesystem code.

Paul
