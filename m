Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXJIFa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXJIFa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXJIFaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:30:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62217 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbXJIFaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:30:15 -0400
Date: Mon, 8 Oct 2007 22:28:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, starvik@axis.com
Cc: Sam Ravnborg <sam@ravnborg.org>, Oleg Verych <olecom@flower.upol.cz>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-Id: <20071008222839.5d595cc9.randy.dunlap@oracle.com>
In-Reply-To: <20071008215316.6e186b89.randy.dunlap@oracle.com>
References: <20071008200255.GA16497@uranus.ravnborg.org>
	<20071008205048.GY22435@flower.upol.cz>
	<20071009041743.GA21552@uranus.ravnborg.org>
	<20071008215316.6e186b89.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 21:53:16 -0700 Randy Dunlap wrote:

> On Tue, 9 Oct 2007 06:17:43 +0200 Sam Ravnborg wrote:
> 
> > > 
> > > What about, that this is the first ever prompt, that must be shown and
> > > written to the .config?
> > Two issues to fix before we can do this:
> > 1) chocie values cannot have more than one prompt
> > 2) We need to share much more Kconfig* between the individual architectures
> >    First step is to let all arch's use drivers/Kconfig
> 
> 2) isn't terribly difficult, just takes some time and willingness
> of $arch maintainers to some changes, but please explain a bit more
> why it is needed...?

Maybe I didn't read carefully:  "to add arch selection to kconfig"..

arch/cris using drivers/Kconfig: patch is below (maintainer is
cc-ed)

> > Let's get the two items above solved then we can revisit adding arch selection
> > to kconfig (where it belongs in the end).
> > And neither require a rewrite of kconfig...
> > 
> > > Also, i'd like to propose sequencing of config-enable-build-this-unit
> > > in config file(s), thus Makefile(s) (sometimes very small and stupid)
> > > will be not necessary. Additional link ordering can be supplied as
> > > meta-config information there. Shell scripting, very ugly in the view
> > > of make syntax, will be natural in config files. Extending build
> > > process to get hidden dependencies or right linking/other magic is
> > > part of particular configuration. Hm?
> > Discussed before but so far no patches has shown up.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Move arch/cris to using drivers/Kconfig for its drivers config list.
When all arches do this, Sam can make more interesting improvements
to .config files.

Using drivers/Kconfig adds these kconfig files to cris:
connector, misc, ata, message/fusion (not avail.), macintosh (not avail.),
i2c, spi, w1, power, hwmon, mfd, video, hid, mmc, leds,
infiniband (not avail.), edac (not avail.), rtc, dma, auxdisplay,
kvm (not avail.), uio, and lguest (not avail.).

Many of these are already enabled/disabled per arch., so adding that
for cris can be done as required.

"not avail." means that this menu is not valid for this arch.
and won't be presented to users when running 'make *config'.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/cris/Kconfig |   40 +---------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

--- linux-2.6.23-rc9-git6.orig/arch/cris/Kconfig
+++ linux-2.6.23-rc9-git6/arch/cris/Kconfig
@@ -153,49 +153,11 @@ source arch/cris/arch-v10/drivers/Kconfi
 
 endmenu
 
-source "drivers/base/Kconfig"
-
 # standard linux drivers
-source "drivers/mtd/Kconfig"
-
-source "drivers/parport/Kconfig"
-
-source "drivers/pnp/Kconfig"
-
-source "drivers/block/Kconfig"
-
-source "drivers/md/Kconfig"
-
-source "drivers/ide/Kconfig"
-
-source "drivers/scsi/Kconfig"
-
-source "drivers/ieee1394/Kconfig"
-
-source "drivers/message/i2o/Kconfig"
-
-source "drivers/net/Kconfig"
-
-source "drivers/isdn/Kconfig"
-
-source "drivers/telephony/Kconfig"
-
-#
-# input before char - char/joystick depends on it. As does USB.
-#
-source "drivers/input/Kconfig"
-
-source "drivers/char/Kconfig"
-
-#source drivers/misc/Config.in
-source "drivers/media/Kconfig"
+source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "sound/Kconfig"
-
-source "drivers/usb/Kconfig"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
