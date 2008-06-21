Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbYFUSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbYFUSSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYFUSS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:18:29 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:53415 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYFUSSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ozYRCLlAd6A9tYLt2C/BaOk89SrVjODBv0zVZ0TeB8pNclpSLeYilgktZ0a2wimEVM
         pbgm65IsoXQPTRLznOM+YmusVwpJLDdxhIaEZd1W6EQQiAl3RFVvx1ldW6jvcWpAxmLj
         TFwx2VHpZiDQBERrF6EU3SuQxg7oobS6Pac/s=
Message-ID: <485D45C3.9060605@gmail.com>
Date: Sat, 21 Jun 2008 23:47:39 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Masami Hiramatsu <mhiramat@redhat.com>, ananth@in.ibm.com,
       jkenisto@us.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] kprobes: enable clean usage of get_kprobe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow clean use of get_kprobe() outside of core kprobe code. Ftrace makes use
of get_kprobe to identify probes installed on mcount call-sites.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 1036631..04a3556 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -259,6 +259,10 @@ void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 struct jprobe;
 struct kretprobe;
 
+static inline struct kprobe *get_kprobe(void *addr)
+{
+	return NULL;
+}
 static inline struct kprobe *kprobe_running(void)
 {
 	return NULL;
