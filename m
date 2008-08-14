Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYHNBfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYHNBfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYHNBfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:35:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39296 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYHNBfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:35:40 -0400
Date: Wed, 13 Aug 2008 18:36:35 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Kent Liu <kent.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH v2] coretemp: Recognize Nehalem CPUs
Message-ID: <20080814013635.GF28450@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20080813225147.GE28450@tree.beaverton.ibm.com> <20080814011100.GB14828@wliu-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814011100.GB14828@wliu-linux.bj.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in the CPUID for Nehalem chips.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/coretemp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 70239ac..93c1722 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -413,10 +413,11 @@ static int __init coretemp_init(void)
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
 
-		/* check if family 6, models 0xe, 0xf, 0x16, 0x17 */
+		/* check if family 6, models 0xe, 0xf, 0x16, 0x17, 0x1A */
 		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
 		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-			(c->x86_model == 0x16) || (c->x86_model == 0x17))) {
+			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
+			(c->x86_model == 0x1A))) {
 
 			/* supported CPU not found, but report the unknown
 			   family 6 CPU */
