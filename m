Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZKICNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZKICNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZKICNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:13:11 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:54085 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZKICNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:13:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HqwbMr6urUIJibBj6feTi2Pu8gsffbX0LGwknPxvVnCJoE/amPBnB2C9NBdA0Tooie
         X/SQRUa+pxYzXDNum+YH+OQA7P9IJQa7U9379gIBdwl0Xeq6npt7NTY23d6X8HJbDWwq
         n6c1i3XoUa3aPLUZ9qRlo/u7cAYt8kMQMycug=
Date: Mon, 9 Nov 2009 10:13:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 07/16] um: Replace old style lock initializer
Message-ID: <20091109021331.GA2399@hack>
References: <20091106223547.784916750@linutronix.de> <20091106223806.682280699@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106223806.682280699@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 10:41:33PM -0000, Thomas Gleixner wrote:
>SPIN_LOCK_UNLOCKED is deprecated since quite a while. Runtime init the
>locks instead.
>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Cc: Jeff Dike <jdike@addtoit.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

>---
> arch/um/drivers/ubd_kern.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Index: linux-2.6/arch/um/drivers/ubd_kern.c
>===================================================================
>--- linux-2.6.orig/arch/um/drivers/ubd_kern.c
>+++ linux-2.6/arch/um/drivers/ubd_kern.c
>@@ -180,7 +180,6 @@ struct ubd {
> 	.no_cow =               0, \
> 	.shared =		0, \
> 	.cow =			DEFAULT_COW, \
>-	.lock =			SPIN_LOCK_UNLOCKED,	\
> 	.request =		NULL, \
> 	.start_sg =		0, \
> 	.end_sg =		0, \
>@@ -838,6 +837,7 @@ static int ubd_add(int n, char **error_o
> 
> 	ubd_dev->size = ROUND_BLOCK(ubd_dev->size);
> 
>+	spin_lock_init(&ubd_dev->lock);
> 	INIT_LIST_HEAD(&ubd_dev->restart);
> 	sg_init_table(ubd_dev->sg, MAX_SG);
> 
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
