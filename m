Return-Path: <linux-kernel-owner+w=401wt.eu-S1765159AbZDHNCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765159AbZDHNCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763891AbZDHNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:01:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:41574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764258AbZDHNBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:01:24 -0400
Date: Wed, 8 Apr 2009 13:00:55 GMT
From: Russ Anderson <rja@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403222423.GA28546@sgi.com>
References: <20090403222423.GA28546@sgi.com>
Subject: [tip:x86/uv] x86: prevent /sys/firmware/sgi_uv from being created on non-uv systems
Message-ID: <tip-06aa05b307e8efbc278f201198e7cdf3877bc5c2@git.kernel.org>
Git-Commit-ID: 06aa05b307e8efbc278f201198e7cdf3877bc5c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 13:00:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06aa05b307e8efbc278f201198e7cdf3877bc5c2
Gitweb:     http://git.kernel.org/tip/06aa05b307e8efbc278f201198e7cdf3877bc5c2
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Fri, 3 Apr 2009 17:24:23 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 14:58:10 +0200

x86: prevent /sys/firmware/sgi_uv from being created on non-uv systems

/sys/firmware/sgi_uv should only be created on uv systems.

Signed-off-by: Russ Anderson <rja@sgi.com>
LKML-Reference: <20090403222423.GA28546@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/uv_sysfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/uv_sysfs.c b/arch/x86/kernel/uv_sysfs.c
index 67f9b9d..36afb98 100644
--- a/arch/x86/kernel/uv_sysfs.c
+++ b/arch/x86/kernel/uv_sysfs.c
@@ -21,6 +21,7 @@
 
 #include <linux/sysdev.h>
 #include <asm/uv/bios.h>
+#include <asm/uv/uv.h>
 
 struct kobject *sgi_uv_kobj;
 
@@ -47,6 +48,9 @@ static int __init sgi_uv_sysfs_init(void)
 {
 	unsigned long ret;
 
+	if (!is_uv_system())
+		return -ENODEV;
+
 	if (!sgi_uv_kobj)
 		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
 	if (!sgi_uv_kobj) {
