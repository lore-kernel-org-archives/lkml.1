Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXJ2OmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXJ2OmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXJ2OmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:42:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50492 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbXJ2OmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:42:08 -0400
To: LKML <linux-kernel@vger.kernel.org>,
       Linux-SCSI <linux-scsi@vger.kernel.org>
Message-Id: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH v4 0/2] [SCSI] Asynchronous event notification infrastructure
Date: Mon, 29 Oct 2007 10:42:07 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next revision of the SCSI event notification infrastructure
patchset, enabling SATA Asynchronous Notification ("AN") for CD/DVD
devices that support it.

For devices that support SATA AN (only very recent ones do), this means
that HAL and other userspace utilities no longer need to repeatedly poll
the CD/DVD device to determine if the user has changed the media.

This revision takes into account James' comments from earlier today,
modulo the following notes:

* I think the various event attributes should always be present,
  for all devices at all times.  If various events are not supported,
  the attribute will of course return zero (false, not supported).

* I do not think this work should be blocked behind a revamp
  of the attribute group interface.

* I was slack and did not bother to implement the 'set' operation
  for the attributes.  This can easily be done at a later time in a
  separate patch.  It is not a merge stopper to have the driver
  exclusively control the event mask, rather than driver+sysfs.

