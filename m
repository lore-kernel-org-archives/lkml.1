Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYE0GcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYE0GcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYE0GcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:32:05 -0400
Received: from mail.suse.de ([195.135.220.2]:53154 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbYE0GcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:32:04 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 May 2008 16:31:53 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@kernel.org>
Subject: [PATCH 000 of 3] md: raid5 patches suitable for 2.6.26 and -stable
Message-ID: <20080527162558.16305.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are three patches that fixes bugs in raid5 that could
conceivable cause data corruption (1 and 3) or and oops (2).

Bugs 1 and 3 can cause a 'resync' to mistakenly think the partiy block
is correct when infact it isn't (it looks at a parity block that was
generated rather than read from disk).  If this happens to leave a
parity block wrong, and a device then fails, data regenerated based on
that parity block will be wrong.

Once a patched kernel is installed, running a repair pass 
(echo repair > .../sync_action) will fix any incorrect parity.

The Oops (patch 2) can only happen if you right to a partucular sysfs
file that only root has access to and only developer (currently) have
any reason to write to.

NeilBrown

 [PATCH 001 of 3] md: md: fix prexor vs sync_request race
 [PATCH 002 of 3] md: fix uninitialized use of mddev->recovery_wait
 [PATCH 003 of 3] md: Do not compute parity unless it is on a failed drive
