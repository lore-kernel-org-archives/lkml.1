Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbXLUMQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbXLUMQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbXLUMQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:16:07 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4553 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754402AbXLUMQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:16:05 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: bharrosh@panasas.com (Boaz Harrosh)
Subject: Re: [PATCH 1/3] SG: Move functions to lib/scatterlist.c and add sg chaining allocator helpers
Cc: jens.axboe@oracle.com, James.Bottomley@steeleye.com,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougg@torque.net
Organization: Core
In-Reply-To: <476A7566.2040802@panasas.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.scsi
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J5gmu-0000JP-00@gondolin.me.apana.org.au>
Date: Fri, 21 Dec 2007 20:15:36 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 416e000..c3ca848 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -7,6 +7,12 @@
> #include <linux/string.h>
> #include <asm/io.h>
> 
> +struct sg_table {
> +       struct scatterlist *sgl;        /* the list */
> +       unsigned int nents;             /* number of mapped entries */
> +       unsigned int orig_nents;        /* original size of list */
> +};

If we're making massive changes like this, let's do it properly
as Rusty has demonstrated so that we support back-chaining as
well as frong-chaining.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
