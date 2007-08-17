Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbXHQNEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbXHQNEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 09:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbXHQNEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 09:04:24 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:63297 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640AbXHQNEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 09:04:23 -0400
Date: Fri, 17 Aug 2007 15:05:10 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch] encapsulate uevent()/add_uevent_var() buffer handling
Message-ID: <20070817150510.2e25ca15@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1187097312.4312.21.camel@lov.localdomain>
References: <20070813143711.GA24536@s15225674.onlinehome-server.info>
	<20070813211750.GA16120@suse.de>
	<1187097312.4312.21.camel@lov.localdomain>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 15:15:12 +0200,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver core: change add_uevent_var to use a struct

This still needs some (trivial) s390 fixes:

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/cio/device.c    |    2 --
 drivers/s390/crypto/ap_bus.c |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.orig/drivers/s390/crypto/ap_bus.c
+++ linux-2.6/drivers/s390/crypto/ap_bus.c
@@ -458,7 +458,7 @@ static int ap_bus_match(struct device *d
  * uevent function for AP devices. It sets up a single environment
  * variable DEV_TYPE which contains the hardware device type.
  */
-static int ap_uevent (struct device *dev, struct kobj_uevent_env)
+static int ap_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
 	int retval = 0;
--- linux-2.6.orig/drivers/s390/cio/device.c
+++ linux-2.6/drivers/s390/cio/device.c
@@ -82,8 +82,6 @@ static int ccw_uevent(struct device *dev
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
 	struct ccw_device_id *id = &(cdev->id);
-	int i = 0;
-	int len = 0;
 	int ret;
 	char modalias_buf[30];
 
