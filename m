Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbXJVLtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbXJVLtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXJVLtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:49:42 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:36153 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbXJVLtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:49:41 -0400
Message-ID: <471C8DA3.9070900@aitel.hist.no>
Date: Mon, 22 Oct 2007 13:46:43 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Henrik Carlqvist <hc1@poolhem.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se>
In-Reply-To: <20071020144238.4f258c8c.hc1@poolhem.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Carlqvist wrote:
> I think there is a need for Kconfig to specify that a functionality could
> be built as a module or not built at all.
>
> Some drivers require that firmware is loaded when the driver is
> initialized. The kernel has functionalities for this by using a userspace
> program. However, this userspace program is only usable from modules and
> not during boot while any initrd or any other file system has not yet been
> mounted and yet less any processes started.
>   
I cannot see a reason to outlaw built-in driver
for this case. The device needing a firmware file
is not an argument for making the driver modular only.

The idea for the fix is simple enough. Such a driver should
not initialize just because the kernel itself boots up. It should
wait until the firmware is provided. (which surely can be
done from an initrd, so you can use that device as
the root fs if need be.)

Similar example: Drivers for all sorts of USB thingies
can be built into the kernel. Still, these drivers don't
initialize until hardware is plugged in. Which could happen
weeks later. They just wait until a device is ready for use.

Surely other drivers can do the same - wait until
the device is ready (firmware gets loaded) and
start to use the device at that point.

> For example, Slackware 12 has a huge kernel with a lot of drivers for
> different file systems and scsi cards built in. This kernel is supposed to
> be a non optimized kernel that works on almost any machine even without an
> initrd. In that kernel CONFIG_SCSI_QLA_FC is set to y but still it is not
> possible to boot from any of those cards as the driver requires a firmware
> file. 
Then an initrd-less boot is impossible for this
device - even the modular approach needs
an initrd to load the module if you want that
device as root fs.
> Even together with an initrd image containing the firmware file it
> is still not possible to use the driver as the driver require the firmware
> file before any processes has been started from the initrd image.
>   
So fix that! If the driver can wait for its firmware
in the modular case, then it can wait for its firmware
in the built-in case too. That capability may require some
coding of course, but _depending_ on modularity is
silly. There are enough people out there that simply
don't want modules, and even leave out module support
when compiling. There should be no need for modules
when you compile the kernel specifically for
the machine.

> For such drivers requiring firmware files, or if there is any other reason
> that the driver doesn't work when built into the kernel it would be useful
> with another choice than bool or tristate.
>   
Better to just fix the driver - which can't be that
hard for anyone capable of making the driver in
the first place. Modularity and firmware loading
are not connected. One is for kernel flexibility, the other
is for making a particular device work.

Helge Hafting
