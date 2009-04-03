Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbZDCG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbZDCG5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758888AbZDCG5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:57:12 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45762 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZDCG5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:57:12 -0400
Message-ID: <49D5B351.5040601@nokia.com>
Date: Fri, 03 Apr 2009 09:57:21 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kevin Cernekee <kpc.mtd@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] MTD: nandsim should delete its partitions on module unload
References: <a95a62fe0904021632l14ddb299l7818f2f2d32c20ac@mail.gmail.com>
In-Reply-To: <a95a62fe0904021632l14ddb299l7818f2f2d32c20ac@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2009 06:56:26.0884 (UTC) FILETIME=[4F002C40:01C9B429]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Cernekee wrote:
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
>  	int i;
> 
> +	del_mtd_partitions(nsmtd);
>  	free_nandsim(ns);    /* Free nandsim private resources */
>  	nand_release(nsmtd); /* Unregister driver */
>  	for (i = 0;i < ARRAY_SIZE(ns->partitions); ++i)

Doesn't nand_release() already do that?
