Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbYFMJ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbYFMJ0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYFMJ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:26:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60624 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYFMJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:26:08 -0400
Date: Fri, 13 Jun 2008 18:31:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 3/6] memcg: reset limit at rmdir
Message-Id: <20080613183105.b3e88c25.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset res_counter's limit to be 0.
Typically called when subysystem which uses res_counter is deleted.
 
Change log: xxx -> v4 (new file)
 - cut out from memg hierarchy patch set(v3).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   11 +++++++++++
 2 files changed, 13 insertions(+)

Index: linux-2.6.26-rc5-mm3/include/linux/res_counter.h
===================================================================
--- linux-2.6.26-rc5-mm3.orig/include/linux/res_counter.h
+++ linux-2.6.26-rc5-mm3/include/linux/res_counter.h
@@ -117,6 +117,8 @@ int __must_check res_counter_charge_lock
 int __must_check res_counter_charge(struct res_counter *counter,
 		unsigned long val);
 
+int res_counter_reset_limit(struct res_counter *counter);
+
 /*
  * uncharge - tell that some portion of the resource is released
  *
Index: linux-2.6.26-rc5-mm3/kernel/res_counter.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/kernel/res_counter.c
+++ linux-2.6.26-rc5-mm3/kernel/res_counter.c
@@ -153,6 +153,17 @@ static int res_counter_resize_limit(stru
 	return ret;
 }
 
+/**
+ * res_counter_reset_limit - reset limit to be 0.
+ * @res: the res_counter to be reset.
+ *
+ * res_counter->limit is resized to be 0. return 0 at success.
+ */
+
+int res_counter_reset_limit(struct res_counter *res)
+{
+	return res_counter_resize_limit(res, 0);
+}
 
 ssize_t res_counter_write(struct res_counter *counter, int member,
 		const char __user *userbuf, size_t nbytes, loff_t *pos,

