Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXHAWTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXHAWTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXHAWTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:19:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbXHAWTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:19:11 -0400
Date: Wed, 1 Aug 2007 15:19:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Benkstein <frank@benkstein.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: VT_PROCESS, VT_LOCKSWITCH capabilities
Message-Id: <20070801151900.f80722b6.akpm@linux-foundation.org>
In-Reply-To: <46AFF390.10103@benkstein.net>
References: <46AFB62E.2080303@benkstein.net>
	<46AFF390.10103@benkstein.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 04:44:32 +0200
Frank Benkstein <frank@benkstein.net> wrote:

> Frank Benkstein wrote:
> > I wonder why there are different permissions needed for VT_PROCESS
> > (access to the current virtual console) and VT_LOCKSWITCH
> > (CAP_SYS_TTY_CONFIG).
> 
> To be more direct:
> 
> require CAP_SYS_TTY_CONFIG for VT_SETMODE as its essentially the same as
> VT_LOCKSWITCH and said capability is already required there
> 
> diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
> index c6f6f42..7034a68 100644
> --- a/drivers/char/vt_ioctl.c
> +++ b/drivers/char/vt_ioctl.c
> @@ -662,7 +662,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
>         {
>                 struct vt_mode tmp;
> 
> -               if (!perm)
> +               if (!perm || !capable(CAP_SYS_TTY_CONFIG))
>                         return -EPERM;
>                 if (copy_from_user(&tmp, up, sizeof(struct vt_mode)))
>                         return -EFAULT;
> 

There's a good risk of breaking stuff with this change.  A quick peek
through http://www.google.com/codesearch shows that.

We need good reasons for making that change, and for handling the
subsequent fallout, getting shouted at by aggrieved users, etc.

It's tricky.
