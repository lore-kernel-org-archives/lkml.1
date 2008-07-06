Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYGFAMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYGFAMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 20:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYGFAM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 20:12:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:52371 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbYGFAM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 20:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C8fgG3SO57gmzgc+3y+eh+HTtrusy/3HJNdRHLXDQkM9UoTAZ5qm4APjjcdXaijny1
         uB0BAGPL3lpF9fuHsqTkL/yHFfsDqXaejnWy4U0Neq+8/BkIfpNwTHs6b4EGrulGZaC2
         LdmQLPSWr4/wGTRZfDmz1foskw09Wq5vhTQPc=
Message-ID: <ca2dc2820807051712w3aaa876bn230269369424af1f@mail.gmail.com>
Date: Sun, 6 Jul 2008 02:12:27 +0200
From: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH] auxdisplay: small cleanups
Cc: linux-kernel@vger.kernel.org,
       "Miguel Ojeda Sandonis" <maxextreme@gmail.com>
In-Reply-To: <20080705112116.GC17071@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705112116.GC17071@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 1:21 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> - Use BUILD_BUG_ON for CFAG12864B_SIZE instead of runtime-check
>
> - Use get_zeroed_page()

Thank you very much! I will test it soon (~10th of July). In the meantime:

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>

>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Miguel Ojeda Sandonis <maxextreme@gmail.com>
> ---
>  drivers/auxdisplay/cfag12864b.c |   13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>
> Index: 2.6-git/drivers/auxdisplay/cfag12864b.c
> ===================================================================
> --- 2.6-git.orig/drivers/auxdisplay/cfag12864b.c
> +++ 2.6-git/drivers/auxdisplay/cfag12864b.c
> @@ -336,16 +336,9 @@ static int __init cfag12864b_init(void)
>                        "ks0108 is not initialized\n");
>                goto none;
>        }
> +       BUILD_BUG_ON(PAGE_SIZE < CFAG12864B_SIZE);
>
> -       if (PAGE_SIZE < CFAG12864B_SIZE) {
> -               printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
> -                       "page size (%i) < cfag12864b size (%i)\n",
> -                       (unsigned int)PAGE_SIZE, CFAG12864B_SIZE);
> -               ret = -ENOMEM;
> -               goto none;
> -       }
> -
> -       cfag12864b_buffer = (unsigned char *) __get_free_page(GFP_KERNEL);
> +       cfag12864b_buffer = (unsigned char *) get_zeroed_page(GFP_KERNEL);
>        if (cfag12864b_buffer == NULL) {
>                printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
>                        "can't get a free page\n");
> @@ -367,8 +360,6 @@ static int __init cfag12864b_init(void)
>        if (cfag12864b_workqueue == NULL)
>                goto cachealloced;
>
> -       memset(cfag12864b_buffer, 0, CFAG12864B_SIZE);
> -
>        cfag12864b_clear();
>        cfag12864b_on();
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
