Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZAMB4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZAMB4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbZAMBzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:55:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758350AbZAMBzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:55:45 -0500
Message-ID: <496BF49F.6090102@redhat.com>
Date: Mon, 12 Jan 2009 20:55:43 -0500
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
Subject: [RFC][PATCH -mm 2/6] kprobes: move EXPORT_SYMBOL_GPL just after function
 definitions
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup positions of EXPORT_SYMBOL_GPL in kernel/kprobes.c according to
checkpatch.pl.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/kprobes.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

Index: 2.6.28-mm1/kernel/kprobes.c
===================================================================
--- 2.6.28-mm1.orig/kernel/kprobes.c
+++ 2.6.28-mm1/kernel/kprobes.c
@@ -718,6 +718,7 @@ out:

 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kprobe);

 /*
  * Unregister a kprobe without a scheduler synchronization.
@@ -796,11 +797,13 @@ int __kprobes register_kprobes(struct kp
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kprobes);

 void __kprobes unregister_kprobe(struct kprobe *p)
 {
 	unregister_kprobes(&p, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_kprobe);

 void __kprobes unregister_kprobes(struct kprobe **kps, int num)
 {
@@ -819,6 +822,7 @@ void __kprobes unregister_kprobes(struct
 		if (kps[i]->addr)
 			__unregister_kprobe_bottom(kps[i]);
 }
+EXPORT_SYMBOL_GPL(unregister_kprobes);

 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
@@ -858,16 +862,19 @@ int __kprobes register_jprobes(struct jp
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_jprobes);

 int __kprobes register_jprobe(struct jprobe *jp)
 {
 	return register_jprobes(&jp, 1);
 }
+EXPORT_SYMBOL_GPL(register_jprobe);

 void __kprobes unregister_jprobe(struct jprobe *jp)
 {
 	unregister_jprobes(&jp, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_jprobe);

 void __kprobes unregister_jprobes(struct jprobe **jps, int num)
 {
@@ -887,6 +894,7 @@ void __kprobes unregister_jprobes(struct
 			__unregister_kprobe_bottom(&jps[i]->kp);
 	}
 }
+EXPORT_SYMBOL_GPL(unregister_jprobes);

 #ifdef CONFIG_KRETPROBES
 /*
@@ -982,6 +990,7 @@ int __kprobes register_kretprobe(struct
 		free_rp_inst(rp);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kretprobe);

 int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
@@ -999,11 +1008,13 @@ int __kprobes register_kretprobes(struct
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kretprobes);

 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
 	unregister_kretprobes(&rp, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobe);

 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
@@ -1025,24 +1036,30 @@ void __kprobes unregister_kretprobes(str
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobes);

 #else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(register_kretprobe);

 int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(register_kretprobes);
+
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobe);

 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobes);

 static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 					   struct pt_regs *regs)
@@ -1409,16 +1426,5 @@ late_initcall(debugfs_kprobe_init);

 module_init(init_kprobes);

-EXPORT_SYMBOL_GPL(register_kprobe);
-EXPORT_SYMBOL_GPL(unregister_kprobe);
-EXPORT_SYMBOL_GPL(register_kprobes);
-EXPORT_SYMBOL_GPL(unregister_kprobes);
-EXPORT_SYMBOL_GPL(register_jprobe);
-EXPORT_SYMBOL_GPL(unregister_jprobe);
-EXPORT_SYMBOL_GPL(register_jprobes);
-EXPORT_SYMBOL_GPL(unregister_jprobes);
+/* defined in arch/.../kernel/kprobes.c */
 EXPORT_SYMBOL_GPL(jprobe_return);
-EXPORT_SYMBOL_GPL(register_kretprobe);
-EXPORT_SYMBOL_GPL(unregister_kretprobe);
-EXPORT_SYMBOL_GPL(register_kretprobes);
-EXPORT_SYMBOL_GPL(unregister_kretprobes);
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com




