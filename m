Return-Path: <linux-kernel-owner+w=401wt.eu-S939145AbXGUAon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939145AbXGUAon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757791AbXGUAod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:44:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33939 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbXGUAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:44:32 -0400
Date: Fri, 20 Jul 2007 17:43:49 -0700
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070721004348.GA14362@kroah.com>
References: <200707171703.31340.rob@landley.net> <200707181339.54192.rob@landley.net> <20070719101617.08c867a7@gondolin.boeblingen.de.ibm.com> <200707202021.40009.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707202021.40009.rob@landley.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 08:21:39PM -0400, Rob Landley wrote:
> Ok, back up.  /sys/devices does not contain all the information necessary to 
> populate /dev, because it hasn't got things like 
> ramdisks, /dev/zero, /dev/console which are THERE in sysfs, which may or may 
> not be supported by the kernel (the kernel might have ramdisk support, might 
> not).

Welcome to 2007:

$ ls /sys/devices/virtual/mem/
full  kmem  kmsg  mem  null  port  random  urandom  zero
$ ls /sys/devices/virtual/tty/
console  tty12  tty19  tty25  tty31  tty38  tty44  tty50  tty57  tty63
ptmx     tty13  tty2   tty26  tty32  tty39  tty45  tty51  tty58  tty7
tty      tty14  tty20  tty27  tty33  tty4   tty46  tty52  tty59  tty8
tty0     tty15  tty21  tty28  tty34  tty40  tty47  tty53  tty6   tty9
tty1     tty16  tty22  tty29  tty35  tty41  tty48  tty54  tty60
tty10    tty17  tty23  tty3   tty36  tty42  tty49  tty55  tty61
tty11    tty18  tty24  tty30  tty37  tty43  tty5   tty56  tty62

I suggest you take a close look at the kernel before making statements
like the above :)

> These things could also, in future, have their major and minor numbers 
> dynamically (even randomly) assigned.  That's been discussed on this list.

I tried that once, it will require some core api kernel changes and a
lot of infrastrucure work to get that to work properly.  Not that it
will never happen in the future, but it's just not a trivial change at
the moment...

thanks,

greg k-h
