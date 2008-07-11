Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYGKT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYGKT7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYGKT7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:59:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55945 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYGKT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:59:04 -0400
Date: Fri, 11 Jul 2008 12:58:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: bwalle@suse.de, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] firmware: fix memmap printk format warnings
Message-Id: <20080711125836.59cb0c04.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
cc: Bernhard Walle <bwalle@suse.de>

Fix firmware/memmap printk format warnings:

linux-next-20080711/drivers/firmware/memmap.c:156: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
linux-next-20080711/drivers/firmware/memmap.c:161: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/firmware/memmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-next-20080711.orig/drivers/firmware/memmap.c
+++ linux-next-20080711/drivers/firmware/memmap.c
@@ -153,12 +153,14 @@ int __init firmware_map_add_early(resour
 
 static ssize_t start_show(struct firmware_map_entry *entry, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->start);
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+		(unsigned long long)entry->start);
 }
 
 static ssize_t end_show(struct firmware_map_entry *entry, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->end);
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+		(unsigned long long)entry->end);
 }
 
 static ssize_t type_show(struct firmware_map_entry *entry, char *buf)


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
