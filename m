Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYBHV51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYBHV51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYBHV5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:57:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39876 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754621AbYBHV5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:57:15 -0500
Date: Fri, 8 Feb 2008 21:50:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] tty: BKL pushdown fix1
Message-ID: <20080208215017.332c3480@core>
In-Reply-To: <1202506856-3403-1-git-send-email-jirislaby@gmail.com>
References: <47ACCBD4.1000502@gmail.com>
	<1202506856-3403-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Feb 2008 22:40:56 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  fs/compat_ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index c6e72ae..9663e87 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1046,7 +1046,7 @@ static int vt_check(struct file *file)
>  	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct vc_data *vc;
>  	
> -	if (file->f_op->ioctl != tty_ioctl)
> +	if (file->f_op->unlocked_ioctl != tty_ioctl)
>  		return -EINVAL;

Acked-by: Alan Cox <alan@redhat.com>

Nice catch
