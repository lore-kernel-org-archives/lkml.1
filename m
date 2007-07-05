Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbXGEAAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbXGEAAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXGEAAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:00:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:42179 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXGEAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZDA12Nc0sI9EF3V3uIsOaLm87P4vwG5S8I+Brbe0JQv1fQgch1BYxvFdSbo3/E+dM0snF5saLesYXH2ww8NvSn2o7nykZqRwCA5j68ISad5jeofGq7pTD/Sr3fVkxvG5RC5lZQydE1ZQGDCSdWhfVZUW6eBYS+K3n9p0Yd3AbVA=
Message-ID: <9a8748490707041700q18608e3ave4465f1181b97e2f@mail.gmail.com>
Date: Thu, 5 Jul 2007 02:00:07 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "WANG Cong" <xiyou.wangcong@gmail.com>
Subject: Re: [-mm Patch] INFINIBAND: check the return value of kmalloc
Cc: rolandd@cisco.com, mshefty@ichips.intel.com, halr@voltaire.com,
       "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070704163741.GA2510@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070704163741.GA2510@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/07, WANG Cong <xiyou.wangcong@gmail.com> wrote:
>
> Don't forget to check the return value of kmalloc().
>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> ---
>
> Index: linux-2.6.22-rc6-mm1/drivers/infiniband/hw/cxgb3/iwch_provider.c
> ===================================================================
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c       2007-06-29 13:18:20.000000000 +0800
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c       2007-07-04 23:17:02.000000000 +0800
> @@ -1166,6 +1166,10 @@
>         dev->ibdev.iwcm =
>             (struct iw_cm_verbs *) kmalloc(sizeof(struct iw_cm_verbs),

While you are here anyway, why not get rid of that pointless kmalloc()
return value cast at the same time?

>                                            GFP_KERNEL);
> +       if (!dev->ibdev.iwcm) {
> +               ret = -1;
> +               goto bail1;
> +       }
>         dev->ibdev.iwcm->connect = iwch_connect;
>         dev->ibdev.iwcm->accept = iwch_accept_cr;
>         dev->ibdev.iwcm->reject = iwch_reject_cr;


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
