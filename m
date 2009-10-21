Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbZJUOo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbZJUOo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZJUOo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:44:28 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37484 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZJUOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:44:27 -0400
Message-ID: <4ADF1E42.3020907@austin.ibm.com>
Date: Wed, 21 Oct 2009 09:44:18 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5 v4] Export memory_sysdev_class
References: <4ADF1C49.2030201@austin.ibm.com>
In-Reply-To: <4ADF1C49.2030201@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the memory_sysdev_class structure.  This is needed so we can create
a 'release' file in sysfs in addition to the existing 'probe' file in
order to support DLPAR removal of memory on the powerpc/pseries platform.
The new 'release' file will be powerpc/pseries only.

Signed-off-by: Nathan Fontenot <nfont at austin.ibm.com>
---

Index: powerpc/drivers/base/memory.c
===================================================================
--- powerpc.orig/drivers/base/memory.c	2009-10-19 11:56:51.000000000 -0500
+++ powerpc/drivers/base/memory.c	2009-10-19 11:59:36.000000000 -0500
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
--- powerpc.orig/include/linux/memory_hotplug.h	2009-10-19 11:58:43.000000000 -0500
+++ powerpc/include/linux/memory_hotplug.h	2009-10-19 11:59:36.000000000 -0500
@@ -12,6 +12,8 @@
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 
+extern struct sysdev_class memory_sysdev_class;
+
 /*
  * Types for free bootmem.
  * The normal smallest mapcount is -1. Here is smaller value than it.

