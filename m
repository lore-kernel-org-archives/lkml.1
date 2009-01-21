Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbZAUFUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbZAUFUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZAUFUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:20:24 -0500
Received: from kroah.org ([198.145.64.141]:53310 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802AbZAUFUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:20:24 -0500
Date: Tue, 20 Jan 2009 21:18:55 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: [GIT PATCH] driver core fixes for your 2.6-git tree
Message-ID: <20090121051855.GA3665@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 5 bugfixes against your current kernel git tree.

They fix the following reported problems:
	- klist blowing up on CRIS architecture
	- some block device names showing up incorrectly due to
	  mishandled ! formatting
	- sysfs binary file bugfix
	- debugfs build breakage if it is disable and wimax is enabled.
	- PNP modules not properly being autoloaded due to lowercase
	  issues in file2alias.c

All of these have been in the last -next release, with the majority of
them in the -next releases for the past week.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/core.c      |    6 ++++++
 fs/sysfs/bin.c           |    6 ++++++
 include/linux/debugfs.h  |    7 +++++++
 include/linux/klist.h    |    2 +-
 scripts/mod/file2alias.c |   17 +++++++++++++++--
 5 files changed, 35 insertions(+), 3 deletions(-)

---------------

Greg Kroah-Hartman (1):
      sysfs: fix problems with binary files

Inaky Perez-Gonzalez (1):
      debugfs: introduce stub for debugfs_create_size_t() when DEBUG_FS=n

Jesper Nilsson (1):
      klist.c: bit 0 in pointer can't be used as flag

Kay Sievers (1):
      PNP: fix broken pnp lowercasing for acpi module aliases

Roland Dreier (1):
      driver core: Convert '/' to '!' in dev_set_name()

