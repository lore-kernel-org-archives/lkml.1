Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbYDZASh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbYDZASh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760907AbYDZAP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:15:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50643 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757440AbYDZAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:50 -0400
Message-Id: <20080426001549.958203000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:54 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 06/11] cpu: change some globals to statics in drivers/base/cpu.c v2
Content-Disposition: inline; filename=mk-static
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- attr_online_map
- attr_possible_map
- attr_present_map

- cpu_state_attr [v2]

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Mike Travis <travis@sgi.com>

---
v2: changed cpu_state_attr to static

8ab09fe4313384faa5e3577d99845cedccb245bc diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 6fe4174..da6f4ae 100644
---
 drivers/base/cpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.sched.orig/drivers/base/cpu.c
+++ linux-2.6.sched/drivers/base/cpu.c
@@ -119,7 +119,7 @@ static ssize_t print_cpus_##type(struct 
 {									\
 	return print_cpus_map(buf, &cpu_##type##_map);			\
 }									\
-struct sysdev_class_attribute attr_##type##_map = 			\
+static struct sysdev_class_attribute attr_##type##_map = 		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
 
 print_cpus_func(online);
@@ -127,7 +127,7 @@ print_cpus_func(possible);
 print_cpus_func(present);
 print_cpus_func(system);
 
-struct sysdev_class_attribute *cpu_state_attr[] = {
+static struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_online_map,
 	&attr_possible_map,
 	&attr_present_map,

-- 
