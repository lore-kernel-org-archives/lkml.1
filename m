Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZJBByf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZJBByf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbZJBByE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:54:04 -0400
Received: from kroah.org ([198.145.64.141]:33125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbZJBBdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:14 2009
Message-Id: <20091002012413.977745190@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>
Subject: [051/136] USB: storage: fix a resume path GFP_NOIO must be used
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-storage-fix-a-resume-path-gfp_noio-must-be-used.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Neukum <oliver@neukum.org>

commit e5dc8ae121592239c2a2521d383bcb789849b2a3 upstream.

In the resume path of a block driver GFP_NOIO must be used to
avoid a possible deadlock. The onetouch subdriver of storage violates
the requirement.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/onetouch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -163,7 +163,7 @@ static void usb_onetouch_pm_hook(struct 
 			usb_kill_urb(onetouch->irq);
 			break;
 		case US_RESUME:
-			if (usb_submit_urb(onetouch->irq, GFP_KERNEL) != 0)
+			if (usb_submit_urb(onetouch->irq, GFP_NOIO) != 0)
 				dev_err(&onetouch->irq->dev->dev,
 					"usb_submit_urb failed\n");
 			break;


