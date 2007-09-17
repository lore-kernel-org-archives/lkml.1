Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbXIQOvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbXIQOvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXIQOvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:51:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:15688 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbXIQOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uNB5XpHOALqTKlNq41beT+wBpPipX9xPzbuj47aIVoCVwAzHxURfhntoT21+vZlxEx5Jw7Kxtz3mfNLhGyiwdi6d1QOWAg3UlEqpstvdbL9lQNipzVtKXwYB1dt+kH6h6A8984WEuD4eFRI7HmHG7ioOzFG+K1kDXgTEb1Z0Foo=
Message-ID: <a4e6962a0709170751u35944261h3148399c39fdfa8a@mail.gmail.com>
Date: Mon, 17 Sep 2007 09:51:31 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH 3/5][9PFS] Cleanup explicit check for mandatory locks
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       devel@openvz.org, "Ron Minnich" <rminnich@sandia.gov>,
       "Latchesar Ionkov" <lucho@ionkov.net>
In-Reply-To: <46EE328E.5050205@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EE328E.5050205@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Pavel Emelyanov <xemul@openvz.org> wrote:
> The __mandatory_lock(inode) macro makes the same check, but
> makes the code more readable.
>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Acked-by: Eric Van Hensbergen <ericvh@gmail.com>
>
> ---
>
>  fs/9p/vfs_file.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 2a40c29..7166916 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -105,7 +105,7 @@ static int v9fs_file_lock(struct file *f
>         P9_DPRINTK(P9_DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);
>
>         /* No mandatory locks */
> -       if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
> +       if (__mandatory_lock(inode))
>                 return -ENOLCK;
>
>         if ((IS_SETLK(cmd) || IS_SETLKW(cmd)) && fl->fl_type != F_UNLCK) {
>
>
