Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZC0OSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZC0OSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZC0OSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:18:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10949 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZC0OSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:18:01 -0400
Date: Fri, 27 Mar 2009 15:17:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Oskar Schirmer" <os@emlix.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Chris Zankel <chris@zankel.net>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [patch] add pca9543 driver
Message-ID: <20090327151744.5422b2b5@hyperion.delvare>
In-Reply-To: <20090326162315.GA26255@emlix.com>
References: <1238078818-25977-1-git-send-email-os@emlix.com>
	<20090326155105.5dfbd898@hyperion.delvare>
	<20090326162315.GA26255@emlix.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 17:23:15 +0100, Oskar Schirmer wrote:
> On Thu, Mar 26, 2009 at 15:51:05 +0100, Jean Delvare wrote:
> > On Thu, 26 Mar 2009 15:46:58 +0100, Oskar Schirmer wrote:
> > > support pca9543 i2c bus switch chip
> > > 
> > > Signed-off-by: Oskar Schirmer <os@emlix.com>
> > > ---
> > >  drivers/i2c/chips/Kconfig   |    3 +
> > >  drivers/i2c/chips/Makefile  |    1 +
> > 
> > Please read the header of these two files carefully again.
> 
> Ok, I see. But how to have PCA9543 supported then?
> The PCA9543 is an I2C bus switch/mux, so following
> the headers it might be placed in drivers/<functionality>,
> where <functionality> is "i2c bus mux", thus drivers/i2c.

We could consider creating drivers/i2c/muxes or similar for I2C
multiplexer drivers, especially if we start supporting many of them.

> As this is obviously not the solution, we might try to do the
> bus muxing manually from userland, as soon as the system is up.

"From userland" is exactly what your driver is doing, and this is
clearly not acceptable. You can't do userland switching and let the
kernel instantiate devices, as you found out yourself, which means that
such multiplexed buses would only support userland-created devices
(that is, i2c-dev.) This is way too limited to spend time on it.

> This wont work either, as the video drivers need the i2c bus
> switch programmed before the video stuff can be initialized,
> thus during bootup.
> 
> Next, the drivers proposed by Rodolfo Giometti
> ( http://article.gmane.org/gmane.linux.drivers.i2c/2996/ )
> might add the functionality needed.

It's not that they "might", rather they are _exactly_ what you need.

> As far as I can see from
> Documentation/feature-removal-schedule.txt, prerequisites for
> it to be accepted are given with 2.6.30, is the driver by
> Rodolfo still in the queue, i.e. being merged for 2.6.30 now?

Unfortunately not, I'm still working on the prerequisite in question
and I _hope_ to have that done in 2.6.30, but Rodolfo's work won't make
it in time. Which does not mean you shouldn't look at it, see how it
works for you, and report to Rodolfo. The more people help him cleanup
and improve his code, the easier and faster it will be when the time
finally comes to merge it.

-- 
Jean Delvare
