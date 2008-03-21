Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYCUG4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYCUG4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYCUG43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:56:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:53848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYCUG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=UtuF+EeTl+5hGkCt318glswthparGi+4fcfPFfvfVdjzofQfetem633yWSvOHoPR56EcE2VX1hdWsusbi3vkZua3fkbxF0oZTGzvX7mBT7XJ4szE8kJpWzbvvU5LQDwLKDG45YhFBexem1r7Yieh/J+c5soDDu7wZz3M5Q/V6MY=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86_64: allcate e820 resource struct all together
Date: Thu, 20 Mar 2008 23:57:21 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803202357.22045.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't need to allocate that one by one

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -237,9 +237,9 @@ unsigned long __init e820_end_of_ram(voi
 void __init e820_reserve_resources(void)
 {
 	int i;
+	struct resource *res;
+	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
 	for (i = 0; i < e820.nr_map; i++) {
-		struct resource *res;
-		res = alloc_bootmem_low(sizeof(struct resource));
 		switch (e820.map[i].type) {
 		case E820_RAM:	res->name = "System RAM"; break;
 		case E820_ACPI:	res->name = "ACPI Tables"; break;
@@ -250,6 +250,7 @@ void __init e820_reserve_resources(void)
 		res->end = res->start + e820.map[i].size - 1;
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
+		res++;
 	}
 }
 
