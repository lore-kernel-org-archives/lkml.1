Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYBKQ40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYBKQ40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbYBKQ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:56:10 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:22783 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756450AbYBKQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:56:07 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Mon, 11 Feb 2008 17:53:18 +0100
From: "Hans Rosenfeld" <hans.rosenfeld@amd.com>
To: "Matt Mackall" <mpm@selenic.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] /proc/pid/pagemap: fix PM_SPECIAL macro
Message-ID: <20080211165318.GA10660@escobedo.amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 11 Feb 2008 16:52:30.0126 (UTC)
 FILETIME=[7D4C14E0:01C86CCE]
X-WSS-ID: 6BAEA20D2IW11140398-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a bug in the PM_SPECIAL macro for /proc/pid/pagemap.
I think masking out those other bits makes more sense then setting all
those mask bits.


Signed-off-by: Hans Rosenfeld <Hans.Rosenfeld@amd.com>

---
 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ae4d3f2..2e8a6fa 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -531,7 +531,7 @@ struct pagemapread {
 #define PM_RESERVED_BITS    3
 #define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
 #define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
-#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
+#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) & PM_RESERVED_MASK)
 #define PM_NOT_PRESENT      PM_SPECIAL(1LL)
 #define PM_SWAP             PM_SPECIAL(2LL)
 #define PM_END_OF_BUFFER    1
-- 
1.5.3.7


