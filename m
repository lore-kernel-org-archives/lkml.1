Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbXF3GP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbXF3GP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 02:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXF3GPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 02:15:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:9471 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXF3GPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 02:15:51 -0400
Message-ID: <fa686aa40706292315v59d0fc4dnc64481d1746e306d@mail.gmail.com>
Date: Sat, 30 Jun 2007 02:15:50 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4 -mm] void unregister_blkdev - delete redundant message
In-Reply-To: <20070630031322.GE4045@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
	 <20070630031322.GE4045@APFDCB5C>
X-Google-Sender-Auth: 59e685c4483f5fc5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> No need to warn unregister_blkdev() failure by caller.
> (The previous patch makes unregister_blkdev() print error message in
> error case)
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>

>
> ---
>  drivers/block/xsysace.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> Index: 2.6-mm/drivers/block/xsysace.c
> ===================================================================
> --- 2.6-mm.orig/drivers/block/xsysace.c
> +++ 2.6-mm/drivers/block/xsysace.c
> @@ -1157,9 +1157,7 @@ static void __exit ace_exit(void)
>  {
>         pr_debug("Unregistering Xilinx SystemACE driver\n");
>         driver_unregister(&ace_driver);
> -       if (unregister_blkdev(ace_major, "xsysace"))
> -               printk(KERN_WARNING "systemace unregister_blkdev(%i) failed\n",
> -                      ace_major);
> +       unregister_blkdev(ace_major, "xsysace");
>  }
>
>  module_init(ace_init);
>


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
