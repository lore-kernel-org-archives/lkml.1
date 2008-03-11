Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYCKAnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYCKAnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYCKAnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:43:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:39431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbYCKAnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:43:06 -0400
Date: Mon, 10 Mar 2008 17:42:39 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [GIT PATCH] USB suspend persistance for 2.6.25-rc5 git
Message-ID: <20080311004239.GD17890@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few -rc releases ago you asked about USB storage devices being
persistant across suspend/resume cycles.

Well, Alan Stern has put together a nice small set of patches that do
just this.  Here they are against your 2.6.26-rc5-git tree.

Now I know they are a new "feature" and it's way late in the release
cycle, but you were asking for this a while ago.  I've been beating on
it with my laptops and had no problems at all.

They have been in the past few -mm releases with no reported problems,
as well as the -next tree.

If you want to take them, or just play with them, please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-persist-2.6.git/

The full patches will be sent to the linux-usb and linux-kernel mailing
lists for everyone to see them.

thanks,

greg k-h

------------

 Documentation/usb/persist.txt |   43 ++++---
 drivers/usb/core/Kconfig      |   25 ----
 drivers/usb/core/driver.c     |    9 +-
 drivers/usb/core/hub.c        |  266 +++++++++++++++++++++++++++--------------
 drivers/usb/core/message.c    |    2 +-
 drivers/usb/core/quirks.c     |   14 ++
 drivers/usb/core/sysfs.c      |   22 ++--
 drivers/usb/host/ehci-hub.c   |   15 +--
 drivers/usb/host/ehci-pci.c   |    1 -
 include/linux/usb.h           |    2 +-
 10 files changed, 234 insertions(+), 165 deletions(-)

---------------

Alan Stern (6):
      USB: EHCI: carry out port handover during each root-hub resume
      USB: reorganize code in hub.c
      USB: make USB-PERSIST work after every system sleep
      USB: remove CONFIG_USB_PERSIST setting
      USB: check serial-number string after device reset
      USB: enable USB-PERSIST by default

