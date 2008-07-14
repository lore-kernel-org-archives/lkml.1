Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGNLFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGNLFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYGNLFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:05:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48928 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYGNLFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:05:04 -0400
Date: Mon, 14 Jul 2008 20:03:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm] adapt drivers/base/topology.c to new sysfs API
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080714200201.F6E0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch title: fix-driver-topology-type-incompatible.patch
Against: mmotm Jul 14
Applies after: linux-next.patch

if arch_provides_topology_pointers is not defined, topology.c output following warnings.
because sysfs function parameter was changed recently.

  drivers/base/topology.c:106: warning: initialization from incompatible pointer type
  drivers/base/topology.c:107: warning: initialization from incompatible pointer type
  drivers/base/topology.c:110: warning: initialization from incompatible pointer type
  drivers/base/topology.c:111: warning: initialization from incompatible pointer type


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <ak@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/topology.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/drivers/base/topology.c
===================================================================
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -77,7 +77,8 @@ static ssize_t show_##name##_list(struct
 
 #else
 #define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct sys_device *dev, char *buf)	\
+static ssize_t show_##name(struct sys_device *dev,                      \
+			   struct sysdev_attribute *attr, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
 	cpumask_t mask = topology_##name(cpu);				\
@@ -85,7 +86,8 @@ static ssize_t show_##name(struct sys_de
 }
 
 #define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
+static ssize_t show_##name##_list(struct sys_device *dev,               \
+			      struct sysdev_attribute *attr, char *buf) \
 {									\
 	unsigned int cpu = dev->id;					\
 	cpumask_t mask = topology_##name(cpu);				\



