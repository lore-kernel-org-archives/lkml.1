Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbYG2M5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbYG2M5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYG2M5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:57:40 -0400
Received: from userg502.nifty.com ([202.248.238.82]:17611 "EHLO
	userg502.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYG2M5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:57:40 -0400
DomainKey-Signature: a=rsa-sha1; s=userg502; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=t1jq2nFtIyn+btKlNfC9qbxHutkxuGltE6ZCr35F0m0zdVbe17QrywLtpw8XOD5tK
	O7scQW3NIjG6RPCHDnouA==
X-Nifty-SrcIP: [218.226.15.228]
Date: Tue, 29 Jul 2008 21:53:15 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: RE: NETDEV WATCHDOG: wifi0: transmit timed out
Message-Id: <20080729215315.5a505fe7.komurojun-mbn@nifty.com>
In-Reply-To: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
References: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please try to comment out the "WARN_ON_ONCE"
at net/sched/sched_generic.c.


--- linux-2.6.27-rc1/net/sched/sch_generic.c.orig	2008-07-29 21:45:36.000000000 +0900
+++ linux-2.6.27-rc1/net/sched/sch_generic.c	2008-07-29 21:45:54.000000000 +0900
@@ -216,7 +216,6 @@ static void dev_watchdog(unsigned long a
 				printk(KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
 				       dev->name, netdev_drivername(dev, drivername, 64));
 				dev->tx_timeout(dev);
-				WARN_ON_ONCE(1);
 			}
 			if (!mod_timer(&dev->watchdog_timer,
 				       round_jiffies(jiffies +



>I should'nt be posting this, due to
>having  tainted modules(madwifi), but
>I figured I might as well:(below)
>
>[ 5000.986044] NETDEV WATCHDOG: wifi0: transmit timed out
>[ 5000.991959] ------------[ cut here ]------------
>[ 5000.991964] WARNING: at net/sched/sch_generic.c:222 dev_watchdog+0x95/0xe7()

Best Regards
Komuro
