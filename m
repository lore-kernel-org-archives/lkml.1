Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbYDOWCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbYDOWCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbYDOWCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:02:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbYDOWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:02:31 -0400
Date: Tue, 15 Apr 2008 15:01:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] tty: fix routine name in ptmx_open()
Message-Id: <20080415150143.e19bb518.akpm@linux-foundation.org>
In-Reply-To: <4803FD15.6030006@ct.jp.nec.com>
References: <4803FD15.6030006@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 17:55:49 -0700
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> At ptmx_open(), the 2nd parameter for check_tty_count() should
> be "ptmx_open".
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  drivers/char/tty_io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index 613ec81..546217d 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -2774,7 +2774,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
>  	if (devpts_pty_new(tty->link))
>  		goto out1;
>  
> -	check_tty_count(tty, "tty_open");
> +	check_tty_count(tty, "ptmx_open");
>  	retval = ptm_driver->open(tty, filp);
>  	if (!retval) {
>  		tty_audit_opening();

Of course, using __func__ prevents this sort of bitrot.

Or even #define check_tty_count(tty) __check_tty_count(tty, __func__)


