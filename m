Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZJPR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZJPR0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZJPRS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:26 -0400
Received: from kroah.org ([198.145.64.141]:48498 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbZJPRSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:24 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:55 2009
Message-Id: <20091016171155.269801577@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joris van Rantwijk <jorispubl@xs4all.nl>,
       Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [17/46] USB: Fix throttling in generic usbserial driver
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-fix-throttling-in-generic-usbserial-driver.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joris van Rantwijk <jorispubl@xs4all.nl>

commit 63a9609513007537a0b23ac511fd73f9bd609ea0 upstream.

The generic usbserial driver in Linux 2.6.31 halts its receiving
channel in response to throttle requests from the line discipline.
Unfortunately it drops the contents of the first URB received after
throttling takes effect. This patch corrects that problem.

Signed-off-by: Joris van Rantwijk <jorispubl@xs4all.nl>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -530,7 +530,7 @@ void usb_serial_generic_unthrottle(struc
 
 	if (was_throttled) {
 		/* Resume reading from device */
-		usb_serial_generic_resubmit_read_urb(port, GFP_KERNEL);
+		flush_and_resubmit_read_urb(port);
 	}
 }
 


