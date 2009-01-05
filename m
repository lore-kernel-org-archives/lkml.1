Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZAEUek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZAEUek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZAEUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:33:56 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54475 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbZAEUdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:33:55 -0500
Message-Id: <20090105203351.959649000@polaris-admin.engr.sgi.com>
References: <20090105203351.785422000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 12:33:52 -0800
From: Mike Travis <travis@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cpumask: update local_cpus_show to use new cpumask API
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

-- 
