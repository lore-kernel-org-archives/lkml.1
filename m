Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXIXQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXIXQaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760559AbXIXQZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47352 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760280AbXIXQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:48 -0400
Date: Mon, 24 Sep 2007 09:20:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [16/50] hwmon: End of I/O region off-by-one
Message-ID: <20070924162049.GQ13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-end-of-i-o-region-off-by-one.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

Fix an off-by-one error in the I/O region declaration of two
hardware monitoring drivers (lm78 and w83781d.) We were requesting
one extra port at the end of the region.

This is a regression in 2.6.22 and could prevent other drivers from
loading properly.

Already applied to Linus' tree for 2.6.23:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=15bde2f1a8e819213f54314505a5a0509673109b


Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm78.c    |    2 +-
 drivers/hwmon/w83781d.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -882,7 +882,7 @@ static int __init lm78_isa_device_add(un
 {
 	struct resource res = {
 		.start	= address,
-		.end	= address + LM78_EXTENT,
+		.end	= address + LM78_EXTENT - 1,
 		.name	= "lm78",
 		.flags	= IORESOURCE_IO,
 	};
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1746,7 +1746,7 @@ w83781d_isa_device_add(unsigned short ad
 {
 	struct resource res = {
 		.start	= address,
-		.end	= address + W83781D_EXTENT,
+		.end	= address + W83781D_EXTENT - 1,
 		.name	= "w83781d",
 		.flags	= IORESOURCE_IO,
 	};

-- 
