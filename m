Return-Path: <linux-kernel-owner+w=401wt.eu-S932892AbYD2P1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbYD2P1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYD2P1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:27:42 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29090 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYD2P1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:27:41 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Denis V. Lunev" <den@openvz.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       ISS StorageDev <iss_storagedev@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Date: Tue, 29 Apr 2008 15:26:58 +0000
Subject: RE: [PATCH 7/12] cciss: assign PDE->data before gluing PDE into
 /proc tree
Thread-Topic: [PATCH 7/12] cciss: assign PDE->data before gluing PDE into
 /proc tree
Thread-Index: Acip6g7tBLZ//P1mTQmGQ9wHi31WaAAI1QiA
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE0452F8DF96@G6W0268.americas.hpqcorp.net>
References: <1209467538.29647.11.camel@iris.sw.ru>
 <1209467602-20001-7-git-send-email-den@openvz.org>
In-Reply-To: <1209467602-20001-7-git-send-email-den@openvz.org>
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
> From: den@sw.ru [mailto:den@sw.ru] On Behalf Of Denis V. Lunev
> Sent: Tuesday, April 29, 2008 6:13 AM
> To: akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org; Denis V. Lunev; Alexey
> Dobriyan; Eric W. Biederman; ISS StorageDev; Greg Kroah-Hartman
> Subject: [PATCH 7/12] cciss: assign PDE->data before gluing
> PDE into /proc tree
>
> Simply replace proc_create and further data assigned with
> proc_create_data.
>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> Cc: Alexey Dobriyan <adobriyan@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: <iss_storagedev@hp.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index e539be5..e336b05 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -428,13 +428,9 @@ static void __devinit cciss_procinit(int i)
>                 proc_cciss = proc_mkdir("driver/cciss", NULL);
>         if (!proc_cciss)
>                 return;
> -       pde = proc_create(hba[i]->devname, S_IWUSR | S_IRUSR
> | S_IRGRP |
> +       pde = proc_create_data(hba[i]->devname, S_IWUSR | S_IRUSR |
> + S_IRGRP |
>                                         S_IROTH, proc_cciss,
> -                                       &cciss_proc_fops);
> -       if (!pde)
> -               return;
> -
> -       pde->data = hba[i];
> +                                       &cciss_proc_fops, hba[i]);
>  }
>  #endif                         /* CONFIG_PROC_FS */
>
> --
> 1.5.3.rc5
>
>
