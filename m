Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXKDXhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXKDXhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXKDXhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:37:06 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34449
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbXKDXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:37:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: Re: [PATCH] Prism54: Convert mgmt_sem to the mutex API
Date: Mon, 5 Nov 2007 00:36:13 +0100
User-Agent: KMail/1.9.6
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20071101071902.GH6092@traven>
In-Reply-To: <20071101071902.GH6092@traven>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711050036.13654.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 08:19:02 Matthias Kaehlcke wrote:
> Prism54: Convert mgmt_sem to the mutex API
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> --
> 
> diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
> index 219dd65..dbb538c 100644
> --- a/drivers/net/wireless/prism54/islpci_dev.c
> +++ b/drivers/net/wireless/prism54/islpci_dev.c
> @@ -861,7 +861,7 @@ islpci_setup(struct pci_dev *pdev)
>  	init_waitqueue_head(&priv->reset_done);
>  
>  	/* init the queue read locks, process wait counter */
> -	sema_init(&priv->mgmt_sem, 1);
> +	mutex_init(&priv->mgmt_lock);
>  	priv->mgmt_received = NULL;
>  	init_waitqueue_head(&priv->mgmt_wqueue);
>  	sema_init(&priv->stats_sem, 1);
> diff --git a/drivers/net/wireless/prism54/islpci_dev.h b/drivers/net/wireless/prism54/islpci_dev.h
> index 736666d..4e0182c 100644
> --- a/drivers/net/wireless/prism54/islpci_dev.h
> +++ b/drivers/net/wireless/prism54/islpci_dev.h
> @@ -26,6 +26,7 @@
>  #include <linux/wireless.h>
>  #include <net/iw_handler.h>
>  #include <linux/list.h>
> +#include <linux/mutex.h>
>  
>  #include "isl_38xx.h"
>  #include "isl_oid.h"
> @@ -164,7 +165,7 @@ typedef struct {
>  	wait_queue_head_t reset_done;
>  
>  	/* used by islpci_mgt_transaction */
> -	struct semaphore mgmt_sem; /* serialize access to mailbox and wqueue */
> +	struct mutex mgmt_lock; /* serialize access to mailbox and wqueue */
>  	struct islpci_mgmtframe *mgmt_received;	  /* mbox for incoming frame */
>  	wait_queue_head_t mgmt_wqueue;            /* waitqueue for mbox */
>  

Uhm, so this mutex is not used? Why not remove it then?

-- 
Greetings Michael.
