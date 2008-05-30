Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYE3CrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYE3CrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 22:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYE3CrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 22:47:04 -0400
Received: from ns.suse.de ([195.135.220.2]:44439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbYE3CrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 22:47:03 -0400
Date: Thu, 29 May 2008 19:46:00 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Message-ID: <20080530024600.GA5860@suse.de>
References: <20080529212110.GA2870@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529212110.GA2870@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 02:21:10PM -0700, Greg KH wrote:
> Here are some USB patches for your 2.6.25-git tree.
> 
> They include:
> 	- bugfixes
> 	- new driver for the isight webcam device to drop firmware into
> 	  it to make it work.  It's very tiny and self-contained.
> 	- new device ids.  Lots of them.  They overshadow the new
> 	  driver, which is pretty funny.
> 	- usb quirks
> 	- usb-storage quirks
> 
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
> 
> All of these patches have been in the -mm tree for a while, as well as
> -next.
> 
> The full patches will be sent to the linux-usb mailing list, if anyone
> wants to see them.

Linus, I've now reverted one of the usb patches in this tree and pushed
it out, so the new diffstat is as follows:

 drivers/usb/core/generic.c         |    5 -
 drivers/usb/core/hcd.h             |    2 +
 drivers/usb/core/hub.c             |   15 ++-
 drivers/usb/core/quirks.c          |    4 +
 drivers/usb/core/sysfs.c           |   44 +++---
 drivers/usb/gadget/fsl_usb2_udc.c  |    2 +
 drivers/usb/host/ehci-au1xxx.c     |    1 +
 drivers/usb/host/ehci-fsl.c        |    7 +-
 drivers/usb/host/ehci-hub.c        |   16 ++-
 drivers/usb/host/ehci-ixp4xx.c     |    4 +-
 drivers/usb/host/ehci-orion.c      |    8 +-
 drivers/usb/host/ehci-pci.c        |    4 +-
 drivers/usb/host/ehci-ppc-of.c     |    2 +
 drivers/usb/host/ehci-ppc-soc.c    |    1 +
 drivers/usb/host/ehci-ps3.c        |    1 +
 drivers/usb/host/ehci-sched.c      |   67 ++++++---
 drivers/usb/host/ehci.h            |    5 +-
 drivers/usb/misc/Kconfig           |   11 ++
 drivers/usb/misc/Makefile          |    1 +
 drivers/usb/misc/isight_firmware.c |  131 ++++++++++++++++++
 drivers/usb/serial/ftdi_sio.c      |  264 +++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio.h      |  265 +++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/option.c        |   34 +++---
 drivers/usb/serial/pl2303.c        |    1 +
 drivers/usb/serial/pl2303.h        |    1 +
 drivers/usb/storage/unusual_devs.h |   10 +-
 26 files changed, 811 insertions(+), 95 deletions(-)
 create mode 100644 drivers/usb/misc/isight_firmware.c


thanks,

greg k-h
