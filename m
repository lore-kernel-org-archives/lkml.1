Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZADNUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZADNUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZADNSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:15 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54029 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbZADNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:09 -0500
Message-Id: <20090104131800.181545000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:01 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 02/11] cpumask: update local_cpus_show to use new cpumask API
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=cpumask:update-local_cpus_show.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce stack usage, use new cpumask API.

Replace the local cpumask_t variable with a pointer to the
const cpumask that needs to be printed.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci-sysfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6-for-ingo.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6-for-ingo/drivers/pci/pci-sysfs.c
@@ -70,11 +70,11 @@ static ssize_t broken_parity_status_stor
 static ssize_t local_cpus_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {		
-	cpumask_t mask;
+	const struct cpumask *mask;
 	int len;
 
-	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, &mask);
+	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
+	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
@@ -84,11 +84,11 @@ static ssize_t local_cpus_show(struct de
 static ssize_t local_cpulist_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	cpumask_t mask;
+	const struct cpumask *mask;
 	int len;
 
-	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpulist_scnprintf(buf, PAGE_SIZE-2, &mask);
+	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
+	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;

