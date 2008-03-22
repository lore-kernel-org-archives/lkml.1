Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYCVRn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYCVRn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYCVRnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:43:50 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:4202 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754266AbYCVRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:43:49 -0400
X-Trace: 690560147/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAFAHvi5EdRAVlC/2dsb2JhbACBW6ZMghI
Subject: [PATCH] 0/3 - Add support for VMU flash memory and update maple
	bus driver on the SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: dwmw2 <dwmw2@infradead.org>, Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       Paul Mundt <lethal@users.sourceforge.net>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 17:43:25 +0000
Message-Id: <1206207805.6324.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, second iteration of this - have added more comments and, I hope,
addressed all or nearly all of people's comments.

This adds support for the flash memory portion of the "visual memory
unit" on the SEGA Dreamcast.

Changelogs on the patches but, in summary:

On the maple bus side: 

- adds a mutex to ensure device is only addressed once per maple bus
cycle (and so avoiding corruption of the linked list of packets waiting
for transmission).

- properly uses the existing lock on the waiting packet queue and cleans
up the way the linked lists (of waiting and processed packets) are
handled.

For the device:

- relies on the mutex to ensure block reads and writes are handled
properly - normally the bus driver will unlock the mutex once a waiting
packet has been processed

- implements support for partitions. There are rumours such devices
exist - they are supported in the specification. But I've never seen
one!


There is code to follow (eventually) to implement the FAT based
filesystem used by the Dreamcast to save to these devices, but they
should be usable as small flash devices with other filesystems too.

(See http://mc.pp.se/dc/vms/flashmem.html for more details on the
hardware etc)

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


