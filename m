Return-Path: <linux-kernel-owner+w=401wt.eu-S1751109AbXBUBpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbXBUBpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbXBUBjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:39:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:34608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXBUBjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:39:17 -0500
Date: Tue, 20 Feb 2007 17:37:55 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch 12/21] bcm43xx: Fix for oops on resume
Message-ID: <20070221013755.GM30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bcm43xx-fix-for-oops-on-resume.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

There is a kernel oops on bcm43xx when resuming due to an overly tight timeout loop.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/bcm43xx/bcm43xx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.4.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ linux-2.6.19.4/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -21,7 +21,7 @@
 #define PFX				KBUILD_MODNAME ": "
 
 #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
-#define BCM43xx_IRQWAIT_MAX_RETRIES	50
+#define BCM43xx_IRQWAIT_MAX_RETRIES	100
 
 #define BCM43xx_IO_SIZE			8192
 

--
