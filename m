Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbXIMCeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbXIMCeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 22:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbXIMCdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 22:33:55 -0400
Received: from rtr.ca ([76.10.145.34]:3636 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbXIMCdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 22:33:54 -0400
Message-ID: <46E8A18C.8080607@rtr.ca>
Date: Wed, 12 Sep 2007 22:33:48 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>, Paolo Ornati <ornati@fastwebnet.it>,
       linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] spontaneous disconnect with "usb-storage:	implement
 autosuspend"
References: <20070814131557.5653d991@localhost> <200708141746.16958.oliver@neukum.org> <20070814183857.28997de1@localhost> <200708142033.23158.oliver@neukum.org> <46E864AC.1020000@rtr.ca> <20070912234016.GA455@kroah.com>
In-Reply-To: <20070912234016.GA455@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>
> There are many regressions right now, _ONLY_ if you enable
> CONFIG_USB_SUSPEND.  If you disable that, your problems will go away,
> right?
..
> Oh, and currently no distro will enable this option due to the hardware
> problems, so the only people that could get hit by this are those who
> build their own kernels, and they can easily disable the option.

Ubuntu has CONFIG_USB_SUSPEND=y

There are probably lots of other distros that use it as well.

This new behaviour (failed operation of USB flash keys) is a *new* regression
in 2.6.23, and we still have time to fix it by either reverting the changed
functionality, or by changing the code to default OFF.

Here's my patch for 2.6.23-rc6+ :

Fix USB Storage failures.

Signed-Off-By:  Mark Lord <mlord@pobox.com>
---

--- linux/drivers/usb/storage/usb.c.orig	2007-09-11 11:52:14.000000000 -0400
+++ linux/drivers/usb/storage/usb.c	2007-09-12 18:18:35.000000000 -0400
@@ -1065,7 +1065,7 @@
 	.pre_reset =	storage_pre_reset,
 	.post_reset =	storage_post_reset,
 	.id_table =	storage_usb_ids,
-	.supports_autosuspend = 1,
+	.supports_autosuspend = 0,
 };
 
 static int __init usb_stor_init(void)
