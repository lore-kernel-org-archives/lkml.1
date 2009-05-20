Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZETFRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZETFRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZETFRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:17:03 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:49757 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZETFRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NW+XPXGpoWYy/XDnZL/K7sEgt5y2nshS8mpm9w/fl4kh0bq7Pv/HZ9iYT0c9vEHRoY
         K4LbdU+evdXuQMBZix3bPIEkJzVxWmDFzpBh3yEe8ps8T51oZhD4Tl0KT7l9xoQYpZf+
         tmNHbXKvbdIjTbdge7bxJFn3MPENZXkBTiRDI=
MIME-Version: 1.0
In-Reply-To: <af3ea28a0905170804n500126e4tc425dafd9fcaa68a@mail.gmail.com>
References: <af3ea28a0905170804n500126e4tc425dafd9fcaa68a@mail.gmail.com>
Date: Wed, 20 May 2009 13:17:03 +0800
Message-ID: <af3ea28a0905192217x2006dbe4gb456217d110b916f@mail.gmail.com>
Subject: Re: fix rtc_cmos bug
From: ye janboe <janboe.ye@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: rjw@sisk.pl, bunk@kernel.org, bugme-janitors@lists.osdl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

my fix is wrong?

Why no one ack this patch?

Thanks

Janboe

2009/5/17 ye janboe <janboe.ye@gmail.com>:
>    fix  Bug 13326 -  Null pointer dereference in rtc-cmos driver
>    http://bugzilla.kernel.org/show_bug.cgi?id=13326
>
>    Signed-off-by: janboe <janboe.ye@gmail.com>
>
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 23e10b6..da132f6 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -1179,7 +1179,9 @@ static int __init cmos_init(void)
>        int retval = 0;
>
>  #ifdef CONFIG_PNP
> -       pnp_register_driver(&cmos_pnp_driver);
> +       retval = pnp_register_driver(&cmos_pnp_driver);
> +       if (retval)
> +               return retval;
>  #endif
>
>        if (!cmos_rtc.dev)
>
