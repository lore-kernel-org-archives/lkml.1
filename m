Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYGKHhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYGKHhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 03:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYGKHhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 03:37:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27366 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYGKHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 03:37:06 -0400
Date: Fri, 11 Jul 2008 09:36:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Milton Miller <miltonm@bga.com>, linuxppc-dev@ozlabs.org,
       Samuel Ortiz <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [RFC] (almost) booting allyesconfig -- please  don't poke
 super-io  without request_region
Message-ID: <20080711093650.4b98e3b7@hyperion.delvare>
In-Reply-To: <48770B5E.7000308@hhs.nl>
References: <for-27-patch1-0@bga.com>
	<48768018.2070704@hhs.nl>
	<acca8e14e769b2feadee19f1f7448438@bga.com>
	<20080711085246.1ead773b@hyperion.delvare>
	<48770B5E.7000308@hhs.nl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 09:27:26 +0200, Hans de Goede wrote:
> Jean Delvare wrote:
> > Hi Hans, hi Milton,
> > 
> 
> <snip>
> 
> >> One could make a superio driver, and create sub-devices for the IR, 
> >> I2C, floppy, parallel, etc
> >> nodes.
> > 
> > There have been proposals to do this, and this would indeed be a very
> > good idea, but unfortunately nobody took the time to implement this
> > properly, push it upstream and volunteer to maintain it. The problem is
> > that you don't need just a "driver", but a new subsystem, that needs to
> > be designed and maintained.
> 
> Well, I believe there have been some lightweight superio locking coordinator 
> patches been floating around on the lm_sensors list, and I have reviewed them 
> and then a new version was done with my issues fixed.
> 
> I kinda liked the proposed solution there, it was quite simple, moved all the 
> generic superio stuff into generic superio code, and added locking for super io 
> access from multiple drivers, what ever happened to those patches?

As far as I know, nothing, and this is the problem. Somebody needs to
step up and call him/herself the maintainer of the new code, and push
it upstream and convert all the drivers (hwmon, watchdog, parallel
port...) to make use of it. And I am not the one to do this, I am busy
enough as is with i2c and hwmon.

> If were to start using those, we could actually do a request region and then 
> never release it, as things should be.

Yes, if we have a superio access coordinator, it can request the region
and not release it. But as long as we don't have that, I agree with
Milton that the individual drivers should temporarily request the
Super-I/O region before accessing it.

-- 
Jean Delvare
