Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbXJNJae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbXJNJae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 05:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXJNJaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 05:30:25 -0400
Received: from smtp23.orange.fr ([193.252.22.30]:16004 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbXJNJaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 05:30:24 -0400
X-ME-UUID: 20071013010326893.DA0161C0008F@mwinf2301.orange.fr
Date: Sat, 13 Oct 2007 04:03:26 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>
Cc: irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [irda-users] [PATCH] irlmp_unregister_link needs to free lsaps
	hashbin
Message-ID: <20071013010326.GC8187@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <470F6EFB.6010704@cetrtapot.si>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470F6EFB.6010704@cetrtapot.si>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hinko,

On Fri, Oct 12, 2007 at 02:56:27PM +0200, hinko.kocevar@cetrtapot.si wrote:
> Hi,
> 
> While testing the mcs7780 based IrDA USB dongle I've stumbled upon
> memory leak in irlmp_unregister_link(). Hashbin for lsaps is created in
> irlmp_register_link and should probably be freed in irlmp_unregister_link().
> 
> Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
> 
> Best regards,
> Hinko
> 
> ----
> 
> 

> --- linux-2.6.23/net/irda/irlmp.c.orig	2007-10-12 14:05:17.000000000 +0200
> +++ linux-2.6.23/net/irda/irlmp.c	2007-10-12 14:05:41.000000000 +0200
> @@ -353,6 +353,7 @@ void irlmp_unregister_link(__u32 saddr)
>  		/* Final cleanup */
>  		del_timer(&link->idle_timer);
>  		link->magic = 0;
> +		hashbin_delete(link->lsaps, (FREE_FUNC) kfree);
Good catch, but I think the right fix sould be:
+             hashbin_delete(link->lsaps, (FREE_FUNC) __irlmp_close_lsap);

and I'll forward it. Thanks a lot.

Cheers,
Samuel.


>  		kfree(link);
>  	}
>  }

> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> irda-users mailing list
> irda-users@lists.sourceforge.net
> http://lists.sourceforge.net/lists/listinfo/irda-users


