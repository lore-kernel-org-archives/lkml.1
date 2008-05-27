Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYE0ToX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYE0ToX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYE0ToQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:44:16 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:38249 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbYE0ToP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:44:15 -0400
Date: Tue, 27 May 2008 15:43:57 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Char: vt, make sysfs operations atomic
Message-ID: <20080527194357.GA12185@cathedrallabs.org>
References: <1211802812-13658-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211802812-13658-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hold console sem while creating/destroying sysfs files. Serialisation is
> so far done by BKL held in tty release_dev and chrdev_open, but no other
> locks are held in open path.
> 
>  				tty->termios->c_iflag |= IUTF8;
>  			else
>  				tty->termios->c_iflag &= ~IUTF8;
> -			release_console_sem();
>  			vcs_make_sysfs(tty);
> +			release_console_sem();
>  			return ret;
>  		}
>  	}
> @@ -2772,8 +2772,8 @@ static void con_close(struct tty_struct *tty, struct file *filp)
>  		if (vc)
>  			vc->vc_tty = NULL;
>  		tty->driver_data = NULL;
> -		release_console_sem();
>  		vcs_remove_sysfs(tty);
> +		release_console_sem();
>  		mutex_unlock(&tty_mutex);
>  		/*
>  		 * tty_mutex is released, but we still hold BKL, so there is
the reason for the code be the way it is is because vcs_{add,remove}_sysfs()
may sleep

-- 
Aristeu

