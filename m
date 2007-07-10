Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXGJOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXGJOa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXGJOaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:30:20 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:38267 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbXGJOaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:30:20 -0400
Message-ID: <46939661.8000801@openvz.org>
Date: Tue, 10 Jul 2007 18:23:29 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 2/3] Make get_pid_ns() return the namespace itself
References: <46939561.4070100@openvz.org>
In-Reply-To: <46939561.4070100@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make get_pid_ns() return the namespace itself to look like
the other getters and make the code using it look nicer.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>

---

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b9a17e0..ddb9a4c 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -24,9 +24,10 @@ struct pid_namespace {
 
 extern struct pid_namespace init_pid_ns;
 
-static inline void get_pid_ns(struct pid_namespace *ns)
+static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 {
 	kref_get(&ns->kref);
+	return ns;
 }
 
 extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
