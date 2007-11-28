Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbXK1RFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbXK1RFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbXK1RFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:05:38 -0500
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:11542 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758465AbXK1RFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:05:37 -0500
From: Frans Pop <elendil@planet.nl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [s390] networking related oops during boot on Hercules (was: build failure)
Date: Wed, 28 Nov 2007 18:05:33 +0100
User-Agent: KMail/1.9.7
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ursula Braun <braunu@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Tiedemann <ptiedem@de.ibm.com>
References: <200711281127.30051.elendil@planet.nl> <200711281324.02748.elendil@planet.nl> <200711281718.48661.borntraeger@de.ibm.com>
In-Reply-To: <200711281718.48661.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711281805.34959.elendil@planet.nl>
X-OriginalArrivalTime: 28 Nov 2007 17:05:35.0388 (UTC) FILETIME=[E45E4DC0:01C831E0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007, Christian Borntraeger wrote:
> This seems to be related to the new network namespace code by Eric
> Biederman (CCed). Can you try the following (untested) patch? I also
> CCed Ursula and Peter as they know the ctc code better than me.

Yes, that fixes it. Boots fine now and I can ssh into the system. Not tested 
any further than that.

Thanks Christian.

> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Ursula Braun <braunu@de.ibm.com>
> CC: Peter Tiedemann <ptiedem@de.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>
> ---
>  drivers/s390/net/ctcmain.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux-2.6/drivers/s390/net/ctcmain.c
> ===================================================================
> --- linux-2.6.orig/drivers/s390/net/ctcmain.c
> +++ linux-2.6/drivers/s390/net/ctcmain.c
> @@ -56,6 +56,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/ctype.h>
>  #include <net/dst.h>
> +#include <net/net_namespace.h>
>
>  #include <asm/io.h>
>  #include <asm/ccwdev.h>
> @@ -2823,6 +2824,7 @@ ctc_init_netdevice(struct net_device * d
>  	dev->type = ARPHRD_SLIP;
>  	dev->tx_queue_len = 100;
>  	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
> +	dev->nd_net = &init_net;
>  	return dev;
>  }

