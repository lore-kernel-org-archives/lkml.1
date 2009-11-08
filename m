Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZKHQKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZKHQKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZKHQKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:10:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:33613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZKHQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:10:28 -0500
Date: Sun, 8 Nov 2009 16:10:13 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091108155431.GC25940@lenovo>
References: <20091108155431.GC25940@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Use snrpintf while set names for IO-APIC resourses
Message-ID: <tip-4343fe1024e09e17667f95620ed3e69a7a5f4389@git.kernel.org>
Git-Commit-ID: 4343fe1024e09e17667f95620ed3e69a7a5f4389
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4343fe1024e09e17667f95620ed3e69a7a5f4389
Gitweb:     http://git.kernel.org/tip/4343fe1024e09e17667f95620ed3e69a7a5f4389
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 8 Nov 2009 18:54:31 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 17:06:23 +0100

x86, ioapic: Use snrpintf while set names for IO-APIC resourses

We should be ready that one day MAX_IO_APICS may raise its
number. To prevent memory overwrite we're to use safe
snprintf while set IO-APIC resourse name.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20091108155431.GC25940@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ee1c16..24d1458 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4066,7 +4066,7 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 	for (i = 0; i < nr_ioapics; i++) {
 		res[i].name = mem;
 		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		sprintf(mem,  "IOAPIC %u", i);
+		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
 	}
 
