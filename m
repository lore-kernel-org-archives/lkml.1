Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYIPKcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYIPKcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 06:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYIPKcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 06:32:06 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58061 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752175AbYIPKcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 06:32:05 -0400
Date: Tue, 16 Sep 2008 11:31:57 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: wdt285: fix sparse warnings
Message-ID: <20080916103157.GG1916@fluff.org.uk>
References: <20080914213409.767536728@fluff.org.uk> <20080915080556.GB2654@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915080556.GB2654@infomag.infomag.iguana.be>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 10:05:56AM +0200, Wim Van Sebroeck wrote:
> Ben,
> 
> ...
> > @@ -141,13 +141,13 @@ static long watchdog_ioctl(struct file *
> >  	switch (cmd) {
> >  	case WDIOC_GETSUPPORT:
> >  		ret = 0;
> > -		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
> > +		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
> >  			ret = -EFAULT;
> >  		break;
> >  
> ...
> 
> Isn't it better to fix this like we did with the other watchdog drivers:
>         void __user *argp = (void __user *)arg;
>         int __user *p = argp;

I've changed the int pointer, as it is used numerous times, but left
the void as it is only used in the copy_to_user.
 	...
> 		if (copy_to_user(argp, &ident, sizeof(ident)))
> 	...
> 
> Regards,
> Wim.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
