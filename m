Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbZCTVAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbZCTVAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759799AbZCTU47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:59 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:49151 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759651AbZCTU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:58 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 13/13] PCI Hotplug: schedule fakephp for feature removal
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:56 -0600
Message-ID: <20090320205656.12275.64680.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the PCI core is capable of function-level remove and rescan
as well as bus-level rescan, there's no functional need to keep fakephp
anymore.

We keep it around for userspace compatibility reasons, schedule removal
in three years.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/feature-removal-schedule.txt |   33 ++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20d3b94..8851eea 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -335,6 +335,7 @@ Why:	In 2.6.18 the Secmark concept was introduced to replace the "compat_net"
 	Secmark, it is time to deprecate the older mechanism and start the
 	process of removing the old code.
 Who:	Paul Moore <paul.moore@hp.com>
+
 ---------------------------
 
 What:	sysfs ui for changing p4-clockmod parameters
@@ -344,3 +345,35 @@ Why:	See commits 129f8ae9b1b5be94517da76009ea956e89104ce8 and
 	Removal is subject to fixing any remaining bugs in ACPI which may
 	cause the thermal throttling not to happen at the right time.
 Who:	Dave Jones <davej@redhat.com>, Matthew Garrett <mjg@redhat.com>
+
+---------------------------
+
+What:	fakephp and associated sysfs files in /sys/bus/pci/slots/
+When:	2011
+Why:	In 2.6.27, the semantics of /sys/bus/pci/slots was redefined to
+	represent a machine's physical PCI slots. The change in semantics
+	had userspace implications, as the hotplug core no longer allowed
+	drivers to create multiple sysfs files per physical slot (required
+	for multi-function devices, e.g.). fakephp was seen as a developer's
+	tool only, and its interface changed. Too late, we learned that
+	there were some users of the fakephp interface.
+
+	In 2.6.30, the original fakephp interface was restored. At the same
+	time, the PCI core gained the ability that fakephp provided, namely
+	function-level hot-remove and hot-add.
+
+	Since the PCI core now provides the same functionality, exposed in:
+
+		/sys/bus/pci/rescan
+		/sys/bus/pci/devices/.../remove
+		/sys/bus/pci/devices/.../rescan
+
+	there is no functional reason to maintain fakephp as well.
+
+	We will keep the existing module so that 'modprobe fakephp' will
+	present the old /sys/bus/pci/slots/... interface for compatibility,
+	but users are urged to migrate their applications to the API above.
+
+	After a reasonable transition period, we will remove the legacy
+	fakephp interface.
+Who:	Alex Chiang <achiang@hp.com>

