Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYD2RUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYD2RUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYD2RUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:42765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYD2RT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:19:59 -0400
Date: Tue, 29 Apr 2008 10:17:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [01/37] USB: log an error message when USB enumeration fails
Message-ID: <20080429171750.GB14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-log-an-error-message-when-usb-enumeration-fails.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Alan Stern <stern@rowland.harvard.edu>

commit: 6427f7995338387ddded92f98adec19ddbf0ae5e

This patch (as1077) logs an error message whenever the kernel is
unable to enumerate a new USB device.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2664,6 +2664,7 @@ loop:
 		if ((status == -ENOTCONN) || (status == -ENOTSUPP))
 			break;
 	}
+	dev_err(hub_dev, "unable to enumerate USB device on port %d\n", port1);
  
 done:
 	hub_port_disable(hub, port1, 1);

-- 
