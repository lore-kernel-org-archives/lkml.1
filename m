Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYFTVFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYFTVFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYFTVFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:05:37 -0400
Received: from vena.lwn.net ([206.168.112.25]:36136 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbYFTVFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:05:37 -0400
Date: Fri, 20 Jun 2008 15:05:35 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH, RFC] fasync() BKL pushdown
Message-ID: <20080620150535.5efc2ec0@bike.lwn.net>
In-Reply-To: <20080620135840.562dd4a5@infradead.org>
References: <20080620112914.783be428@bike.lwn.net>
	<20080620135840.562dd4a5@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 13:58:40 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> only question is if this one is really needed:
> +	lock_kernel();
>  	tty = (struct tty_struct *)filp->private_data;
>  	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode,
> "tty_fasync"))
> -		return 0;
> +		goto out;
>  
>  	retval = fasync_helper(fd, filp, on, &tty->fasync);
>  	if (retval <= 0)
> 
> (given that it just calls the helper.. mostly and that Alan has been
> busy removing the BKL from the tty layer)

There's enough other stuff going on there, including manipulations of
the tty_struct, waitqueue_active() checks, etc., that I figured I should
really leave the BKL in there and let Alan figure it out.  I've learned
that it's best to tread with great care in that part of the kernel...

jon


Jonathan Corbet / LWN.net / corbet@lwn.net
