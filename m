Return-Path: <linux-kernel-owner+w=401wt.eu-S1764267AbYEIRgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764267AbYEIRgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYEIRgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:36:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48559 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYEIRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:36:35 -0400
Date: Fri, 9 May 2008 10:36:47 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] ibmaem: Overview of the driver
Message-ID: <20080509173647.GK16404@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A brief overview of what this driver does

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/ibmaem |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/ibmaem b/Documentation/hwmon/ibmaem
new file mode 100644
index 0000000..2fefaf5
--- /dev/null
+++ b/Documentation/hwmon/ibmaem
@@ -0,0 +1,37 @@
+Kernel driver ibmaem
+======================
+
+Supported systems:
+  * Any recent IBM System X server with Active Energy Manager support.
+    This includes the x3350, x3550, x3650, x3655, x3755, x3850 M2,
+    x3950 M2, and certain HS2x/LS2x/QS2x blades.  The IPMI host interface
+    driver ("ipmi-si") needs to be loaded for this driver to do anything.
+    Prefix: 'ibmaem'
+    Datasheet: Not available
+
+Author: Darrick J. Wong
+
+Description
+-----------
+
+This driver implements sensor reading support for the energy and power
+meters available on various IBM System X hardware through the BMC.  All
+sensor banks will be exported as platform devices; this driver can talk
+to both v1 and v2 interfaces.  This driver is completely separate from the
+older ibmpex driver.
+
+The v1 AEM interface has a simple set of features to monitor energy use.
+There is a register that displays an estimate of raw energy consumption
+since the last BMC reset, and a power sensor that returns average power
+use over a configurable interval.
+
+The v2 AEM interface is a bit more sophisticated, being able to present
+a wider range of energy and power use registers, the power cap as
+set by the AEM software, and temperature sensors.
+
+Special Features
+----------------
+
+The "power_cap" value displays the current system power cap, as set by
+the Active Energy Manager software.  Setting the power cap from the host
+is not currently supported.
