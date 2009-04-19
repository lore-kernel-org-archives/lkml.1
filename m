Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZDSJcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZDSJcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZDSJcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:32:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:47154 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbZDSJcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:32:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18922.61340.630534.74677@pilspetsen.it.uu.se>
Date: Sun, 19 Apr 2009 11:32:12 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, khc@pm.waw.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc broke ixp4xx_eth, firmware breakage?
In-Reply-To: <20090418.211820.197285479.davem@davemloft.net>
References: <200904182153.n3ILrP6j027453@pilspetsen.it.uu.se>
	<20090418.211820.197285479.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Sat, 18 Apr 2009 23:53:25 +0200 (MEST)
 > 
 > > The ixp4xx_eth driver for my IXP420 XScale box (Synology DS101)
 > > worked fine in kernel 2.6.29. Now trying to boot 2.6.30-rc2 I'm
 > > greeted with the following failure during init:
 > > 
 > > Bringing up interface eth0:  RTNETLINK answers: No such file or directory
 > > Failed to bring up eth0.
 > > [FAILED]
 > > 
 > > There's a fairly long (at least 10 seconds) delay between the 'Bringing up'
 > > message and the RTNETLINK error.
 > > 
 > > A diff between the 2.6.29 and 2.6.30-rc2 boot logs indicates that
 > > the firmware doesn't get loaded:
 > 
 > Please make sure CONFIG_FIRMWARE_IN_KERNEL is set in your
 > configuration if this driver is being built statically
 > into your kernel.

ixp4xx_eth is built as a module and I have CONFIG_FIRMWARE_IN_KERNEL unset.

 > Otherwise, if modular, make sure the firmware files get installed into
 > the correct location and are available in the filesystem when the
 > driver loads.

The firmware isn't shipped with the kernel but is something users have to
download from Intel, build, and install themselves; once installed they work
across kernel versions. The files reside in /lib/firmware/'s top-level
directory, and they are available since firmware loading (triggered by init's
attempt to up eth0) occurs after / has been mounted. My userspace uses oldish
firmware-aware hotplug since udev's too heavy-weight.

This all works with 2.6.29 and older 2.6.2x kernels.

I'll do a bisect.
