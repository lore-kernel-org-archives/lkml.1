Return-Path: <linux-kernel-owner+w=401wt.eu-S1423055AbXDXT3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423055AbXDXT3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423060AbXDXT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:29:08 -0400
Received: from outmx040.isp.belgacom.be ([195.238.6.177]:59741 "EHLO
	outmx040.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423055AbXDXT3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:29:04 -0400
Date: Tue, 24 Apr 2007 21:29:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, holger@eiboeck.de
Subject: Re: RFC: drivers/char/watchdog/pcwd.c + drivers/char/watchdog/pcwd_pci.c
Message-ID: <20070424192949.GA2831@infomag.infomag.iguana.be>
References: <20070417185849.GA2632@infomag.infomag.iguana.be> <20070417131624.5ae58d63.akpm@linux-foundation.org> <20070419190055.GA31632@infomag.infomag.iguana.be> <20070419123310.6a7a2193.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419123310.6a7a2193.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> >  /* module parameters */
> > +#define CELSIUS		0
> > +#define FAHRENHEIT	1
> > +static int proc_temp_mode = CELSIUS;
> > +module_param(proc_temp_mode, int, 0);
> > +MODULE_PARM_DESC(proc_temp_mode, "which temperature mode to use in /proc/ 0=Celsius, 1=Fahrenheit (default=0)");
> 
> hm, is that a good idea?  Making the contents of /proc files dependent upon
> some module parameter?
> 
> I'd have thought that it would be better to remove this option and either
> 
> a) offer two /proc files: one for Celcius, one for Fahrenheit
> 
> b) Put both values into the same /proc file (one per line)
> 
> c) Just remove the Fahrenheit option altogether - let it join cubits,
>    furlongs, etc.
> 
> I mean, how is an application to make sense of that information if its units
> depend upon some module parameter, or a kernel boot option?

My opinion: temperature measured in a watchdog device is created to be able to
react on a "system overheat" situation. For me this thus is a hwmon device and
thus should be done via the hwmon interface. And that seems to be in 
millidegree Celsius... (where the watchdog drivers used to do things in
Fahrenheit). I propose to follow the hwmon interface setup.

(BTW: My plans with the pcwd drivers is to 1) get one driver that is maintained
in the kernel instead of a basic driver in the kernel and an extended one that
is maintained seperately, 2) convert the pcwd.c driver to the isa_driver,
3) change temperature stuff to hwmon interface and 4) create a sysfs equivalent
for the /proc interface.)

I will take all your other comments/input and rework the code so that it is up
to the kernel standards.

Greetings,
Wim.

