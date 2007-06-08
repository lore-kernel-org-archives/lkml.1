Return-Path: <linux-kernel-owner+w=401wt.eu-S938627AbXFHHhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938627AbXFHHhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967683AbXFHHXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:43 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58402 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967646AbXFHHXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:41 -0400
Message-Id: <20070608072156.190709000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 13/54] hpt366: dont check enablebits for HPT36x
Content-Disposition: inline; filename=hpt366-don-t-check-enablebits-for-hpt36x.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

HPT36x chip don't seem to have the channel enable bits, so prevent the IDE core
from checking them...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: <bzolnier@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
This has been an issue since 2.6.21-rc1...

 drivers/ide/pci/hpt366.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.21.4.orig/drivers/ide/pci/hpt366.c
+++ linux-2.6.21.4/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.02	Apr 18, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.03	May 4, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -1527,7 +1527,12 @@ static int __devinit init_setup_hpt366(s
 	if (rev > 2)
 		goto init_single;
 
+	/*
+	 * HPT36x chips are single channel and
+	 * do not seem to have the channel enable bit...
+	 */
 	d->channels = 1;
+	d->enablebits[0].reg = 0;
 
 	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
 	  	u8  pin1 = 0, pin2 = 0;

-- 
