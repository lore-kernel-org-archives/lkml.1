Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYHAJ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYHAJ07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYHAJ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:26:52 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:50649 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYHAJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:26:51 -0400
X-Greylist: delayed 44569 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 05:26:51 EDT
Date: Fri, 1 Aug 2008 11:26:43 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20080801092643.GX8465@enneenne.com>
References: <1213794512-8245-1-git-send-email-giometti@linux.it> <20080619233411.GA27198@zarina> <20080620061345.GA9339@gundam.enneenne.com> <20080623063817.GA24051@zarina> <20080731210354.GW8465@enneenne.com> <20080801082853.GA19224@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801082853.GA19224@zarina>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] power: support for Texas Instruments BQ27x00 battery
	managers.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 12:28:53PM +0400, Anton Vorontsov wrote:
> > On Mon, Jun 23, 2008 at 10:38:17AM +0400, Anton Vorontsov wrote:
> > 
> > > Here is the patch to show the idea. I only tested it to build, so no
> > > guaranties that it will work on the actual hardware. :-)
> > > 
> > > This patch should be separated: one patch is for I2C subsystem
> > > maintainer (drivers/i2c/* changes) and another (drivers/power/* +
> > > include/linux/bq27x00.h) is for me.
> > 
> > On my system I need to specify 2 battery chips into the platform
> > specific file as follow (file is arch/arm/mach-pxa/wr1100.c):
> > 
> > 	static struct i2c_board_info __initdata wr1100_i2c_mux_devices[] = {
> > 	        {
> > 	                I2C_BOARD_INFO("bq27200", 0x55),
> > 	        },
> > 	};
> > 		
> >         i2c_register_board_info(2, wr1100_i2c_mux_devices,
> >                                         ARRAY_SIZE(wr1100_i2c_mux_devices));
> >         i2c_register_board_info(3, wr1100_i2c_mux_devices,
> >                                         ARRAY_SIZE(wr1100_i2c_mux_devices));
> > 
> > By using your solution I cannot use this code, is that right?
> 
> Why not? I think there should be no problem.

The platform_driver_register() conflicts with i2c_add_driver(),
doesn't it? O_o

> [...]
> > if you agree, I prefere resend my
> > patch without the #ifdef and the w1 support (since I cannot test it at
> > all) but living the possibility to add that support later.
> 
> Yes, that would be also fine.

Ok, since I cannot test the w1 subsystem at all, is better I provide
only tested code. :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
