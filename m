Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYFFJZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYFFJZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYFFJYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:24:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35445 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYFFJYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:24:52 -0400
Date: Fri, 6 Jun 2008 11:25:46 +0200
From: Pavel Machek <pavel@suse.cz>
To: stern@rowland.harvard.edu, gregkh@suse.de, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Cc: Oliver Neukum <oliver@neukum.org>
Subject: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Message-ID: <20080606092546.GA2596@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In 2.6.26-rc5, 

-config USB_PERSIST
-       bool "USB device persistence during system suspend (DANGEROUS)"

is now on. Given that it was previously marked "DANGEROUS", that seems
quite a change to me.

-
-               WARNING: This option can be dangerous!
-
-         If a USB device is replaced by another of the same type while
-         the system is asleep, there's a good chance the kernel won't
-         detect the change.  Likewise if the media in a USB storage
-         device is replaced.  When this happens it's almost certain to
-         cause data corruption and maybe even crash your system.
-
-         If you are unsure, say N here.

Besides, it seems to have broken usblp hibernation support, and maybe
other devices that does not have reset_resume() present. (Big thanks
for Oliver for doing investigation).

[Or is it that now USB_PERSIST is conditional on /sys fs setting, so
while setting it on individual device is dangerous, it is still N by
default? Changelog does not tell me...?]

Commit is:

USB: remove CONFIG_USB_PERSIST setting

This patch (as1047) removes the USB_PERSIST Kconfig option, enabling
it permanently.  It also prevents the power/persist attribute from
being created for hub devices; there's no point in having it since
USB-PERSIST is always turned on for hubs.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

								Pavel
---
commit feccc30d90155bcbc937f87643182a43d25873eb
tree 96394e24075a885f1a8bb3e53203f8397e78ea46
parent 5e6effaed6da94e727cd45f945ad2489af8570b3
author Alan Stern <stern@rowland.harvard.edu> Mon, 03 Mar 2008 15:15:59 -0500
committer Greg Kroah-Hartman <gregkh@suse.de> Thu, 24 Apr 2008 21:16:32 -0700



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
