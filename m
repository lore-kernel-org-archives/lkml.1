Return-Path: <linux-kernel-owner+w=401wt.eu-S933445AbYDQPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445AbYDQPiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbYDQPhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:37:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57227 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760374AbYDQPhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:37:52 -0400
Date: Thu, 17 Apr 2008 10:37:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Propagate error code from devpts_pty_new
Message-ID: <20080417153748.GB14215@sergelap.austin.ibm.com>
References: <20080416221524.GA7112@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416221524.GA7112@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting sukadev@us.ibm.com (sukadev@us.ibm.com):
> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Subject: [PATCH]: Propagate error code from devpts_pty_new
> 
> Have ptmx_open() propagate any error code returned by devpts_pty_new()
> (which returns either 0 or -ENOMEM anyway).
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Seems nice and non-contentuous.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  drivers/char/tty_io.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: 2.6.25-rc8-mm2/drivers/char/tty_io.c
> ===================================================================
> --- 2.6.25-rc8-mm2.orig/drivers/char/tty_io.c	2008-04-16 09:38:23.000000000 -0700
> +++ 2.6.25-rc8-mm2/drivers/char/tty_io.c	2008-04-16 09:51:11.000000000 -0700
> @@ -2835,8 +2835,8 @@ static int ptmx_open(struct inode *inode
>  	filp->private_data = tty;
>  	file_move(filp, &tty->tty_files);
> 
> -	retval = -ENOMEM;
> -	if (devpts_pty_new(tty->link))
> +	retval = devpts_pty_new(tty->link);
> +	if (retval)
>  		goto out1;
> 
>  	check_tty_count(tty, "tty_open");
