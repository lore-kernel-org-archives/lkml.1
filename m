Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYIOIG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYIOIG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYIOIGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:06:00 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:33774 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916AbYIOIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:05:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQFAN+yzUhR9cv+/2dsb2JhbACBYrILgWQ
Date: Mon, 15 Sep 2008 10:05:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wdt285: fix sparse warnings
Message-ID: <20080915080556.GB2654@infomag.infomag.iguana.be>
References: <20080914213409.767536728@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914213409.767536728@fluff.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

...
> @@ -141,13 +141,13 @@ static long watchdog_ioctl(struct file *
>  	switch (cmd) {
>  	case WDIOC_GETSUPPORT:
>  		ret = 0;
> -		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
> +		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
>  			ret = -EFAULT;
>  		break;
>  
...

Isn't it better to fix this like we did with the other watchdog drivers:
        void __user *argp = (void __user *)arg;
        int __user *p = argp;
	...
		if (copy_to_user(argp, &ident, sizeof(ident)))
	...

Regards,
Wim.

