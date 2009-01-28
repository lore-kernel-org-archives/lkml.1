Return-Path: <linux-kernel-owner+w=401wt.eu-S1763585AbZA2Aap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763585AbZA2Aap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759655AbZA1Xu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:50:56 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:37190 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759639AbZA1Xuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:50:54 -0500
X-Trace: 138163101/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAP59gElQLLDG/2dsb2JhbACBbsoLhUcG
X-IronPort-AV: E=Sophos;i="4.37,340,1231113600"; 
   d="scan'208";a="138163101"
Subject: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and
 clean up maple bus driver (0/3)
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       linux-mtd <linux-mtd@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 23:47:36 +0000
Message-Id: <1233186456.6734.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for the SEGA Dreamcast VMU and clean up the
maple bus driver, allowing it to support block devices and ensuring it
supports concurrent reads and writes eg no more mixing up which thread
locks and unlocks a mutex etc.

A consequential fix for the maple keyboard driver is also attached.

The VMU is added as an MTD (mapping) device. It's flash but its is also
"smart" so could have conceivably been added as a general block device
but it transpires that as well as actually being based on flash, it
displays behaviour on plugging and unplugging and on writing that make
the MTD block layer a good fit (namely the MTD block layer's insistence
on carrying on after a perceived hotplug event).

I posted an earlier set of patches in Spring 2008 and given the
difficulties with them these are posted here for review and comment
rather than as a simple request for inclusion as is.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

