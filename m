Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbZGAAza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbZGAAza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761405AbZGAAei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:38 -0400
Received: from kroah.org ([198.145.64.141]:60244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761424AbZGAAef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:22 2009
Message-Id: <20090701002422.510267149@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 031/108] USB: usbtmc: fix switch statment
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=usb-usbtmc-fix-switch-statment.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit a92b63e7e4c185b4dd9e87762e2cb716e54482d0 upstream.

Steve Holland pointed out that we forgot to call break; in the switch
statment.  This probably resolves a lot of the bug reports I've gotten
for the driver lately.

Stupid me...

Reported-by: Steve Holland <sdh4@iastate.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/usbtmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -927,21 +927,27 @@ static long usbtmc_ioctl(struct file *fi
 	switch (cmd) {
 	case USBTMC_IOCTL_CLEAR_OUT_HALT:
 		retval = usbtmc_ioctl_clear_out_halt(data);
+		break;
 
 	case USBTMC_IOCTL_CLEAR_IN_HALT:
 		retval = usbtmc_ioctl_clear_in_halt(data);
+		break;
 
 	case USBTMC_IOCTL_INDICATOR_PULSE:
 		retval = usbtmc_ioctl_indicator_pulse(data);
+		break;
 
 	case USBTMC_IOCTL_CLEAR:
 		retval = usbtmc_ioctl_clear(data);
+		break;
 
 	case USBTMC_IOCTL_ABORT_BULK_OUT:
 		retval = usbtmc_ioctl_abort_bulk_out(data);
+		break;
 
 	case USBTMC_IOCTL_ABORT_BULK_IN:
 		retval = usbtmc_ioctl_abort_bulk_in(data);
+		break;
 	}
 
 	mutex_unlock(&data->io_mutex);


