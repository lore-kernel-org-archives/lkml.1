Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZGUTkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZGUTkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZGUTkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:40:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48160 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZGUTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:40:39 -0400
Date: Tue, 21 Jul 2009 21:40:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Miller <davem@davemloft.net>
Cc: fthain@telegraphics.com.au, gregkh@suse.de, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, geert@linux-m68k.org, akpm@linux-foundation.org
Subject: Re: [PATCH] move macsonic's probe function to .devinit.text
Message-ID: <20090721194036.GB10770@pengutronix.de>
References: <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.OSX.2.00.0907220032230.796@silk.local> <20090721.122058.23378599.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090721.122058.23378599.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Jul 21, 2009 at 12:20:58PM -0700, David Miller wrote:
> From: Finn Thain <fthain@telegraphics.com.au>
> Date: Wed, 22 Jul 2009 01:14:36 +1000 (EST)
>
> > On Sat, 11 Jul 2009, Uwe Kleine-K?nig wrote:
> > 
> >> A pointer to mac_sonic_probe is passed to the core via
> >> platform_driver_register and so the function must not disappear when
> >> the .init sections are discarded.  Otherwise (if also having
> >> HOTPLUG=y) unbinding and binding a device to the driver via sysfs will
> >> result in an oops as does a device being registered late.
> > 
> > This patch works for me (tested on a Quadra 630). I still get an oops
> > on rmmod, but that's a separate issue. I'll send a patch for that.
> 
> Applied, but Uwe _please_ post networking patches to
> netdev@vger.kernel.org so that they get properly logged
> and tracked at:
There are 8 patches in this series that touch drivers/net, only one of
them had a Cc: to netdev.

The diffstat of my series for drivers/net is
 drivers/net/arm/am79c961a.c  |    2 +-
 drivers/net/arm/at91_ether.c |    2 +-
 drivers/net/jazzsonic.c      |    4 ++--
 drivers/net/macsonic.c       |   14 +++++++-------
 drivers/net/meth.c           |    2 +-
 drivers/net/sb1250-mac.c     |    2 +-
 drivers/net/sgiseeq.c        |    2 +-
 drivers/net/xtsonic.c        |    2 +-
 8 files changed, 15 insertions(+), 15 deletions(-)

drivers/net/arm/at91_ether.c got a NACK by David Brownell---he wants the
alternative to be implemented.
drivers/net/arm/am79c961a.c got the Cc to netdev@
You now took drivers/net/macsonic.c.

Should I repost the remaining 5 to netdev@?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
