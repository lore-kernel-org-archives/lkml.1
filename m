Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZIKVNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZIKVNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbZIKVNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:13:23 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52531 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbZIKVNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:13:23 -0400
Message-ID: <4AAABD6F.8020008@austin.ibm.com>
Date: Fri, 11 Sep 2009 16:13:19 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] Export memory_sysdev_class
References: <4AAABC55.4070207@austin.ibm.com>
In-Reply-To: <4AAABC55.4070207@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the memory_sysdev_class structure.  This is needed so we can create
a 'release' file in sysfs in addition to the existing 'probe' file in
order to support DLPAR removal of memory on the powerpc/pseries platform.
The new 'release' file will be powerpc/pseries only.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---

Index: powerpc/drivers/base/memory.c
===================================================================
--- powerpc.orig/drivers/base/memory.c	2009-09-11 12:43:40.000000000 -0500
+++ powerpc/drivers/base/memory.c	2009-09-11 12:52:26.000000000 -0500
@@ -28,9 +28,10 @@
 
 #define MEMORY_CLASS_NAME	"memory"
 
-static struct sysdev_class memory_sysdev_class = {
+struct sysdev_class memory_sysdev_class = {
 	.name = MEMORY_CLASS_NAME,
 };
+EXPORT_SYMBOL(memory_sysdev_class);
 
 static const char *memory_uevent_name(struct kset *kset, struct kobject *kobj)
 {
Index: powerpc/include/linux/memory_hotplug.h
===================================================================
--- powerpc.orig/include/linux/memory_hotplug.h	2009-09-11 12:43:44.000000000 -0500
+++ powerpc/include/linux/memory_hotplug.h	2009-09-11 12:52:26.000000000 -0500
@@ -12,6 +12,8 @@
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 
+extern struct sysdev_class memory_sysdev_class;
+
 /*
  * Types for free bootmem.
  * The normal smallest mapcount is -1. Here is smaller value than it.
