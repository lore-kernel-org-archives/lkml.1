Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZAMB5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZAMB5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbZAMB4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:56:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbZAMB4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:56:16 -0500
Message-ID: <496BF4C0.2070607@redhat.com>
Date: Mon, 12 Jan 2009 20:56:16 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [RFC][PATCH -mm 6/6] kprobes: Support kretprobe and jprobe per-probe
 disabling
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add disable/enable_kretprobe() and disable/enable_jprobe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 Documentation/kprobes.txt |   16 ++++++++++------
 include/linux/kprobes.h   |   17 +++++++++++++++++
 2 files changed, 27 insertions(+), 6 deletions(-)

Index: 2.6.28-mm1/include/linux/kprobes.h
===================================================================
--- 2.6.28-mm1.orig/include/linux/kprobes.h
+++ 2.6.28-mm1/include/linux/kprobes.h
@@ -350,4 +350,21 @@ static inline int enable_kprobe(struct k
 	return -ENOSYS;
 }
 #endif				/* CONFIG_KPROBES */
+static inline int disable_kretprobe(struct kretprobe *rp)
+{
+	return disable_kprobe(&rp->kp);
+}
+static inline int enable_kretprobe(struct kretprobe *rp)
+{
+	return enable_kprobe(&rp->kp);
+}
+static inline int disable_jprobe(struct jprobe *jp)
+{
+	return disable_kprobe(&jp->kp);
+}
+static inline int enable_jprobe(struct jprobe *jp)
+{
+	return enable_kprobe(&jp->kp);
+}
+
 #endif				/* _LINUX_KPROBES_H */
Index: 2.6.28-mm1/Documentation/kprobes.txt
===================================================================
--- 2.6.28-mm1.orig/Documentation/kprobes.txt
+++ 2.6.28-mm1/Documentation/kprobes.txt
@@ -365,21 +365,25 @@ probes) in the specified array, they cle
 incorrect probes. However, other probes in the array are
 unregistered correctly.

-4.7 disable_kprobe
+4.7 disable_*probe

 #include <linux/kprobes.h>
 int disable_kprobe(struct kprobe *kp);
+int disable_kretprobe(struct kretprobe *rp);
+int disable_jprobe(struct jprobe *jp);

-Temporarily disables the specified kprobe. You can enable it again by using
-enable_kprobe(). You must specify the kprobe which has been registered.
+Temporarily disables the specified *probe. You can enable it again by using
+enable_*probe(). You must specify the probe which has been registered.

-4.8 enable_kprobe
+4.8 enable_*probe

 #include <linux/kprobes.h>
 int enable_kprobe(struct kprobe *kp);
+int enable_kretprobe(struct kretprobe *rp);
+int enable_jprobe(struct jprobe *jp);

-Enables kprobe which has been disabled by disable_kprobe(). You must specify
-the kprobe which has been registered.
+Enables *probe which has been disabled by disable_*probe(). You must specify
+the probe which has been registered.

 5. Kprobes Features and Limitations

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com




