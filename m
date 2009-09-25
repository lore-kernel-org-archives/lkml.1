Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbZIYEwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbZIYEwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZIYEws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:52:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55776 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZIYEwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:52:47 -0400
Message-ID: <4ABC4CAB.7090302@np.css.fujitsu.com>
Date: Fri, 25 Sep 2009 13:52:59 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney " <paulmck@linux.vnet.ibm.com>,
       =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [Patch x86-tip] Clean up the warning message about RCU not defined
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This fix is for commit 4765c1db84c73f775eb1822a009117cbae524e9e
   Titled "rcu-tiny: The Bloatwatch Edition, v6")

When the kernel is built, there is some message printed as
following:
    include/linux/rcupdate.h:80:7: \
        warning: "CONFIG_TINY_RCU" is not defined

So I did "grep _RCU .config" to search the information of "CONFIG_TINY_RCU"
in .config file and the result is listed as following:
    Command:
        grep _RCU .config
    Result:
        CONFIG_TREE_RCU=y
        # CONFIG_TREE_PREEMPT_RCU is not set
        # CONFIG_TINY_RCU is not set
        CONFIG_RCU_TRACE=y
        CONFIG_RCU_FANOUT=64
        # CONFIG_RCU_FANOUT_EXACT is not set
        CONFIG_TREE_RCU_TRACE=y
        # CONFIG_RCU_TORTURE_TEST is not set
        # CONFIG_RCU_CPU_STALL_DETECTOR is not set

Though the "WARNING" does not give impact to build kernel, I think
it should be cleaned up. And I made the patch for modifying it.
With this patch there is not any other warning message of
CONFIG_TINY_RCU and the kernel could be built successfully. And I
confirmed that the built kernel works well.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 include/linux/rcupdate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b2f1e10..fe5c560 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -77,7 +77,7 @@ extern int rcu_scheduler_active;
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
-#elif CONFIG_TINY_RCU
+#elif defined(CONFIG_TINY_RCU)
 #include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
-- 
1.6.2.2

