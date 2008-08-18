Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYHRSvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYHRSvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759500AbYHRSue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:50:34 -0400
Received: from ns1.suse.de ([195.135.220.2]:41695 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759494AbYHRSuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:50:32 -0400
Date: Mon, 18 Aug 2008 11:42:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 14/60] USB: fix interface unregistration logic
Message-ID: <20080818184252.GO29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-interface-unregistration-logic.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 1a21175a615ed346e8043f5e9d60a672266b84b4 upstream


This patch (as1122) fixes a bug: When an interface is unregistered,
its children (sysfs files and endpoint devices) are unregistered after
it instead of before.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1091,8 +1091,8 @@ void usb_disable_device(struct usb_devic
 				continue;
 			dev_dbg(&dev->dev, "unregistering interface %s\n",
 				interface->dev.bus_id);
-			device_del(&interface->dev);
 			usb_remove_sysfs_intf_files(interface);
+			device_del(&interface->dev);
 		}
 
 		/* Now that the interfaces are unbound, nobody should

-- 
