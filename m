Return-Path: <linux-kernel-owner+w=401wt.eu-S934451AbYBGVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451AbYBGVAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762706AbYBGUvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:38461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762697AbYBGUvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:48 -0500
Date: Thu, 7 Feb 2008 12:47:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Andersson <jan@gaisler.com>, David Brownell <david-b@pacbell.net>
Subject: [patch 20/45] USB: fix usbtest halt check on big endian systems
Message-ID: <20080207204724.GU16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-usbtest-halt-check-on-big-endian-systems.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Andersson <jan@gaisler.com>

usbtest did not swap the received status information when checking for
a non-zero value and failed to discover halted endpoints on big endian
systems.

Signed-off-by: Jan Andersson <jan@gaisler.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/usbtest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1151,6 +1151,7 @@ static int verify_halted (int ep, struct
 		dbg ("ep %02x couldn't get halt status, %d", ep, retval);
 		return retval;
 	}
+	le16_to_cpus(&status);
 	if (status != 1) {
 		dbg ("ep %02x bogus status: %04x != 1", ep, status);
 		return -EINVAL;

-- 
