Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZHaOYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZHaOYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZHaOYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:24:07 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24446 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZHaOYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:24:07 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, ISS StorageDev <iss_storagedev@hp.com>
Date: Mon, 31 Aug 2009 14:23:30 +0000
Subject: RE: [PATCH] cciss: fix schedule_timeout() parameters
Thread-Topic: [PATCH] cciss: fix schedule_timeout() parameters
Thread-Index: AcoprxV+0FfBH0d0SoSI4AijAUgnrQAl3TwA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77886952D5F97E@GVW0547EXC.americas.hpqcorp.net>
References: <4A9ADECE.7050900@xenotime.net>
In-Reply-To: <4A9ADECE.7050900@xenotime.net>
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
> From: Randy Dunlap [mailto:rdunlap@xenotime.net] 
> Sent: Sunday, August 30, 2009 3:19 PM
> To: lkml
> Cc: akpm; Miller, Mike (OS Dev); ISS StorageDev
> Subject: [PATCH] cciss: fix schedule_timeout() parameters
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change schedule_timeout() parameter to not be specific to HZ=1000.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: iss_storagedev@hp.com

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- lnx-2631-rc7.orig/drivers/block/cciss.c
> +++ lnx-2631-rc7/drivers/block/cciss.c
> @@ -36,6 +36,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  #include <linux/init.h>
> +#include <linux/jiffies.h>
>  #include <linux/hdreg.h>
>  #include <linux/spinlock.h>
>  #include <linux/compat.h>
> @@ -3489,7 +3490,7 @@ static int __devinit cciss_pci_init(ctlr
>  		if (scratchpad == CCISS_FIRMWARE_READY)
>  			break;
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		schedule_timeout(HZ / 10);	/* wait 100ms */
> +		schedule_timeout(msecs_to_jiffies(100));	
> /* wait 100ms */
>  	}
>  	if (scratchpad != CCISS_FIRMWARE_READY) {
>  		printk(KERN_WARNING "cciss: Board not ready.  
> Timed out.\n"); @@ -3615,7 +3616,7 @@ static int __devinit 
> cciss_pci_init(ctlr
>  			break;
>  		/* delay and try again */
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		schedule_timeout(10);
> +		schedule_timeout(msecs_to_jiffies(1));
>  	}
>  
>  #ifdef CCISS_DEBUG
> 