Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZDAPsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZDAPsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZDAPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:48:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:46006 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZDAPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jth8CczVjOE81nnJHKZa2SWc+NckSuQRWxFFAoq+XSTPHMbVPOI9RZaXAW1TztRRVb
         kqlr98mD4iAchZ1xGAZlUgb/eYM+BVmq0iWRCTCp2YQQ3XHRmhVAnz7Ho+UmsGrJNy4o
         jyWzRw48NQ2Ia/Ge2dKL0tWtw+SQx/TZ9QDAY=
Date: Wed, 1 Apr 2009 23:49:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] uml: fix compile error from net_device_ops
	conversion
Message-ID: <20090401154924.GD3848@hack>
References: <E1LoMQ2-0007bB-By@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LoMQ2-0007bB-By@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 08:41:10PM +0200, Miklos Szeredi wrote:
>From: Miklos Szeredi <mszeredi@suse.cz>
>
>Fix the following compile error:
>
>arch/um/drivers/net_kern.c: In function 'uml_inetaddr_event':
>arch/um/drivers/net_kern.c:760: error: 'struct net_device' has no member named 'open'
>
>This was introduced by commit 8bb95b39, "uml: convert network device
>to netdevice ops".
>
>Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>


Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

>---
> arch/um/drivers/net_kern.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Index: linux-2.6/arch/um/drivers/net_kern.c
>===================================================================
>--- linux-2.6.orig/arch/um/drivers/net_kern.c	2009-03-30 17:07:10.000000000 +0200
>+++ linux-2.6/arch/um/drivers/net_kern.c	2009-03-30 19:25:30.000000000 +0200
>@@ -757,7 +757,7 @@ static int uml_inetaddr_event(struct not
> 	void (*proc)(unsigned char *, unsigned char *, void *);
> 	unsigned char addr_buf[4], netmask_buf[4];
> 
>-	if (dev->open != uml_net_open)
>+	if (dev->netdev_ops->ndo_open != uml_net_open)
> 		return NOTIFY_DONE;
> 
> 	lp = netdev_priv(dev);
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Do what you love, f**k the rest! F**k the regulations!
 
