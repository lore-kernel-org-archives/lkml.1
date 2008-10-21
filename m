Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYJUVt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYJUVt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYJUVtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:49:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:50995 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbYJUVtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:49:21 -0400
Message-ID: <48FE4E55.90601@windriver.com>
Date: Tue, 21 Oct 2008 16:49:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: kgdb-bugreport@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 5/7] kgdboc, tty: use tty open to start low level drivers
References: <1224616493-23237-6-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1224616493-23237-6-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2008 21:49:09.0241 (UTC) FILETIME=[D8E83E90:01C933C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> A few minor changes were needed in tty_io.c to deal with the fact that
> the inode and fpath.dentry were NULL with the generic flip structure.
>   

After further testing and review one patch hunk has been eliminated.

> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  drivers/char/tty_io.c      |   96 +++++++++++++++++++++++++++++++++++++++++---
>  drivers/serial/kgdboc.c    |   26 ++++++++----
>  include/linux/tty_driver.h |    5 ++
>  3 files changed, 113 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index fa44e6b..fe500ec 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -1723,7 +1806,7 @@ void tty_release_dev(struct file *filp)
>  	release_tty(tty, idx);
>  
>  	/* Make this pty number available for reallocation */
> -	if (devpts)
> +	if (devpts && inode)
>  		devpts_kill_index(inode, idx);
>  }
>   

Specifically the call to devpts_kill_index() should get executed
and the above patch hunk has been removed.

Thanks,
Jason.
