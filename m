Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbYDPTTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbYDPTTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYDPTTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:19:14 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3257 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYDPTTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:19:12 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>,
       Jens Axboe <jens.axboe@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mikem@beardog.cca.cpqcorp.net" <mikem@beardog.cca.cpqcorp.net>
Date: Wed, 16 Apr 2008 19:18:16 +0000
Subject: RE: [patch] cciss: fix warning oops on rmmod of driver
Thread-Topic: [patch] cciss: fix warning oops on rmmod of driver
Thread-Index: Acif9CpWTUEjU1wpRluIwFMrueBnWAAAmUHg
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE0452BDC314@G6W0268.americas.hpqcorp.net>
References: <20080414142019.GG16584@beardog.cca.cpqcorp.net>
 <20080414170505.GO12774@kernel.dk>
 <20080414172716.GM16584@beardog.cca.cpqcorp.net>
 <20080414173720.GQ12774@kernel.dk>
 <20080414174540.GO16584@beardog.cca.cpqcorp.net>
 <20080414175219.GR12774@kernel.dk>
 <20080416190040.GQ16584@beardog.cca.cpqcorp.net>
In-Reply-To: <20080416190040.GQ16584@beardog.cca.cpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: scameron@beardog.cca.cpqcorp.net
> [mailto:scameron@beardog.cca.cpqcorp.net]
> Sent: Wednesday, April 16, 2008 2:01 PM
> To: Jens Axboe
> Cc: linux-kernel@vger.kernel.org; Miller, Mike (OS Dev);
> mikem@beardog.cca.cpqcorp.net
> Subject: [patch] cciss: fix warning oops on rmmod of driver
>
>
> * Fix oops on cciss rmmod due to calling pci_free_consistent with
>   irqs disabled.
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>
>  linux-2.6.25-rc9/drivers/block/cciss_scsi.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN
> linux-2.6.25-rc9/drivers/block/cciss_scsi.c~pci_free_consisten
> t_oops linux-2.6.25-rc9/drivers/block/cciss_scsi.c
> ---
> root/linux-2.6.25-rc9/drivers/block/cciss_scsi.c~pci_free_cons
> istent_oops   2008-04-16 12:58:53.000000000 -0500
> +++ root-root/linux-2.6.25-rc9/drivers/block/cciss_scsi.c
>   2008-04-16 12:59:22.000000000 -0500
> @@ -1349,9 +1349,9 @@ cciss_unregister_scsi(int ctlr)
>         /* set scsi_host to NULL so our detect routine will
>            find us on register */
>         sa->scsi_host = NULL;
> +       spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
>         scsi_cmd_stack_free(ctlr);
>         kfree(sa);
> -       spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
>  }
>
>  static int
> _
>
