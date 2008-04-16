Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbYDPF5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbYDPF5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYDPF5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:57:33 -0400
Received: from ns1.suse.de ([195.135.220.2]:36049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYDPF5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:57:32 -0400
Date: Tue, 15 Apr 2008 23:03:39 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.25-rc9 git
Message-ID: <20080416060338.GA4713@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB device ids updates and one bugfix against your
2.6.25-rc9 git tree.

They include:
	- new device ids for the option driver
	- usb-storage unusual devs for a bunch of Huawei devices
	- bugfix to usb-serial core removing a restrictive check that
	  has broken a lot of different devices.

It's the last thing that's the most important, making the check this
strict has broken lots of different devices for lots of users, and we
are slowly getting a lot of regression reports for this.  This patch
fixes all of them for all usb-serial drivers.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

Most of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/serial/option.c        |   56 ++++++++++++++++++++-
 drivers/usb/serial/usb-serial.c    |    2 
 drivers/usb/storage/unusual_devs.h |   96 +++++++++++++++++++++++++++++++++++--
 3 files changed, 148 insertions(+), 6 deletions(-)

---------------

Greg Kroah-Hartman (1):
      USB: remove broken usb-serial num_endpoints check

James Cameron (1):
      USB: Obscure Maxon BP3-USB Device Support 16d8:6280 for option driver

Matthias Urlichs (1):
      USB: option.c: add more device IDs

fangxiaozhi (1):
      USB: support more Huawei data card product IDs

tang kai (1):
      USB: option: Add new vendor ID and device ID for AMOI HSDPA modem

