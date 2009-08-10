Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbZHJEs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbZHJEs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 00:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZHJEs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 00:48:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59232
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbZHJEs4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 00:48:56 -0400
Date: Sun, 09 Aug 2009 21:49:06 -0700 (PDT)
Message-Id: <20090809.214906.143672876.davem@davemloft.net>
To: u.kleine-koenig@pengutronix.de
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, linux@arm.linux.org.uk,
       dbaryshkov@gmail.com, kernel@wantstofly.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/6] [NET] ixp2000/enp2611: don't set non-existent
 member get_stats
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249677761-19470-5-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de>
	<1249677761-19470-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Fri,  7 Aug 2009 22:42:40 +0200

> This fixes a build failure for 2.6.31-rc5 (ARCH=arm, ixp2000_defconfig):
> 
> 	  CC      drivers/net/ixp2000/enp2611.o
> 	drivers/net/ixp2000/enp2611.c: In function 'enp2611_init_module':
> 	drivers/net/ixp2000/enp2611.c:213: error: 'struct net_device' has no member named 'get_stats'
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

This is far from the way to fix this, unfortunately.

We need to find a way to propagate this assignment into
the netdev_ops method vector instead.
