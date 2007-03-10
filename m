Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXCJW2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXCJW2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXCJW2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:28:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48022 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751216AbXCJW2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:28:41 -0500
Date: Sat, 10 Mar 2007 23:28:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Johnson <ajohnson@intrinsyc.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Message-ID: <20070310222832.GF2674@elf.ucw.cz>
References: <1173394485.28589.17.camel@localhost.localdomain> <20070309090805.GA5822@atrey.karlin.mff.cuni.cz> <20070309153456.GA28664@srcf.ucam.org> <1173466942.29923.6.camel@localhost.localdomain> <20070309211910.GD6374@ucw.cz> <1173485142.30345.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173485142.30345.18.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi1

> > It should explain why it is okay to proceed when we can't change to
> > text console.
> > 
> See updated comment in attached patch.  It's really up to the caller to
> decide what to do if we can't switch the console - currently all callers
> ignore the return code so I assume that it's okay to proceed anyway.

Ok, I guess the patch is right thing to do after all.  Fix issues
below, append a changelog, and send a patch to lmkl, cc Andrew Morton
and me. Oh and you have my ACK.
								Pavel

> Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
> ---
> diff -rup linux-2.6.20.1/drivers/char/vt.c linux/drivers/char/vt.c
> --- linux-2.6.20.1/drivers/char/vt.c	2007-02-19 22:34:32.000000000 -0800
> +++ linux/drivers/char/vt.c	2007-03-09 15:48:29.000000000 -0800
> @@ -2188,10 +2188,30 @@ static void console_callback(struct work
>  	release_console_sem();
>  }
>  
> -void set_console(int nr)
> +extern char vt_dont_switch;
> +
> +int set_console(int nr)
>  {
> +	struct vc_data *vc = vc_cons[fg_console].d;
> +
> +	if(!vc_cons_allocated(nr) || vt_dont_switch || 

there should be space between "if" and "(".

> diff -rup linux-2.6.20.1/drivers/char/vt_ioctl.c
> linux/drivers/char/vt_ioctl.c
> --- linux-2.6.20.1/drivers/char/vt_ioctl.c	2007-02-19 22:34:32.000000000
> -0800
> +++ linux/drivers/char/vt_ioctl.c	2007-03-08 14:15:41.000000000

And your mailer still wordwraps.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
