Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXJAQmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXJAQmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXJAQma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:42:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:21854 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbXJAQm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YmMrThPloUKuB0BvnGQ3OCOHQVGmcKQwhAJCZKRNYdk9UuV89mpv8LMbEVqNm9sdUBkUqTcU7v1PrxVSVZp1BXPTC1H2NT1kXr7P2Nk+07oq1Ra5S6CJYPUilBgdwcc5TdDtc15MqU+qe4rkbCCzGlxvt/XZ7QlOWto8PIy5FQc=
Message-ID: <961aa3350710010942y42aef8eax6fb54354184b4cc1@mail.gmail.com>
Date: Tue, 2 Oct 2007 01:42:27 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 6/6] Xilinxfb: add of_platform bus binding
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
In-Reply-To: <20071001155759.6114.29143.stgit@trillian.cg.shawcable.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
	 <20071001155759.6114.29143.stgit@trillian.cg.shawcable.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/2, Grant Likely <grant.likely@secretlab.ca>:

>  static int __init
>  xilinxfb_init(void)
>  {
> -       /*
> -        * No kernel boot options used,
> -        * so we just need to register the driver
> -        */
> +       int rc;
> +       rc = xilinxfb_of_register();
> +       if (rc)
> +               return rc;
> +
>         return platform_driver_register(&xilinxfb_platform_driver);

Is it better to add error handling for platform_driver_register()?

    rc = platform_driver_register(&xilinxfb_platform_driver);
    if (rc)
        xilinxfb_of_unregister();

    return rc;


>  }
>
> @@ -398,6 +482,7 @@ static void __exit
>  xilinxfb_cleanup(void)
>  {
>         platform_driver_unregister(&xilinxfb_platform_driver);
> +       xilinxfb_of_unregister();
>  }
