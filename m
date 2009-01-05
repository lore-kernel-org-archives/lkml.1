Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZAEUeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZAEUeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZAEUdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:33:55 -0500
Received: from relay3.sgi.com ([192.48.171.31]:44252 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752867AbZAEUdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:33:54 -0500
Message-Id: <20090105203352.096838000@polaris-admin.engr.sgi.com>
References: <20090105203351.785422000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 12:33:53 -0800
From: Mike Travis <travis@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
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

-- 
