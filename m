Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZHJJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZHJJkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZHJJkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:40:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40614 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZHJJkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:40:41 -0400
Date: Mon, 10 Aug 2009 11:40:27 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, linux@arm.linux.org.uk,
       dbaryshkov@gmail.com, kernel@wantstofly.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/6] [NET] ixp2000/enp2611: don't set non-existent
	member get_stats
Message-ID: <20090810094027.GA22200@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de> <1249677761-19470-5-git-send-email-u.kleine-koenig@pengutronix.de> <20090809.214906.143672876.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090809.214906.143672876.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Aug 09, 2009 at 09:49:06PM -0700, David Miller wrote:
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Date: Fri,  7 Aug 2009 22:42:40 +0200
> 
> > This fixes a build failure for 2.6.31-rc5 (ARCH=arm, ixp2000_defconfig):
> > 
> > 	  CC      drivers/net/ixp2000/enp2611.o
> > 	drivers/net/ixp2000/enp2611.c: In function 'enp2611_init_module':
> > 	drivers/net/ixp2000/enp2611.c:213: error: 'struct net_device' has no member named 'get_stats'
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> This is far from the way to fix this, unfortunately.
> 
> We need to find a way to propagate this assignment into
> the netdev_ops method vector instead.
Yes, I tried that, but stopped when I saw it's declared const.  I don't
know if this is required.  If yes then the only way to fix it is to add
a platform callback that is called if non-NULL.

I don't want to invest time here without a word by the maintainers
though.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
