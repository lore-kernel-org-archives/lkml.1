Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZDCHCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZDCHCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761304AbZDCHCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:02:05 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50461 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761125AbZDCHCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:02:03 -0400
Subject: Re: [PATCH] MTD: nandsim should delete its partitions on module
 unload
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <a95a62fe0904021632l14ddb299l7818f2f2d32c20ac@mail.gmail.com>
References: <a95a62fe0904021632l14ddb299l7818f2f2d32c20ac@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Apr 2009 10:01:10 +0300
Message-Id: <1238742070.20906.97.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2009 07:01:12.0161 (UTC) FILETIME=[F909FD10:01C9B429]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 16:32 -0700, Kevin Cernekee wrote:
> Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
> ---
>  drivers/mtd/nand/nandsim.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
> index cd0711b..f4fda9b 100644
> --- a/drivers/mtd/nand/nandsim.c
> +++ b/drivers/mtd/nand/nandsim.c
> @@ -2349,6 +2349,7 @@ static void __exit ns_cleanup_module(void)
>  	struct nandsim *ns = (struct nandsim *)(((struct nand_chip
> *)nsmtd->priv)->priv);
The patch is line-wrapped.

>  	int i;
> 
> +	del_mtd_partitions(nsmtd);
>  	free_nandsim(ns);    /* Free nandsim private resources */
>  	nand_release(nsmtd); /* Unregister driver */
>  	for (i = 0;i < ARRAY_SIZE(ns->partitions); ++i)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

