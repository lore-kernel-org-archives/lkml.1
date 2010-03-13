Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130Ab0CMAVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:21:51 -0500
Received: from kroah.org ([198.145.64.141]:32810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935022Ab0CMAU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:56 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001513.701350020@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [patch 098/123] USB: f_mass_storage: fix crash on bind() error
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit 8e7e61dfbf1ec6418bf89505980b158a8d00d877 upstream.

init_completion() hasn't been called yet and the thread isn't created
if we end up here, so don't call complete() on thread_notifier.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_mass_storage.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2852,7 +2852,6 @@ error_release:
 	/* Call fsg_common_release() directly, ref might be not
 	 * initialised */
 	fsg_common_release(&common->ref);
-	complete(&common->thread_notifier);
 	return ERR_PTR(rc);
 }
 


