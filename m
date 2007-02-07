Return-Path: <linux-kernel-owner+w=401wt.eu-S933302AbXBGGbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbXBGGbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbXBGGbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:31:16 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38827 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302AbXBGGbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:31:16 -0500
Date: Wed, 7 Feb 2007 07:32:16 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       linux-390@vm.marist.edu
Subject: Re: [PATCH 2.6.20] s390-drivers: Use ARRAY_SIZE macro when
 appropriate
Message-ID: <20070207073216.246a079d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070206160744.GK8991@Ahmed>
References: <20070206160204.GA8991@Ahmed>
	<20070206160744.GK8991@Ahmed>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 18:07:44 +0200,
"Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi all,
> 
> A patch to use ARRAY_SIZE macro already defined in kernel.h
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> Not compile tested due to (ofcourse ;)) missing hardware.
> 
> diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
> index f172759..997f468 100644
> --- a/drivers/s390/cio/device_id.c
> +++ b/drivers/s390/cio/device_id.c
> @@ -11,6 +11,7 @@
> 
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
> 
>  #include <asm/ccwdev.h>
>  #include <asm/delay.h>
> @@ -138,7 +139,7 @@ VM_virtual_device_info (__u16 devno, struct senseid *ps)
>  		ps->cu_model = 0x60;
>  		return;
>  	}
> -	for (i = 0; i < sizeof(vm_devices) / sizeof(vm_devices[0]); i++)
> +	for (i = 0; i < ARRAY_SIZE(vm_devices); i++)
>  		if (diag_data.vrdcvcla == vm_devices[i].vrdcvcla &&
>  		    diag_data.vrdcvtyp == vm_devices[i].vrdcvtyp) {
>  			ps->cu_type = vm_devices[i].cu_type;
> 
> 

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
