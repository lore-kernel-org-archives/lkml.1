Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZAAQHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZAAQHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 11:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZAAQHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 11:07:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:1117 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbZAAQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 11:07:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MLdYoj7QkATwgy5d00IXXLiZ2v7MBp3bHYDIA8VEdId32UvnHc8OimABzKIo/p51uR
         ROJuJhAplWhko35WXwLV+otHMn2zCl43XNV6j3DQ9V88fW/SdpSQa9G7OXKgHrX3xMKV
         tdjE9BpwTOfHi1LLmyPsjadIx0ihMz7GE1GSE=
Date: Fri, 2 Jan 2009 00:07:27 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] enable CONFIG_USB_SUSPEND by default
Message-ID: <20090101160727.GA4390@thyme.bj.intel.com>
Mail-Followup-To: gregkh@suse.de, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090101160343.GA4278@thyme.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some USB devices need to be put into suspend mode before
unplugging. Without CONFIG_USB_SUSPEND we have no way to unplug them
safely.

Signed-off-by: Yan Li <elliot.li.tech@gmail.com>
---
 drivers/usb/core/Kconfig |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index e1759d1..457ee9d 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -89,18 +89,20 @@ config USB_DYNAMIC_MINORS
 config USB_SUSPEND
 	bool "USB selective suspend/resume and wakeup"
 	depends on USB && PM
+	default y
 	help
 	  If you say Y here, you can use driver calls or the sysfs
 	  "power/level" file to suspend or resume individual USB
-	  peripherals and to enable or disable autosuspend (see
-	  Documentation/usb/power-management.txt for more details).
+	  peripherals and to enable or disable autosuspend. Some USB
+	  devices need to be put into suspend mode before unplugging
+	  (see Documentation/usb/power-management.txt for more details).
 
 	  Also, USB "remote wakeup" signaling is supported, whereby some
 	  USB devices (like keyboards and network adapters) can wake up
 	  their parent hub.  That wakeup cascades up the USB tree, and
 	  could wake the system from states like suspend-to-RAM.
 
-	  If you are unsure about this, say N here.
+	  If you are unsure about this, say Y here.
 
 config USB_OTG
 	bool
-- 
1.5.6.5


-- 
Li, Yan
