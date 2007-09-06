Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXIFBaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXIFBaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 21:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbXIFB35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 21:29:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:60929 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300AbXIFB34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 21:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,213,1186383600"; 
   d="scan'208";a="294508298"
Date: Thu, 6 Sep 2007 09:28:52 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
Message-ID: <20070906012852.GA8058@zhen-devel.sh.intel.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
References: <20070905071152.GA5817@zhen-devel.sh.intel.com> <20070905081937.35965e97.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070905081937.35965e97.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.22-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.09.05 08:19:37 +0000, Randy Dunlap wrote:
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Thanks Randy. Here's updated patch with typo and tab style
fixed. I misused x style.

Subject: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33

G33 GTT stolen memory is below graphics data
stolen memory and be seperate, so don't subtract
it in stolen mem counting.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 2c9ca2c..581f922 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -506,6 +506,11 @@ static void intel_i830_init_gtt_entries(void)
 			break;
 		}
 	} else {
+		/* G33's GTT stolen memory is separate from gfx data
+		 * stolen memory.
+		 */
+		if (IS_G33)
+			size = 0;
 		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
 		case I855_GMCH_GMS_STOLEN_1M:
 			gtt_entries = MB(1) - KB(size);
-- 
1.5.2.3
