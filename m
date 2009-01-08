Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZAHHgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZAHHgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZAHHf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:35:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbZAHHf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:35:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [Regression] USB wakeup problem on Toshiba Portege R500
Date: Thu, 8 Jan 2009 08:35:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Greg KH <greg@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901080835.39639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Unfortunately, the following commit:

commit 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Wed Dec 17 17:20:38 2008 -0500

    USB: automatically enable wakeup for PCI host controllers

    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

causes a regression to appear on my Toshiba Portege R500.

The regression is that when suspended to RAM, the box wakes up immediately
unless 'disabled' is written into the /sys/devices/.../power/wakeup file of the
EHCI controller.  I know of at least 10 different boxes out there that are
going to have similar problems forcing their users to use manual workaround.

Also, it wakes up on a USB mouse activity, which I don't want it to do, so in
fact I have to write 'disabled' to the /sys/devices/.../power/wakeup files of
all USB controllers.

I'm not sure if the commit went into the right direction.

Thanks,
Rafael
