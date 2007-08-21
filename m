Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbXHUGwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbXHUGwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbXHUGwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:52:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51464 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbXHUGwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:52:21 -0400
Date: Mon, 20 Aug 2007 23:53:44 -0700
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
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 02/20] hwmon: (smsc47m1) restore missing name attribute
Message-ID: <20070821065344.GC5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-restore-missing-name-attribute.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

The smsc47m1 driver no longer creates the name attribute used by
libsensors to identify chip types. It was lost during the conversion
to a platform driver. I was fooled by the fact that we do have a
group with all attributes, but only to delete them all at once. The
group is not used to create the attributes, so we have to explicitly
create the name attribute.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/smsc47m1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -585,6 +585,8 @@ static int __devinit smsc47m1_probe(stru
 
 	if ((err = device_create_file(dev, &dev_attr_alarms)))
 		goto error_remove_files;
+	if ((err = device_create_file(dev, &dev_attr_name)))
+		goto error_remove_files;
 
 	data->class_dev = hwmon_device_register(dev);
 	if (IS_ERR(data->class_dev)) {

-- 
