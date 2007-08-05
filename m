Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXHEOAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXHEOAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbXHEOAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:00:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:3722 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXHEOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oGCkvb8HwdK7QFlOEexCMsFs3UWEQvsTJ6Vob/heNfDrejs3cxTK+gJrc+BjPJlHmqeQZFlmeQEivRimfQ5naBsH1b/IufbT+JFYCsBe9SUnvp5lq++x5Mj2bcyTXj9whn9sdQasfISP2SZEWcxaK1SYb4WENn+70XtyuRR/1R4=
Message-ID: <3ae72650708050700p1fc2959epcc1e9307e3c64fed@mail.gmail.com>
Date: Sun, 5 Aug 2007 16:00:08 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Alexey Dobriyan" <adobriyan@gmail.com>, "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] Off-by-one in /sys/module/*/refcnt
Cc: akpm@osdl.org, gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20070805134923.GA5918@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070805134923.GA5918@martell.zuzino.mipt.ru>
X-Google-Sender-Auth: 1e2118e89996e5ee
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Hell knows when this changed, but sysfs is lying about modules refcounts now.
>
> $ cat /sys/module/it87/refcnt
> 4294967295
> $ lsmod | grep ^it87
> it87                   15756  0
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>
>  kernel/module.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -785,7 +785,7 @@ static ssize_t show_refcnt(struct module_attribute *mattr,
>                            struct module *mod, char *buffer)
>  {
>         /* sysfs holds a reference */
> -       return sprintf(buffer, "%u\n", module_refcount(mod)-1);
> +       return sprintf(buffer, "%u\n", module_refcount(mod));
>  }

It's likely caused by sysfs core changes, that opened attributes are
no longer coupled to the refcount of modules. They used to take a
reference.

The "holds a reference" comment should be removed along with your fix.
Adding Tejun, to confirm this.

Thanks,
Kay
