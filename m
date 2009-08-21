Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbZHUVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbZHUVgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbZHUVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:36:09 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59092 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955AbZHUVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:36:02 -0400
Date: Fri, 21 Aug 2009 13:59:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] staging/iio: fix duplicate dev_attr_name
Message-Id: <20090821135908.259b222f.randy.dunlap@oracle.com>
In-Reply-To: <20090821164140.71968b47.sfr@canb.auug.org.au>
References: <20090821164140.71968b47.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A8F1321.00DF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

device attr's should be static, otherwise duplicate identifiers are
created:

drivers/staging/iio/trigger/iio-trig-gpio.o:(.data+0x1c): multiple definition of `dev_attr_name'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/iio/accel/lis3l02dq_ring.c          |    2 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c         |    2 +-
 drivers/staging/iio/trigger/iio-trig-periodic-rtc.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20090821.orig/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ linux-next-20090821/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -441,7 +441,7 @@ static int lis3l02dq_data_rdy_trigger_se
 				 &t);
 	return ret;
 }
-DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
 
 static struct attribute *lis3l02dq_trigger_attrs[] = {
 	&dev_attr_name.attr,
--- linux-next-20090821.orig/drivers/staging/iio/trigger/iio-trig-gpio.c
+++ linux-next-20090821/drivers/staging/iio/trigger/iio-trig-gpio.c
@@ -46,7 +46,7 @@ static irqreturn_t iio_gpio_trigger_poll
 	return IRQ_HANDLED;
 }
 
-DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
 
 static struct attribute *iio_gpio_trigger_attrs[] = {
 	&dev_attr_name.attr,
--- linux-next-20090821.orig/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
+++ linux-next-20090821/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
@@ -81,10 +81,10 @@ static ssize_t iio_trig_periodic_read_na
 	return sprintf(buf, "%s\n", trig_info->name);
 }
 
-DEVICE_ATTR(name, S_IRUGO,
+static DEVICE_ATTR(name, S_IRUGO,
 	    iio_trig_periodic_read_name,
 	    NULL);
-DEVICE_ATTR(frequency, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(frequency, S_IRUGO | S_IWUSR,
 	    iio_trig_periodic_read_freq,
 	    iio_trig_periodic_write_freq);
 



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
