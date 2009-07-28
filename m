Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZG1Xt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZG1Xt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZG1Xtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:55 -0400
Received: from kroah.org ([198.145.64.141]:35736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbZG1Xty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:55 2009
Message-Id: <20090728234155.029465877@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [patch 25/71] HID: hiddev, fix lock imbalance
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=hid-hiddev-fix-lock-imbalance.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 4859484b0957ddc7fe3e0fa349d98b0f1c7876bd upstream.

Add omitted BKL to one switch/case.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hiddev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -527,8 +527,10 @@ static noinline int hiddev_ioctl_usage(s
 			goto goodreturn;
 
 		case HIDIOCGCOLLECTIONINDEX:
+			i = field->usage[uref->usage_index].collection_index;
+			unlock_kernel();
 			kfree(uref_multi);
-			return field->usage[uref->usage_index].collection_index;
+			return i;
 		case HIDIOCGUSAGES:
 			for (i = 0; i < uref_multi->num_values; i++)
 				uref_multi->values[i] =


