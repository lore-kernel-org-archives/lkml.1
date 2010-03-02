Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0CBX6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:58:01 -0500
Received: from kroah.org ([198.145.64.141]:38524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0CBX3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andi Kleen <ak@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/62] sysdev: fix missing s390 conversion
Date: Tue,  2 Mar 2010 15:28:13 -0800
Message-Id: <1267572541-410-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

In linux-next "sysdev: Pass attribute in sysdev_class attributes show/store"
forgot to convert one place in s390 code. Here is the missing part.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/kernel/smp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index e212109..29f65bc 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1033,7 +1033,9 @@ static ssize_t __ref rescan_store(struct sysdev_class *class,
 static SYSDEV_CLASS_ATTR(rescan, 0200, NULL, rescan_store);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static ssize_t dispatching_show(struct sysdev_class *class, char *buf)
+static ssize_t dispatching_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	ssize_t count;
 
-- 
1.7.0.1

