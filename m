Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYJVKgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYJVKgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYJVKgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:36:42 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:30878 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753268AbYJVKgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:36:42 -0400
Date: Wed, 22 Oct 2008 14:36:41 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081022103641.GB24757@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081022014243.GA19362@oksana.dev.rtsoft.ru> <1224642497.7654.319.camel@pasglop> <200810212122.49121.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200810212122.49121.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:22:48PM -0700, David Brownell wrote:
> On Tuesday 21 October 2008, Benjamin Herrenschmidt wrote:
> > The notifier can be registered before the devices, though it's a little
> > bit fishy and fragile.
> > 
> > Easier I suppose to just have OF specific hooks in the bus code.
> 
> Like what I suggested:  "chip-aware OF glue drivers".  The relevant
> bus code being the "of_platform_bus_type" infrastructure.
> 
> Example:  instead of Anton's patch #6 modifying the existing pca953x
> driver, an of_pca953x driver that knows how to poke around in the OF
> device attributes to (a) create the pca953x_platform_data, (b) call
> i2c_register_board_info() to make that available later, and then
> finally (c) vanish, since it's not needed any longer.

Heh. You tell me my first approach:

http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056730.html (mmc_spi)

The OF people didn't like the patch which was used to support this
approach:
http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056728.html


The board info has another problem though. We can't remove it, thus
we can't implement module_exit() for the 'OF glue'.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
