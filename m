Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbXIXQ2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbXIXQ2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759793AbXIXQZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47261 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458AbXIXQZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:16 -0400
Date: Mon, 24 Sep 2007 09:20:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nathael Pajani <nathael.pajani@cpe.fr>
Subject: [09/50] USB: fix linked list insertion bugfix for usb core
Message-ID: <20070924162016.GJ13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-linked-list-insertion-bugfix-for-usb-core.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Nathael Pajani <nathael.pajani@cpe.fr>

commit e5dd01154c1e9ca2400f4682602d1a4fa54c25dd in mainline.

This patch fixes the order of list_add_tail() arguments in
usb_store_new_id() so the list can have more than one single element.

Signed-off-by: Nathael Pajani <nathael.pajani@cpe.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -58,7 +58,7 @@ ssize_t usb_store_new_id(struct usb_dyni
 	dynid->id.match_flags = USB_DEVICE_ID_MATCH_DEVICE;
 
 	spin_lock(&dynids->lock);
-	list_add_tail(&dynids->list, &dynid->node);
+	list_add_tail(&dynid->node, &dynids->list);
 	spin_unlock(&dynids->lock);
 
 	if (get_driver(driver)) {

-- 
