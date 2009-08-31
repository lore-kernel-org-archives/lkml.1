Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZHaSYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZHaSYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZHaSYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:24:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33258 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZHaSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=trI23SGox0Xwd8pA+MaJ3TTvcJwDQW/98WY69n9jy2X5McVZpIxEMXqi4YwnJXzSpM
         89Kj5+O2p7qa+85pnXuUZ3SOgb1GikMXSHwi9/umWCwFD8A6H2ACrVFX2ae8Kzy6mH4x
         M1sIZrzsJQNvqM/Gcpu9frxyJmuXPxWVvowTo=
Message-ID: <4A9C156D.5080701@gmail.com>
Date: Mon, 31 Aug 2009 20:24:45 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: Re: [PATCH] cciss: fix schedule_timeout() parameters
References: <4A9ADECE.7050900@xenotime.net>
In-Reply-To: <4A9ADECE.7050900@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change schedule_timeout() parameter to not be specific to HZ=1000.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: iss_storagedev@hp.com
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
> +		schedule_timeout(msecs_to_jiffies(100));	/* wait 100ms */
>  	}
>  	if (scratchpad != CCISS_FIRMWARE_READY) {
>  		printk(KERN_WARNING "cciss: Board not ready.  Timed out.\n");
> @@ -3615,7 +3616,7 @@ static int __devinit cciss_pci_init(ctlr
>  			break;
>  		/* delay and try again */
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		schedule_timeout(10);
> +		schedule_timeout(msecs_to_jiffies(1));

shouldn't it be msecs_to_jiffies(10)?
