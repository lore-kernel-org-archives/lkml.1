Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYDUUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYDUUxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYDUUxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:53:06 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:34931 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbYDUUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:53:05 -0400
Date: Mon, 21 Apr 2008 22:34:58 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: kernel BUG at /usr/src/linux-2.6.25/kernel/workqueue.c:224!
	(r8169?)
Message-ID: <20080421203458.GA2931@electric-eye.fr.zoreil.com>
References: <76366b180804201548g309ae6cci286ed6552f3cb71e@mail.gmail.com> <76366b180804202016l19ac362cyb814781449f81e9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180804202016l19ac362cyb814781449f81e9a@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Paprocki <andrew@ishiboo.com> :
> I just received a similar bug on workqueue.c:223 while I was not doing
> anything with the card. These bugs seem to have increased with
> frequency when running under 2.6.25. It used to take me some time to
> cause a problem to appear under 2.6.24, but under 2.6.25 they appear
> very readily. I was actually not touching the machine at all when this
> appeared on the console:

Does the patch below decrease the frequency of the bug ?

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 3acfeea..6ee9db1 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2398,8 +2398,6 @@ static void rtl8169_wait_for_quiescence(struct net_device *dev)
 	rtl8169_irq_mask_and_ack(ioaddr);
 
 #ifdef CONFIG_R8169_NAPI
-	tp->intr_mask = 0xffff;
-	RTL_W16(IntrMask, tp->intr_event);
 	napi_enable(&tp->napi);
 #endif
 }

-- 
Ueimor
