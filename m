Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYKZMh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYKZMh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKZMhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:37:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:38469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYKZMhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:37:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,668,1220252400"; 
   d="scan'208";a="83146823"
Date: Wed, 26 Nov 2008 20:36:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH] markers: comment usage of marker_synchronize_unregister()
Message-ID: <20081126123652.GA9446@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more comments to marker_synchronize_unregister() in order to
reduce the chance of misusing.

Based on comments from Lai Jiangshan <laijs@cn.fujitsu.com>.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---

I'm still not sure about the last sentence. Can anyone clarify on
this? Thanks!

diff --git a/include/linux/marker.h b/include/linux/marker.h
index 889196c..89ce1b8 100644
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -164,6 +164,12 @@ extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
  * marker_synchronize_unregister must be called between the last marker probe
  * unregistration and the end of module exit to make sure there is no caller
  * executing a probe when it is freed.
+ *
+ * It must be called _also_ between unregistration and destruction the data
+ * that unregistration-ed probes need to make sure there is no caller executing
+ * a probe when it's data is destroyed.
+ *
+ * It works reliably only when all probe routines do not sleep and reschedule.
  */
 #define marker_synchronize_unregister() synchronize_sched()
 
