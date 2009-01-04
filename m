Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZADNTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZADNTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZADNSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:14 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54031 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570AbZADNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:09 -0500
Message-Id: <20090104131800.317064000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:02 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=cpumask:update-pci_bus_show_cpuaffinity.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce stack usage, use new cpumask API.

Replace the local cpumask_t variable with a pointer to the
const cpumask that needs to be printed.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/probe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6-for-ingo.orig/drivers/pci/probe.c
+++ linux-2.6-for-ingo/drivers/pci/probe.c
@@ -51,12 +51,12 @@ static ssize_t pci_bus_show_cpuaffinity(
 					char *buf)
 {
 	int ret;
-	cpumask_t cpumask;
+	const struct cpumask *cpumask;
 
-	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
+	cpumask = cpumask_of_pcibus(to_pci_bus(dev));
 	ret = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, &cpumask) :
-		cpumask_scnprintf(buf, PAGE_SIZE-2, &cpumask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
 	buf[ret++] = '\n';
 	buf[ret] = '\0';
 	return ret;

