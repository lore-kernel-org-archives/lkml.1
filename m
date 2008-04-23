Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYDWLFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYDWLFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYDWLFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:05:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37075 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083AbYDWLFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:05:47 -0400
Message-ID: <480F1809.4020903@sgi.com>
Date: Wed, 23 Apr 2008 04:05:45 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/base/cpu.c: make code static
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for catching this!

Acked-by: Mike Travis <travis@sgi.com>

This patch makes the following needlessly global code static:
- attr_online_map
- attr_possible_map
- attr_present_map

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8ab09fe4313384faa5e3577d99845cedccb245bc diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 6fe4174..da6f4ae 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -119,7 +119,7 @@ static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
 {									\
 	return print_cpus_map(buf, &cpu_##type##_map);			\
 }									\
-struct sysdev_class_attribute attr_##type##_map = 			\
+static struct sysdev_class_attribute attr_##type##_map = 		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
 
 print_cpus_func(online);
