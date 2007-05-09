Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbXEIXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbXEIXlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757837AbXEIXk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:40:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:40469 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbXEIXk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:40:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="85474311"
Date: Wed, 9 May 2007 16:37:56 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: [patch 0/7] Asynchronous Notification for ATAPI devices (resend)
Message-Id: <20070509163756.dd8136c7.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
Here are the AN patches again, they have not changed with the exception
of patch #1, which does set the host flag in board_ahci and board_ahci_pi
now (thanks Tejun).

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
