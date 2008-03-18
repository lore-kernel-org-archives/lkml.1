Return-Path: <linux-kernel-owner+w=401wt.eu-S934280AbYCSVy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbYCSVy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbYCSUV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:21:28 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:40638 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438AbYCSUVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:21:25 -0400
X-Greylist: delayed 2160 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 16:21:18 EDT
X-Trace: 679559918/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQFAIPf30dRAVlC/2dsb2JhbACBWqdYgg8
Subject: [PATCH] 0/2 Add support for maple "Visual Memory Unit" on SEGA
	Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: dwmw2@infradead.org, Greg KH <greg@kroah.com>,
       Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>,
       linux-mtd@vger.kernel.org
Content-Type: text/plain
Date: Tue, 18 Mar 2008 22:30:13 +0000
Message-Id: <1205879413.6250.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VMU is a small (approx 128K) hotpluggable flash device on the SEGA Dreamcast.

To get this to work I have had to rewrite parts of the maple bus driver - some of that
is bug fixing (in the sense that the bus driver was not allowing proper probing, just
forcing the load of the appropriate driver) - the main functional change is to add a
semaphore to the maple device (to ensure that devices can properly inject maple packets
into the queue of packets waiting to be dispatched via DMA to the devices themselves).

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


 drivers/mtd/maps/Kconfig     |   14 +
 drivers/mtd/maps/Makefile    |    1 +
 drivers/mtd/maps/vmu_flash.c |  746 ++++++++++++++++++++++++++++++++++++++++++
 drivers/sh/maple/maple.c     |  113 ++++---
 include/linux/maple.h        |    2 +


