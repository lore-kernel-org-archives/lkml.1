Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZKHNHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZKHNHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZKHNHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:07:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:59131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZKHNHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:07:19 -0500
Date: Sun, 8 Nov 2009 13:06:53 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, rusty@rustcorp.com.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, rusty@rustcorp.com.au,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091026202811.GD5321@lenovo>
References: <20091026202811.GD5321@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq: Do not attempt to create subdirectories if /proc/irq/<irq> failed
Message-ID: <tip-c82a43d40b93200a10a9fec0a489791e65e135ca@git.kernel.org>
Git-Commit-ID: c82a43d40b93200a10a9fec0a489791e65e135ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c82a43d40b93200a10a9fec0a489791e65e135ca
Gitweb:     http://git.kernel.org/tip/c82a43d40b93200a10a9fec0a489791e65e135ca
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 26 Oct 2009 23:28:11 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 13:14:22 +0100

irq: Do not attempt to create subdirectories if /proc/irq/<irq> failed

If a parent directory (ie /proc/irq/<irq>) could not be created
we should not attempt to create subdirectories. Otherwise it
would lead that "smp_affinity" and "spurious" entries are may be
registered under /proc root instead of a proper place.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20091026202811.GD5321@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/proc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 692363d..dfef5b9 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -214,6 +214,8 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 
 	/* create /proc/irq/1234 */
 	desc->dir = proc_mkdir(name, root_irq_dir);
+	if (!desc->dir)
+		return;
 
 #ifdef CONFIG_SMP
 	/* create /proc/irq/<irq>/smp_affinity */
