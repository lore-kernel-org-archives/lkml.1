Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbYDWKBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbYDWKBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYDWJxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:14 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36980 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbYDWJxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:12 -0400
Date: Wed, 23 Apr 2008 12:52:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/base/cpu.c: make code static
Message-ID: <20080423095233.GL28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

