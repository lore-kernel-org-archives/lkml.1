Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZIZOSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZIZOSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZIZOR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:17:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:53533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbZIZOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:17:58 -0400
Date: Sat, 26 Sep 2009 14:17:31 GMT
From: tip-bot for Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
       kaneshige.kenji@jp.fujitsu.com, paulmck@linux.vnet.ibm.com,
       dhowells@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
       kaneshige.kenji@jp.fujitsu.com, paulmck@linux.vnet.ibm.com,
       dhowells@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ABC4CAB.7090302@np.css.fujitsu.com>
References: <4ABC4CAB.7090302@np.css.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Clean up the warning message about RCU not defined
Message-ID: <tip-5ef9b8e59c043624fb44e31439cecf7f8b4cd62a@git.kernel.org>
Git-Commit-ID: 5ef9b8e59c043624fb44e31439cecf7f8b4cd62a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 26 Sep 2009 14:17:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ef9b8e59c043624fb44e31439cecf7f8b4cd62a
Gitweb:     http://git.kernel.org/tip/5ef9b8e59c043624fb44e31439cecf7f8b4cd62a
Author:     Jin Dongming <jin.dongming@np.css.fujitsu.com>
AuthorDate: Fri, 25 Sep 2009 13:52:59 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 26 Sep 2009 14:33:41 +0200

rcu: Clean up the warning message about RCU not defined

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
Reviewed-by: "Paul E. McKenney " <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org
Cc: David Howells <dhowells@redhat.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
LKML-Reference: <4ABC4CAB.7090302@np.css.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
