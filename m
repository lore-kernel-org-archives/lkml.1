Return-Path: <linux-kernel-owner+w=401wt.eu-S1031488AbXEDSPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031488AbXEDSPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031494AbXEDSPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:15:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:11277 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031488AbXEDSOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:14:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,493,1170662400"; 
   d="scan'208";a="239391348"
Date: Fri, 4 May 2007 11:12:22 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org
Subject: [patch 0/7] Asynchronous Notification for ATAPI devices (v2) -
 resend
Message-Id: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements Asynchronous Notification (AN) for SATA
ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
which support this feature will send a notification when new media is
inserted and removed, preventing the need for user space to poll for
new media.  This support is exposed to user space via a flag that will
be set in /sys/block/sr*/capability_flags.  If the flag is set, user
space can disable polling for the new media, and the genhd driver will
send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.

Note that this patch only implements support for directly attached
drives - AN with drives attached to a port multiplier requires 
additional changes.

Thanks!
Kristen

-- 
-- 
