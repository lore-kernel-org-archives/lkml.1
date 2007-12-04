Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXLDKdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXLDKdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXLDKc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:32:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXLDKc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:32:58 -0500
Date: Tue, 4 Dec 2007 11:32:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ptiedem@de.ibm.com, braunu@de.ibm.com, jeff@garzik.org,
       linux-s390@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [build failure] Re: Linux 2.6.24-rc4 on S390x
Message-ID: <20071204103237.GA15038@elte.hu>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <47552A98.9010108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47552A98.9010108@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> The patch ctc: make use of alloc_netdev() (commit 
> 1c1478859017452a1179dbbdf7b9eb5b48438746) introduces the build failure
> 
>   CC [M]  drivers/s390/net/fsm.o
>   CC [M]  drivers/s390/net/smsgiucv.o
>   CC [M]  drivers/s390/net/ctcmain.o
> drivers/s390/net/ctcmain.c: In function `ctc_init_netdevice':
> drivers/s390/net/ctcmain.c:2805: error: implicit declaration of function `SET_MODULE_OWNER'
> make[2]: *** [drivers/s390/net/ctcmain.o] Error 1
> make[1]: *** [drivers/s390/net] Error 2
> make: *** [drivers/s390] Error 2

the patch below should fix this.

	Ingo

------------>
Subject: drivers/s390/net/ctcmain.c: fix build bug
From: Ingo Molnar <mingo@elte.hu>

SET_MODULE_OWNER() is obsolete.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/s390/net/ctcmain.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/drivers/s390/net/ctcmain.c
===================================================================
--- linux.orig/drivers/s390/net/ctcmain.c
+++ linux/drivers/s390/net/ctcmain.c
@@ -2802,7 +2802,6 @@ void ctc_init_netdevice(struct net_devic
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 100;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
-	SET_MODULE_OWNER(dev);
 }
 
 
