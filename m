Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYDTRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYDTRXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYDTRXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:23:37 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10312 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbYDTRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:23:36 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCH 33/36] IB: convert struct class_device to struct device
References: <20080420104516.GA9225@suse.de>
	<1208688366-9252-33-git-send-email-gregkh@suse.de>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 20 Apr 2008 10:23:34 -0700
In-Reply-To: <1208688366-9252-33-git-send-email-gregkh@suse.de> (Greg
	Kroah-Hartman's message of "Sun, 20 Apr 2008 03:46:03 -0700")
Message-ID: <ada7iesbfu1.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 17:23:34.0953 (UTC) FILETIME=[4352D990:01C8A30B]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like something slipped into the tree as part of my recent
merge... please apply the following patch first if it's not too late, so
this doesn't break the ipath driver build.

Otherwise we can merge this later I guess...
---
IB/ipath: Remove reference to dev->class_dev

Commit 124b4dcb ("IB/ipath: add calls to new 7220 code and enable in
build") inadvertently added core to set dev->class_dev.dev back into
ib_ipath.  This is completely redundant since commit 1912ffbb ("IB: Set
class_dev->dev in core for nice device symlink"), which removed
class_dev setting from low-level drivers, and also will break the build
when class_dev is removed completely from struct ib_device.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/hw/ipath/ipath_verbs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 5734520..8af3b46 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -2067,7 +2067,6 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->phys_port_cnt = 1;
 	dev->num_comp_vectors = 1;
 	dev->dma_device = &dd->pcidev->dev;
-	dev->class_dev.dev = dev->dma_device;
 	dev->query_device = ipath_query_device;
 	dev->modify_device = ipath_modify_device;
 	dev->query_port = ipath_query_port;
