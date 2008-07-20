Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYGTAS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYGTAS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 20:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYGTAST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 20:18:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbYGTASS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 20:18:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: linux-next: Tree for July 18: sky2 WOL broken
Date: Sun, 20 Jul 2008 02:20:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
In-Reply-To: <20080718195352.e562a00f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807200220.11701.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 18 of July 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080717:
> 
> Restored tree: ttydev.
> 
> Temporarily dropped tree: acpi (confusion about its source).
> 
> Most of the differences were conflicts moving from tree to tree as some
> of the trees are now merged into Linus' tree.  Most have been inflicted
> on the driver-core and usb trees.  I have not notified these separately.
> 
> Because of the moving of conflicts around it is difficult to tell when
> they are going away (though I assume some are).
> 
> The driver-core tree gained a conflict against Linus' tree.
> 
> The usb tree inherited a build fix patch from the pci tree.
> 
> The x86 tree gained a trivial conflict against Linus' tree but it was in
> a commit that is still being reverted.
> 
> The ocsf2 tree gained several conflicts against Linus' tree because what
> was sent to Linus was not the same as what is in linuxt-next.
> 
> The vfs tree gained conflicts against Linus' tree, the sparc tree and the
> mips tree.
> 
> The semaphore-removal tree gained conflicts against Linus' tree that
> required the reversion of two commits.
> 
> The ttydev tree had two patches that didn't apply and gained conflicts
> against the wireless tree and the usb tree (4).  It also required a build
> fix patch.
> 
> Lots of conflicts have gone from the x86 and ubifs trees.
> 
> I have also applied the following patches for known problems:
> 
> 	sparc64: sysdev API change fallout
> 	sparc32: smp_call_function API change fallout (this has already
> been fixed in the upstream sparc tree and comes from an incomplete merge
> on my part).
> 
> This tree fails to build for ARCH=sparc (i.e. 32bit) with a 64bit gcc
> v3.4.5 - it tries to use the 64bit header files.  This may be an artifact
> of one of my merge fixups, but I don't actually think so.
> 
> ----------------------------------------------------------------------------

commit db99b98885e717454feef1c6868b27d3f23c2e7c
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Wed May 14 17:04:16 2008 -0700

    sky2: put PHY in sleep when down

and

commit a068c0adf2fe28b324bca87f85d27af7f993cdaf
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Wed May 14 17:04:17 2008 -0700

    sky2: pci power savings

break Wake-on-LAN on my test box using sky2.  More specifically, with these
two commits applied the box hangs solid during hibernation/power off
while executing the sky2 callbacks.

The adapter is reported as 88E8056 (Asus M3A32-MVP Deluxe mainboard).

Thanks,
Rafael
