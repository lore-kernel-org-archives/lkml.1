Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXHUGwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXHUGwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXHUGwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:52:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51457 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbXHUGwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:52:08 -0400
Date: Mon, 20 Aug 2007 23:53:30 -0700
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
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 01/20] hwmon: fix w83781d temp sensor type setting
Message-ID: <20070821065330.GB5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-fix-w83781d-temp-sensor-type-setting.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Mark M. Hoffman" <mhoffman@lightlink.com>

Commit 348753379a7704087603dad403603e825422fd9a introduced a regression that
caused temp2 and temp3 sensor type settings to be written to temp1 instead.
The result is that temp sensor readings could be way off.

Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83781d.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -740,9 +740,9 @@ store_sensor(struct device *dev, struct 
 static SENSOR_DEVICE_ATTR(temp1_type, S_IRUGO | S_IWUSR,
 	show_sensor, store_sensor, 0);
 static SENSOR_DEVICE_ATTR(temp2_type, S_IRUGO | S_IWUSR,
-	show_sensor, store_sensor, 0);
+	show_sensor, store_sensor, 1);
 static SENSOR_DEVICE_ATTR(temp3_type, S_IRUGO | S_IWUSR,
-	show_sensor, store_sensor, 0);
+	show_sensor, store_sensor, 2);
 
 /* I2C devices get this name attribute automatically, but for ISA devices
    we must create it by ourselves. */

-- 
