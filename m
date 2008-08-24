Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYHXWoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYHXWoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYHXWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:44:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:40729 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbYHXWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AfxwhwelJJIiLliEjeX4vnPvUMALRFd+me1HG9iMGtOlHYANoVZ7euj5JySHCTQPWK
         8rpR5gaAuMcX2wKZDEF9fS9njTR5frVMf9Pa2k+y1vu32XQvZvUIu5bdMzE9Z7wWgI8V
         zb731txIJqubRxJXuVl8moJ5buBYpeyG82tQs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Bernhard Walle <bwalle@suse.de>, Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: 
Date: Sun, 24 Aug 2008 15:43:15 -0700
Message-Id: <1219617795-9774-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

may need user to have new kexec tools that could create e820 table
from /sys/firmware/memmap instead of /proc/iomem for second kernel

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1279,6 +1279,10 @@ void __init e820_reserve_resources(void)
 
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
 	for (i = 0; i < e820.nr_map; i++) {
+		if (e820.map[i].type != E820_RAM) {
+			res++;
+			continue;
+		}
 		end = e820.map[i].addr + e820.map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
 		if (end > 0x100000000ULL) {
