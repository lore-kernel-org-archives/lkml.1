Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZFFCeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZFFCeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 22:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZFFCd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 22:33:59 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:39706 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZFFCd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 22:33:58 -0400
X-IronPort-AV: E=Sophos;i="4.41,314,1241395200"; 
   d="scan'208";a="195713255"
Date: Fri, 5 Jun 2009 19:34:00 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: [PATCH 0/7] initdev:kernel:Introduction to initdev patchset
Message-ID: <20090606023400.GA5562@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In days of yore, great fields of USB devices were discovered and initialized
long before they were harvested for use. Race conditions were unknown, and
all was well. As time passed in the land of Linux, the tilling of the bit
fields yielded great reductions in boot time, and there was much rejoicing.
Yet, some dispaired, for things were not as they had once been. The now-
hasty arrival at /bin/init startup meant some USB devices were not yet fully
ripened, leaving /dev/console unopened and network devices unconfigured.

This patch allows boot-time users of devices specified in kernel command line
parameters to wait until discovery and initialization of those devices.
The kernel command line that specify devices are "ip", "root", and "console".
This code supports device discovery on USB and SCSI buses. It mostly
eliminates the need for the rootwait kernel parameter.

This introduction is followed by 7 patches:
1	Basic initdev infrastructure
2	USB device discovery notification
3	Wait for console
4	Wait for network devices
5	USB and SCSI block device notification
6	Additional SCSI block device notification for asynchronous function
7	Wait for block device used for root

(Many thanks to Alan Stern, who said we could solve this without offensive
timeouts and then set about doing the integration into USB and SCSI)

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---

